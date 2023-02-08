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
    logic iREN_in, iREN_out;
    logic dREN_in, dREN_out;
    logic dWEN_in, dWEN_out;
    logic [1:0] MemtoReg_in, MemtoReg_out;
    logic [1:0] JumpSel_in, JumpSel_out;

    word_t imemload_in, port_a_in, port_b_in, Sign_ext_in, dmemstore_in, port_o_in;
    word_t imemload_out, port_a_out, port_b_out, Sign_ext_out, dmemstore_out, port_o_out;

    


    function void transfer(); //on clock edge, we can call the store method to grab these output
            imemload_out = imemload_in;
            port_a_out = port_a_in;
            port_b_out = port_b_in;
            Sign_ext_out = Sign_ext_in;
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
            iREN_out = iREN_in;
            dREN_out = dREN_in;
            dWEN_out = dWEN_in;
            MemtoReg_out = MemtoReg_in;
            JumpSel_out = JumpSel_in;
    endfunction

    function void clear_to_nop();
            imemload_out = 0;
            port_a_out = 0;
            port_b_out = 0;
            Sign_ext_out = 0;
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
            iREN_out = 0;
            dREN_out = 0;
            dWEN_out = 0;
            MemtoReg_out = 0;
            JumpSel_out = 0;
    endfunction

endinterface


`endif

