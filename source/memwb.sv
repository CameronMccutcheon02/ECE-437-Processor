/*
  Cameron McCutcheon    
  mccutchc@purdue.edu

  
*/
//`include "cpu_types_pkg.vh"
`include "pipeline_latch.vh"

module memwb(
  input logic CLK, nRST
  pipeline_if.MEMWB plif
);

function void transfer(); //on clock edge, we can call the store method to grab these output
        //WB Layer
        plif.jal = plif.jal_in;
        plif.RegDst = plif.RegDst_in;
        plif.RegWr = plif.RegWr_in;
        plif.MemtoReg = plif.MemtoReg_in;
        plif.halt = plif.halt_in;

        //data signals
        plif.NPC = plif.NPC_in;
        plif.Rd = plif.Rd_in;
        plif.Rs = plif.Rs_in;
        plif.port_o = plif.port_o_in;
        plif.Imm_Ext = plif.Imm_Ext_in;
        plif.dmemload = plif.dmemload_in;
endfunction

function void clear_to_nop();
        plif.jal = 0;
        plif.RegDst = 0;
        plif.RegWr = 0;
        plif.MemtoReg = 0;
        plif.halt = 0;

        plif.NPC = 0;
        plif.Rd = 0;
        plif.Rs = 0;
        plif.port_o = 0;
        plif.Imm_Ext = 0;
        plif.dmemload = 0;
endfunction

endmodule