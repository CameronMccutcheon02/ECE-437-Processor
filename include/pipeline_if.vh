/*
  Cameron McCutcheon

  Control Unit IF
*/
`ifndef PL_IF_VH
`define PL_IF_VH

// all types
`include "cpu_types_pkg.vh"
`include "control_unit_if.vh"


interface pipeline_stage 
    ();
    import cpu_types_pkg::*;


    //Control Signals
    aluop_t ALUctr_in, ALUctr_out;
    logic jal_in, jal_out;
    logic RegDst_in, RegDst_out;
    logic RegWr_in, RegWr_out;
    logic ALUSrc_in, ALUSrc_out;
    logic BEQ_in, BEQ_out;
    logic BNE_in, BNE_out;
    logic ExtOP_in, ExtOP_out;
    logic halt_in, halt_out;
    logic dREN_in, dREN_out;
    logic dWEN_in, dWEN_out;
    logic [1:0] MemtoReg_in, MemtoReg_out;
    logic [1:0] JumpSel_in, JumpSel_out;

        //Word datas
    word_t imemload_in, port_a_in, port_b_in, Imm_Ext_in, dmemstore_in, port_o_in;
    word_t imemload_out, port_a_out, port_b_out, Imm_Ext_out, dmemstore_out, port_o_out;

    


    function void transfer(); //on clock edge, we can call the store method to grab these output
            imemload_out = imemload_in;
            port_a_out = port_a_in;
            port_b_out = port_b_in;
            Imm_Ext_out = Imm_Ext_in;
            dmemstore_out = dmemstore_in;
            port_o_out = port_o_in;

            ALUctr_out = ALUctr_in;
            jal_out = jal_in;
            RegDst_out = RegDst_in;
            RegWr_out = RegWr_in;
            ALUSrc_out = ALUSrc_in;
            BEQ_out = BEQ_in;
            BNE_out = BNE_in;
            ExtOP_out = ExtOP_in;
            halt_out = halt_in;
            dREN_out = dREN_in;
            dWEN_out = dWEN_in;
            MemtoReg_out = MemtoReg_in;
            JumpSel_out = JumpSel_in;
    endfunction

    function void clear_to_nop();
            imemload_out = 0;
            port_a_out = 0;
            port_b_out = 0;
            Imm_Ext_out = 0;
            dmemstore_out = 0;
            port_o_out = 0;

            ALUctr_out = ALU_ADD;
            jal_out = 0;
            RegDst_out = 0;
            RegWr_out = 0;
            ALUSrc_out = 0;
            BEQ_out = 0;
            BNE_out = 0;
            ExtOP_out = 0;
            halt_out = 0;
            dREN_out = 0;
            dWEN_out = 0;
            MemtoReg_out = 0;
            JumpSel_out = 0;
    endfunction

    modport IFID (
        input   imemload_in,
        output imemload_out

    );

    modport IDEX (
        input ALUctr_in;                        output ALUctr_out;
        input jal_in;                           output jal_out;
        input RegDst_in;                        output RegDst_out;
        input RegWr_in;                         output RegWr_out;
        input ALUSrc_in;                        output ALUSrc_out;
        input BEQ_in;                           output BEQ_out;
        input BNE_in;                           output BNE_out;
        input ExtOP_in;                         output ExtOP_out;
        input halt_in;                          output halt_out;
        input dREN_in;                          output dREN_out;
        input dWEN_in;                          output dWEN_out;
        input MemtoReg_in;                      output MemtoReg_out;
        input JumpSel_in;                       output JumpSel_out;

        input port_a_in;                        output port_a_out;
        input port_b_in;                        output port_b_out;
        input Imm_Ext_in;                       output Imm_Ext_out;
        input dmemstore_in;                     output dmemstore_out;

    );

    modport EXMEM (
        input jal_in;                           output jal_out;
        input RegDst_in;                        output RegDst_out;
        input RegWr_in;                         output RegWr_out;
        input BEQ_in;                           output BEQ_out;
        input BNE_in;                           output BNE_out;
        input ExtOP_in;                         output ExtOP_out;
        input halt_in;                          output halt_out;
        input dREN_in;                          output dREN_out;
        input dWEN_in;                          output dWEN_out;
        input [1:0] MemtoReg_in;                output MemtoReg_out;
        input [1:0] JumpSel_in;                 output JumpSel_out;

        input dmemstore_in;                     output dmemstore_out;
        input port_o_in;                        output port_o_out;
        

    );


    modport MEMWB (




    )

endinterface


`endif

