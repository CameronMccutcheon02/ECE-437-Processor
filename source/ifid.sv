/*
  Cameron McCutcheon    
  mccutchc@purdue.edu

  
*/
//`include "cpu_types_pkg.vh"
`include "pipeline_if.vh"

module ifid(
  input logic CLK, nRST,
  pipeline_if.IFID fdif
);

  always_ff @(posedge CLK, negedge nRST) begin: Reg_Logic
    if (~nRST | (fdif.flush & fdif.ihit)) begin
      fdif.imemload <= '0;
      fdif.NPC <= '0;
    end else if (~fdif.stall & fdif.ihit) begin
      fdif.imemload <= fdif.imemload_in;
      fdif.NPC <= fdif.NPC_in;
    end else begin
      fdif.imemload <= fdif.imemload;
      fdif.NPC <= fdif.NPC;
    end
  end

function void transfer(); //on clock edge, we can call the store method to grab these output
        fdif.imemload = fdif.imemload_in;
endfunction

function void clear_to_nop();
        fdif.imemload = 0;
endfunction

endmodule