/*
  Cameron McCutcheon    
  mccutchc@purdue.edu

  
*/
//`include "cpu_types_pkg.vh"
`include "pipeline_latch.vh"

module idex(
  input logic CLK, nRST
  pipeline_if.IDEX plif
);

function void transfer(); //on clock edge, we can call the store method to grab these output
        //Execute Layer
        plif.ALUctr = plif.ALUctr_in;
        plif.ALUSrc = plif.ALUSrc_in;
        plif.BEQ = plif.BEQ_in;
        plif.BNE = plif.BNE_in;

        //Mem Layer
        plif.dREN = plif.dREN_in;
        plif.dWEN = plif.dWEN_in;

        //WB Layer
        plif.jal = plif.jal_in;
        plif.RegDst = plif.RegDst_in;
        plif.RegWr = plif.RegWr_in;
        plif.MemtoReg = plif.MemtoReg_in;
        plif.halt = plif.halt_in;

        //Data Signals
        plif.Rd = plif.Rd_in;
        plif.Rs = plif.Rs_in;
        plif.NPC = plif.NPC_in;
        plif.port_a = plif.port_a_in;
        plif.port_b = plif.port_b_in;
        plif.Imm_Ext = plif.Imm_Ext_in;
        plif.dmemstore = plif.dmemstore_in;
endfunction

function void clear_to_nop();
        //Execute Layer
        plif.ALUctr = 0;
        plif.ALUSrc = 0;
        plif.BEQ = 0;
        plif.BNE = 0;

        //Mem Layer
        plif.dREN = 0;
        plif.dWEN = 0;

        //WB Layer
        plif.jal = 0;
        plif.RegDst = 0;
        plif.RegWr = 0;
        plif.MemtoReg = 0;
        plif.halt = 0;

        //Data Signals
        plif.Rd = 0;
        plif.Rs = 0;
        plif.NPC = 0;
        plif.port_a = 0;
        plif.port_b = 0;
        plif.Imm_Ext = 0;
        plif.dmemstore = 0;
endfunction

endmodule