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




always_comb begin
  ccif.iwait = 1; //Set waits to default to 1
  ccif.dwait = 1; //datapath will see access ability when xwait = 0
  ccif.iload = ccif.ramload;
  ccif.dload = ccif.ramload;
  ccif.ramstore = 0;
  ccif.ramaddr = 0;
  ccif.ramWEN = 0; //Note that on default (no datapath signals)
  ccif.ramREN = 0; //the ramstate will go to FREE





  if(ccif.dWEN) ccif.ramWEN = 1; //When dwrite is high, ram needs to know
  else if(ccif.dREN || ccif.iREN) ccif.ramREN = 1; //When dread or iread is high, ram needs to know -> this block gives write priority

  if(ccif.dWEN) ccif.ramstore = ccif.dstore; //on store, ram gets the data from cache

  if(ccif.dWEN || ccif.dREN) ccif.ramaddr = ccif.daddr; //on data transfer, data addr used->gives data type priority
  else if(ccif.iREN) ccif.ramaddr = ccif.iaddr;



  case(ccif.ramstate)
// FREE: begin 
    //   //Note that the datapath will need to be coded such that 
    //   //the address (for i and d) will be frozen when wait signals are pulled
    //   //They are required
    //   if(ccif.dWEN) begin
    //     ccif.ramstore = ccif.dstore;
    //     ccif.ramaddr = ccif.daddr;
    //   end
    //   else if(ccif.dREN) begin
    //     ccif.ramaddr = ccif.daddr; 
    //   end
    //   else if(ccif.iREN) begin
    //     ccif.ramaddr = ccif.iaddr;
    //   end
    // end

    // BUSY: begin
    //   if(ccif.dWEN) begin
    //     ccif.ramstore = ccif.dstore;
    //     ccif.ramaddr = ccif.daddr;
    //   end
    //   else if(ccif.dREN) begin
    //     ccif.ramaddr = ccif.daddr;

    //   end
    //   else if(ccif.iREN) begin
    //     ccif.ramaddr = ccif.iaddr;
    //   end
// end

    ACCESS: begin
      if(ccif.dWEN) begin
        ccif.dwait = 0;
      end
      else if(ccif.dREN) begin
        ccif.dwait = 0;
        ccif.dload = ccif.ramload;
      end
      else if(ccif.iREN) begin
        ccif.iwait = 0;
        ccif.iload = ccif.ramload;
      end
    end

    ERROR: begin
      //No idea what to do here, do we wait? do we just cry?
    end
  endcase

end

endmodule
