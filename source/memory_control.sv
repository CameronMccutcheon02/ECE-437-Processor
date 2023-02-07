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

  // number of cpus for cc
  parameter CPUS = 1;

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
