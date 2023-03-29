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
      mc.snoop_req <= 2'b10;
      mc.snoop_dest <= 2'b01;
      mc.arb <= 1'b0;
    end else begin
      mc_state <= next_mc_state;
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
    next_mc = mc;

    case (mc_state)
      IDLE: begin
        if (ccif.dREN[mc.arb] | ccif.dWEN[mc.arb]) //PrRd in I state
          next_mc_state = SNOOP;
        //else if (ccif.dWEN[mc.arb]) //PrWr in I or S state
          //next_mc_state = BUS_RDX;
        else if (ccif.iREN[mc.arb]) //do normal i-fetch
          next_mc_state = IMEM_RD;
      end
      SNOOP: begin
        // when doing snoops, ccwait[~mc.arb] goes high, in that case
        // we can just use dWEN as a validation signal for a matching snoop
        // (requires additional logic in dcache for setting this when ccwait is high)
        if (ccif.dREN[mc.arb]) begin // PrRd
          if (ccif.dWEN[~mc.arb])         // I->S (get from other cache)
            next_mc_state = BUS_RD_C1;
          else                            // I->S (get from memory)
            next_mc_state = BUS_RD_M1;
        end else if (ccif.dWEN[mc.arb]) begin // PrWr
          if (ccif.dWEN[~mc.arb])         // I->M or S->M (get from other cache)
            next_mc_state = BUS_RDX_C1; 
          else                            // I->M or S->M (get from memory)
            next_mc_state = BUS_RDX_M1; 
        end
      end
      BUS_RD_C1: next_mc_state = BUS_RD_C2;
      BUS_RD_C2: begin
        if (ccif.trans[~mc.arb]) // M->S
          next_mc_state = BUS_WB1;
        else // S->S
          next_mc_state = IDLE;
      end
      BUS_RD_M1: next_mc_state = (ccif.ramstate == ACCESS) ? BUS_RD_M2 : mc_state;
      BUS_RD_M2: next_mc_state = (ccif.ramstate == ACCESS) ? IDLE      : mc_state;
      BUS_RDX_C1: next_mc_state = BUS_RDX_C1;
      BUS_RDX_C2: begin
        // if dWEN == 1: M->I (writeback)
        // if dWEN == 0: S->I (nothing)
        if (ccif.cctrans[~mc.arb] & ccif.dWEN[~mc.arb]) // M->I
          next_mc_state = BUS_WB1;
        else if (ccif.cctrans[~mc.arb]) // S->I
          next_mc_state = IDLE;
      end
      BUS_RDX_M1: next_mc_state = (ccif.ramstate == ACCESS) ? BUS_RDX_M2 : mc_state;
      BUS_RDX_M2: next_mc_state = (ccif.ramstate == ACCESS) ? IDLE       : mc_state;
      BUS_WB1: next_mc_state =    (ccif.ramstate == ACCESS) ? BUS_WB2    : mc_state;
      BUS_WB2: next_mc_state =    (ccif.ramstate == ACCESS) ? IDLE       : mc_state;
      IMEM_RD: next_mc_state =    (ccif.ramstate == ACCESS) ? IDLE       : mc_state;
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
    ccif.iwait = 1'b1;
    ccif.dwait = 1'b1;
    ccif.iload = '0;
    ccif.dload = '0;

    ccif.ramstore = '0;
    ccif.ramaddr = '0;
    ccif.ramWEN = 1'b0;
    ccif.ramREN = 1'b0;

    ccif.ccwait = 1'b0;
    ccif.ccinv = 1'b0;
    ccif.ccsnoopaddr = '0;

    case (mc_state)

    endcase
  end

// THIS CAN BE DELETED LATER, JUST USED FOR REFERENCE FROM PREV MEM CONTROLLER

  always_comb begin: MEM_LOGIC
    // From Cache
      // iREN
      // dREN
      // dWEN
      // dstore
      // iaddr
      // daddr
    // From RAM
      // ramload
      // ramstate

    // the wait signals are inverted to be used as the hit signals by the cache
    ccif.iwait = 1'b1; // set low when fetching instruction
    ccif.dwait = 1'b1; // set low when accessing data
    ccif.iload = '0;
    ccif.dload = '0;

    ccif.ramREN = 1'b0;
    ccif.ramWEN = 1'b0;
    ccif.ramaddr = '0;
    ccif.ramstore = '0;

    if (ccif.dWEN | ccif.dREN) begin // reading/writing to data memory
      // TO CACHE
      ccif.dwait = ~(ccif.ramstate == ACCESS);
      if (ccif.dREN)
        ccif.dload = ccif.ramload;

      // TO RAM
      ccif.ramaddr = ccif.daddr;
      if (ccif.dWEN) begin
        ccif.ramWEN = 1'b1;
        ccif.ramstore = ccif.dstore;
      end else
        ccif.ramREN = 1'b1;
    end else begin // reading from instruction memory
      // TO CACHE
      ccif.iwait = ~(ccif.ramstate == ACCESS);
      ccif.iload = ccif.ramload;

      // TO RAM
      ccif.ramREN = 1'b1;
      ccif.ramaddr = ccif.iaddr;
    end
  end

endmodule
