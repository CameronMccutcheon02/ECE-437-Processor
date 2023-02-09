/*
  Cameron McCutcheon    
  mccutchc@purdue.edu

  
*/
//`include "cpu_types_pkg.vh"
`include "pipeline_latch.vh"

module ifid(
  input logic CLK, nRST
  pipeline_if.IFID plif
);

function void transfer(); //on clock edge, we can call the store method to grab these output
        plif.imemload = plif.imemload_in;
endfunction

function void clear_to_nop();
        plif.imemload = 0;
endfunction

endmodule