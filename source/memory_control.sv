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

  mc_t mc;
  mc_t next_mc;

  memory_control_t mc_state;
  memory_control_t next_mc_state;

  always_ff @(posedge CLK, negedge nRST) begin: MEM_LOGIC
    if (~nRST) begin
      mc_state <= IDLE;
      mc <= '0;
      mc.iwait <= 2'b11;
      mc.dwait <= 2'b11;
    end else begin
      mc_state <= next_mc_state;
      // arb can prob change to a local variable since we dont use anything else in the struct lol, 
      // unless we wanna do more w/ the struct <- delete
      mc <= next_mc; 
    end
  end


  always_comb begin: INPUT_LATCHING
    next_mc.iREN     = ccif.iREN;
    next_mc.dREN     = ccif.dREN;
    next_mc.dWEN     = ccif.dWEN;
    next_mc.dstore   = ccif.dstore;
    next_mc.iaddr    = ccif.iaddr;
    next_mc.daddr    = ccif.daddr;
    next_mc.ramload  = ccif.ramload;
    next_mc.ramstate = ccif.ramstate;
    next_mc.ccwrite  = ccif.ccwrite;
    next_mc.cctrans  = ccif.cctrans;
  end


  always_comb begin: OPUTPUT_LATCHING
    ccif.iwait          = (next_mc_state != mc_state) ? mc.iwait : 2'b11;
    ccif.dwait          = (next_mc_state != mc_state) ? mc.dwait : 2'b11;
    ccif.iload          = mc.iload;
    ccif.dload          = mc.dload;
    ccif.ramWEN         = mc.ramWEN;
    ccif.ramREN         = mc.ramREN;
    ccif.ramaddr        = mc.ramaddr;
    ccif.ramstore       = mc.ramstore;
    ccif.ccwait         = mc.ccwait;
    ccif.ccinv          = mc.ccinv;
    ccif.ccsnoopaddr    = mc.ccsnoopaddr;
    
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
    next_mc.delay = 0;

    case (mc_state)
      IDLE: begin
        if (mc.dREN[mc.arb] & ~mc.ccwrite[mc.arb]) 
          // go to PrRd when only dREN is high
          next_mc_state = PRRD;
        
        else if (mc.dWEN[mc.arb] & ~mc.ccwrite[mc.arb]) 
          // go to general write to bus state when dWEN is high
          next_mc_state = CACWB;

        else if (mc.dWEN[mc.arb] & mc.ccwrite[mc.arb]) 
          // if dcache is attempting to do a write but misses
          // we need to do a read from mem with coherence
          next_mc_state = PRWR;
        
        else if (mc.iREN[mc.arb]) 
          // general iread stuff 
          next_mc_state = IMEM;
      end

      PRRD: begin
        if (mc.ccwrite[~mc.arb]) 
          // if the other cache has our data, go to BUSWb1 to use its values
          next_mc_state = BUSWB1;
        else
          // otherwise we can just go to main mem grabbing it
          next_mc_state = BUSRD1;
      end

      PRWR: begin
        if (mc.ccwrite[~mc.arb]) 
          // if the other cache has our data, go to BUSWb1 to use its values
          next_mc_state = BUSWBX1; //note that these states will invalidate the other cache
        else
          // otherwise grab from main mem
          next_mc_state = BUSRDX1;
      end

      // Non-X value states
      BUSWB1:   next_mc_state = (mc.ramstate == ACCESS) ? BUSWB2 : mc_state; //will update main mem

      BUSWB2:   next_mc_state = (mc.ramstate == ACCESS) ? IDLE : mc_state;  //will update main mem

      BUSRD1:   next_mc_state = (mc.ramstate == ACCESS) ? BUSRD2 : mc_state;  //will update main mem

      BUSRD2:   next_mc_state = (mc.ramstate == ACCESS) ? IDLE : mc_state;  //will update main mem


      // X side states will not update main mem
      BUSWBX1:  next_mc_state = BUSWBX2; // immediate advance because from cache

      BUSWBX2:  next_mc_state = IDLE; // immediate advance because data from cache

      BUSRDX1:  next_mc_state = (mc.ramstate == ACCESS) ? BUSRDX2 : mc_state;

      BUSRDX2:  next_mc_state = (mc.ramstate == ACCESS) ? IDLE : mc_state;

      // Instruction Fetch
      IMEM: next_mc_state = (mc.ramstate == ACCESS) ? IDLE : mc_state;

      // Flush to RAM
      CACWB: next_mc_state = (mc.ramstate == ACCESS) ? IDLE : mc_state;
      
    endcase

    if (mc.cctrans != 0) begin
      next_mc_state = mc_state;
      next_mc.delay = mc.delay;
    end

    if (mc.delay == 4) begin
      next_mc.delay = 0;
    end
    else if (next_mc_state != mc_state) begin
      next_mc.delay = mc.delay + 1;
      next_mc_state = mc_state;
    end

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
    next_mc.iwait = 2'b11;
    next_mc.dwait = 2'b11;
    next_mc.iload = '0;
    next_mc.dload = '0;

    // Set memory defaults
    next_mc.ramWEN = 1'b0;
    next_mc.ramREN = 1'b0;
    next_mc.ramaddr  = '0;
    next_mc.ramstore = '0;
    
    // Set coherence defaults
    next_mc.ccwait = '0;
    next_mc.ccinv  = '0;
    next_mc.ccsnoopaddr = '0;

    if (mc.cctrans[0] == 1) begin
      next_mc.ccsnoopaddr[1] = mc.daddr[0];
      next_mc.ccinv = 2'b10;
      next_mc.ccwait = 2'b10;
    end 
    else if (mc.cctrans[1] == 1) begin
      next_mc.ccsnoopaddr[0] = mc.daddr[1];
      next_mc.ccinv = 2'b01;
      next_mc.ccwait = 2'b01;
    end 

    else if (mc.ccwait != 0) begin
      next_mc.ramWEN = 1'b0;
      next_mc.ramREN = 1'b0;
    end
    // else if (mc.delay != 0) begin
    //   next_mc.iwait = 2'b11;
    //   next_mc.dwait = 2'b11; 

    //   next_mc.ccwait = mc.ccwait;
    //   next_mc.ccinv  = mc.ccinv;
    //   next_mc.ccsnoopaddr = mc.ccsnoopaddr;

    //   next_mc.ramWEN = mc.ramWEN;
    //   next_mc.ramREN = mc.ramREN;
    //   next_mc.ramaddr  = mc.ramaddr;
    //   next_mc.ramstore = mc.ramstore;

    // end
    else begin 
      case (mc_state)

      /********************
      * Read path handling
      *********************/
      PRRD: begin //snoop into opposing cache
        // coherency signals
        next_mc.ccwait[~mc.arb]      = 1'b1;
        next_mc.ccsnoopaddr[~mc.arb] = mc.daddr[mc.arb];
      end

      BUSRD1: begin //read from main mem
        // cache signals
        next_mc.dwait[mc.arb] = ~(mc.ramstate == ACCESS);
        next_mc.dload[mc.arb] = mc.ramload;

        // memory signals
        next_mc.ramREN  = 1'b1;
        next_mc.ramaddr = mc.daddr[mc.arb];
      end

      BUSRD2: begin //read from main mem
        // cache signals
        next_mc.dwait[mc.arb] = ~(mc.ramstate == ACCESS);
        next_mc.dload[mc.arb] = mc.ramload;

        // memory signals
        next_mc.ramREN  = 1'b1;
        next_mc.ramaddr = mc.daddr[mc.arb]; 
      end

      BUSWB1: begin //read from other cache, write to main mem
        // cache signals
        next_mc.dwait[mc.arb]  = ~(mc.ramstate == ACCESS); 
        next_mc.dload[mc.arb]  = mc.dstore[~mc.arb];

        // memory signals
        next_mc.ramWEN   = 1'b1;
        next_mc.ramaddr  = mc.daddr[~mc.arb];
        next_mc.ramstore = mc.dstore[~mc.arb];

        // coherency signals
        next_mc.ccwait[~mc.arb]      = 1'b1;
        next_mc.ccsnoopaddr[~mc.arb] = mc.daddr[mc.arb];
      end

      BUSWB2: begin
        // cache signals
        // mc.dwait[~mc.arb] = ~(mc.ramstate == ACCESS);
        next_mc.dwait[mc.arb]  = ~(mc.ramstate == ACCESS);
        next_mc.dload[mc.arb]  = mc.dstore[~mc.arb];

        // memory signals
        next_mc.ramWEN   = 1'b1;
        next_mc.ramaddr  = mc.daddr[~mc.arb];
        next_mc.ramstore = mc.dstore[~mc.arb];

        // coherency signals
        next_mc.ccwait[~mc.arb]      = 1'b1;
        next_mc.ccsnoopaddr[~mc.arb] = mc.daddr[mc.arb];
      end

      /********************
      * Write path handling
      *********************/
      PRWR: begin
        // coherency signals
        next_mc.ccwait[~mc.arb]      = 1'b1;
        next_mc.ccsnoopaddr[~mc.arb] = mc.daddr[mc.arb];
      end

      BUSRDX1:  begin
        // cache signals
        next_mc.dwait[mc.arb] = ~(mc.ramstate == ACCESS);
        next_mc.dload = mc.ramload;

        // memory signals
        next_mc.ramREN  = 1'b1;
        next_mc.ramaddr = mc.daddr[mc.arb]; 

        // coherency signals
        next_mc.ccwait[~mc.arb] = 1'b1; 
      end

      BUSRDX2:  begin
        // cache signals
        next_mc.dwait[mc.arb] = ~(mc.ramstate == ACCESS);
        next_mc.dload = mc.ramload;

        // memory signals
        next_mc.ramREN  = 1'b1;
        next_mc.ramaddr = mc.daddr[mc.arb];

        // coherency signals
        next_mc.ccwait[~mc.arb] = 1'b1; // at least need this one so dcache isnt talking to cpu when we are invalidating <- delete
        next_mc.ccinv[~mc.arb]  = 1'b1;
      end

      BUSWBX1:  begin
        // cache signals
        // mc.dwait[~mc.arb] = 1'b0;
        next_mc.dwait[mc.arb]  = 1'b0;
        next_mc.dload[mc.arb]  = mc.dstore[~mc.arb];

        // coherency signals
        next_mc.ccwait[~mc.arb]      = 1'b1;
        next_mc.ccsnoopaddr[~mc.arb] = mc.daddr[mc.arb];
      end

      BUSWBX2:  begin
        // cache signals
        // mc.dwait[~mc.arb] = 1'b0;
        next_mc.dwait[mc.arb]  = 1'b0;
        next_mc.dload[mc.arb]  = mc.dstore[~mc.arb];

        // coherency signals
        next_mc.ccwait[~mc.arb]      = 1'b1;
        next_mc.ccinv[~mc.arb]       = 1'b1;
        next_mc.ccsnoopaddr[~mc.arb] = mc.daddr[mc.arb];
      end

      /********************
      * I-fetch handling
      *********************/
      IMEM: begin
        // cache signals
        next_mc.iwait[mc.arb] = ~(mc.ramstate == ACCESS);
        next_mc.iload[mc.arb] = mc.ramload;

        // memory signals
        next_mc.ramREN  = 1'b1;
        next_mc.ramaddr = mc.iaddr[mc.arb];
      end

      /********************
      * Flush handling
      *********************/
      CACWB: begin
        // memory signals
        next_mc.ramWEN   = 1'b1;
        next_mc.ramaddr  = mc.daddr[mc.arb];
        next_mc.ramstore = mc.dstore[mc.arb];
        next_mc.ccsnoopaddr[~mc.arb] = mc.daddr[mc.arb];
        next_mc.ccinv[~mc.arb]       = 1'b1;

        next_mc.dwait[mc.arb] = ~(mc.ramstate == ACCESS);
      end

    endcase
    end
  end

  always_comb begin : arbiternextlogic
      next_mc.arb = mc.arb;

      if (mc_state == IDLE && next_mc_state == IDLE) begin //make sure to only flip the arbiter bit when nothing is going on
        if (mc.dREN[mc.arb] | mc.dWEN[mc.arb] | mc.iREN[mc.arb]) 
          next_mc.arb = mc.arb;
        else if (mc.dREN[~mc.arb] | mc.dWEN[~mc.arb] | mc.iREN[~mc.arb])
          next_mc.arb = ~mc.arb;
      end 
  end

endmodule
