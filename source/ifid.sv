/*
  Cameron McCutcheon    
  mccutchc@purdue.edu

  
*/
//`include "cpu_types_pkg.vh"
`include "pipeline_latch.vh"

module pipeline_latch(
  pipeline_if.ifid plif
)

function void transfer(); //on clock edge, we can call the store method to grab these output
                imemload = imemload_in;
                port_a = port_a_in;
                port_b = port_b_in;
                Imm_Ext = Imm_Ext_in;
                dmemstore = dmemstore_in;
                port_o = port_o_in;
                dmemload = dmemload_in;
                NPC = NPC_in;

                ALUctr = ALUctr_in;
                jal = jal_in;
                RegDst = RegDst_in;
                RegWr = RegWr_in;
                ALUSrc = ALUSrc_in;
                BEQ = BEQ_in;
                BNE = BNE_in;
                halt = halt_in;
                dREN = dREN_in;
                dWEN = dWEN_in;
                MemtoReg = MemtoReg_in;
        endfunction

        function void clear_to_nop();
                imemload = 0;
                port_a = 0;
                port_b = 0;
                Imm_Ext = 0;
                dmemstore = 0;
                port_o = 0;
                dmemload = 0;
                NPC = 0;

                ALUctr = ALU_ADD;
                jal = 0;
                RegDst = 0;
                RegWr = 0;
                ALUSrc = 0;
                BEQ = 0;
                BNE = 0;
                halt = 0;
                dREN = 0;
                dWEN = 0;
                MemtoReg = 0;
        endfunction

endmodule