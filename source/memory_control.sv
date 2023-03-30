/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
/*
modport cc
    input   iREN, dREN, dWEN, dstore, iaddr, daddr,
            // ram inputs
            ramload, ramstate,
            // coherence inputs from cache
            ccwrite, cctrans,
            // cache outputs
    output  iwait, dwait, iload, dload,
            // ram outputs
            ramstore, ramaddr, ramWEN, ramREN,
            // coherence outputs to cache
            ccwait, ccinv, ccsnoopaddr //UNUSED LAB 3-4
*/

  // type import
  import cpu_types_pkg::*;
  import custom_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 1;

  coherence_t mc;
  coherence_t next_mc;

  memory_control_t mc_state;
  memory_control_t next_mc_state;

  always_ff @(posedge CLK, negedge nRST) begin: MEM_LOGIC
    if (~nRST) begin
      mc_state <= IDLE;
      mc <= '0;
    end else begin
      mc_state <= next_mc_state;
      // arb can prob change to a local variable since we dont use anything else in the struct lol, 
      // unless we wanna do more w/ the struct <- delete
      mc <= next_mc; 
    end
  end

  always_comb begin: NEXT_LOGIC
  /*
    // cache inputs
    input   iREN, dREN, dWEN, dstore, iaddr, daddr,
    // ram inputs
    ramload, ramstate,
    // coherence inputs from cache
    ccwrite, cctrans,
  */

    next_mc_state = mc_state;

    case (mc_state)
      IDLE: begin
        if (ccif.dREN[mc.arb] & ~ccif.ccwrite[mc.arb]) 
          // go to PrRd when only dREN is high
          next_mc_state = PRRD;
        
        else if (ccif.dWEN[mc.arb] & ~ccif.ccwrite[mc.arb]) 
          // go to general write to bus state when dWEN is high
          next_mc_state = CACWB;

        else if (ccif.dWEN[mc.arb] & ccif.ccwrite[mc.arb]) 
          // if dcache is attempting to do a write but misses
          // we need to do a read from mem with coherence
          next_mc_state = PRWR;
        
        else if (ccif.iREN[mc.arb]) 
          // general iread stuff 
          next_mc_state = IMEM;
      end

      PRRD: begin
        if (ccif.ccwrite[~mc.arb]) 
          // if the other cache has our data, go to BUSWb1 to use its values
          next_mc_state = BUSWB1;
        else
          // otherwise we can just go to main mem grabbing it
          next_mc_state = BUSRD1;
      end

      PRWR: begin
        if (ccif.ccwrite[~mc.arb]) 
          // if the other cache has our data, go to BUSWb1 to use its values
          next_mc_state = BUSWBX1; //note that these states will invalidate the other cache
        else
          // otherwise grab from main mem
          next_mc_state = BUSRDX1;
      end

      // Non-X value states
      BUSWB1:   next_mc_state = (ccif.ramstate == ACCESS) ? BUSWB2 : mc_state; //will update main mem

      BUSWB2:   next_mc_state = (ccif.ramstate == ACCESS) ? IDLE : mc_state;  //will update main mem

      BUSRD1:   next_mc_state = (ccif.ramstate == ACCESS) ? BUSRD2 : mc_state;  //will update main mem

      BUSRD2:   next_mc_state = (ccif.ramstate == ACCESS) ? IDLE : mc_state;  //will update main mem


      // X side states will not update main mem
      BUSWBX1:  next_mc_state = BUSWBX2; // immediate advance because from cache

      BUSWBX2:  next_mc_state = IDLE; // immediate advance because data from cache

      BUSRDX1:  next_mc_state = (ccif.ramstate == ACCESS) ? BUSRDX2 : mc_state;

      BUSRDX2:  next_mc_state = (ccif.ramstate == ACCESS) ? IDLE : mc_state;

      // Instruction Fetch
      IMEM: next_mc_state = (ccif.ramstate == ACCESS) ? IDLE : mc_state;

      // Flush to RAM
      CACWB: next_mc_state = (ccif.ramstate == ACCESS) ? IDLE : mc_state;
      
    endcase
  end

  always_comb begin: OUT_LOGIC
  /*
    // cache outputs
    output  iwait, dwait, iload, dload,
    // ram outputs
    ramstore, ramaddr, ramWEN, ramREN,
    // coherence outputs to cache
    ccwait, ccinv, ccsnoopaddr
  */

    // Set defaults for cache inputs
    ccif.iwait = 2'b11;
    ccif.dwait = 2'b11;
    ccif.iload = '0;
    ccif.dload = '0;

    // Set memory defaults
    ccif.ramWEN = 1'b0;
    ccif.ramREN = 1'b0;
    ccif.ramaddr  = '0;
    ccif.ramstore = '0;
    
    // Set coherence defaults
    ccif.ccwait = '0;
    ccif.ccinv  = '0;
    ccif.ccsnoopaddr = '0;

    case (mc_state)

      /********************
      * Read path handling
      *********************/
      PRRD: begin //snoop into opposing cache
        // coherency signals
        ccif.ccwait[~mc.arb]      = 1'b1;
        ccif.ccsnoopaddr[~mc.arb] = ccif.daddr[mc.arb];
      end

      BUSRD1: begin //read from main mem
        // cache signals
        ccif.dwait[mc.arb] = ~(ccif.ramstate == ACCESS);
        ccif.dload[mc.arb] = ccif.ramload;

        // memory signals
        ccif.ramREN  = 1'b1;
        ccif.ramaddr = ccif.daddr[mc.arb];
      end

      BUSRD2: begin //read from main mem
        // cache signals
        ccif.dwait[mc.arb] = ~(ccif.ramstate == ACCESS);
        ccif.dload[mc.arb] = ccif.ramload;

        // memory signals
        ccif.ramREN  = 1'b1;
        ccif.ramaddr = ccif.daddr[mc.arb]; 
      end

      BUSWB1: begin //read from other cache, write to main mem
        // cache signals
        ccif.dwait[mc.arb]  = ~(ccif.ramstate == ACCESS); 
        ccif.dload[mc.arb]  = ccif.dstore[~mc.arb];

        // memory signals
        ccif.ramWEN   = 1'b1;
        ccif.ramaddr  = ccif.daddr[~mc.arb];
        ccif.ramstore = ccif.dstore[~mc.arb];

        // coherency signals
        ccif.ccwait[~mc.arb]      = 1'b1;
        ccif.ccsnoopaddr[~mc.arb] = ccif.daddr[mc.arb];
      end

      BUSWB2: begin
        // cache signals
        // ccif.dwait[~mc.arb] = ~(ccif.ramstate == ACCESS);
        ccif.dwait[mc.arb]  = ~(ccif.ramstate == ACCESS);
        ccif.dload[mc.arb]  = ccif.dstore[~mc.arb];

        // memory signals
        ccif.ramWEN   = 1'b1;
        ccif.ramaddr  = ccif.daddr[~mc.arb];
        ccif.ramstore = ccif.dstore[~mc.arb];

        // coherency signals
        ccif.ccwait[~mc.arb]      = 1'b1;
        ccif.ccsnoopaddr[~mc.arb] = ccif.daddr[mc.arb];
      end

      /********************
      * Write path handling
      *********************/
      PRWR: begin
        // coherency signals
        ccif.ccwait[~mc.arb]      = 1'b1;
        ccif.ccsnoopaddr[~mc.arb] = ccif.daddr[mc.arb];
      end

      BUSRDX1:  begin
        // cache signals
        ccif.dwait[mc.arb] = ~(ccif.ramstate == ACCESS);
        ccif.dload = ccif.ramload;

        // memory signals
        ccif.ramREN  = 1'b1;
        ccif.ramaddr = ccif.daddr[mc.arb]; 

        // coherency signals
        ccif.ccwait[~mc.arb] = 1'b1; 
      end

      BUSRDX2:  begin
        // cache signals
        ccif.dwait[mc.arb] = ~(ccif.ramstate == ACCESS);
        ccif.dload = ccif.ramload;

        // memory signals
        ccif.ramREN  = 1'b1;
        ccif.ramaddr = ccif.daddr[mc.arb];

        // coherency signals
        ccif.ccwait[~mc.arb] = 1'b1; // at least need this one so dcache isnt talking to cpu when we are invalidating <- delete
        ccif.ccinv[~mc.arb]  = 1'b1;
      end

      BUSWBX1:  begin
        // cache signals
        // ccif.dwait[~mc.arb] = 1'b0;
        ccif.dwait[mc.arb]  = 1'b0;
        ccif.dload[mc.arb]  = ccif.dstore[~mc.arb];

        // coherency signals
        ccif.ccwait[~mc.arb]      = 1'b1;
        ccif.ccsnoopaddr[~mc.arb] = ccif.daddr[mc.arb];
      end

      BUSWBX2:  begin
        // cache signals
        // ccif.dwait[~mc.arb] = 1'b0;
        ccif.dwait[mc.arb]  = 1'b0;
        ccif.dload[mc.arb]  = ccif.dstore[~mc.arb];

        // coherency signals
        ccif.ccwait[~mc.arb]      = 1'b1;
        ccif.ccinv[~mc.arb]       = 1'b1;
        ccif.ccsnoopaddr[~mc.arb] = ccif.daddr[mc.arb];
      end

      /********************
      * I-fetch handling
      *********************/
      IMEM: begin
        // cache signals
        ccif.iwait[mc.arb] = ~(ccif.ramstate == ACCESS);
        ccif.iload[mc.arb] = ccif.ramload;

        // memory signals
        ccif.ramREN  = 1'b1;
        ccif.ramaddr = ccif.iaddr[mc.arb];
      end

      /********************
      * Flush handling
      *********************/
      CACWB: begin
        // memory signals
        ccif.ramWEN   = 1'b1;
        ccif.ramaddr  = ccif.daddr[mc.arb];
        ccif.ramstore = ccif.dstore[mc.arb];

        ccif.dwait[mc.arb] = ~(ccif.ramstate == ACCESS);
      end

    endcase
  end

  always_comb begin : arbiternextlogic
      next_mc.arb = mc.arb;

      if (mc_state == IDLE && next_mc_state == IDLE) begin //make sure to only flip the arbiter bit when nothing is going on
        if (ccif.dREN[mc.arb] | ccif.dWEN[mc.arb] | ccif.iREN[mc.arb]) 
          next_mc.arb = mc.arb;
        else if (ccif.dREN[~mc.arb] | ccif.dWEN[~mc.arb] | ccif.iREN[~mc.arb])
          next_mc.arb = ~mc.arb;
      end 
  end

endmodule
