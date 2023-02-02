/*
  Cameron McCutcheon

  DP test bench
*/

`include "datapath_cache_if.vh"

import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`ifdef MAPPED
`timescale 1 ns / 1 ns
`endif


module control_unit_tb;
    parameter PERIOD = 10;

    logic CLK = 0, nRST; //Technically don't need the clock, but we can use it to regularly space out stuff

    // clock
    always #(PERIOD/2) CLK++;

    control_unit_if cuif();
    
    control_unit DUT(.CLK(CLK), .nRST(nRST), .cuif(cuif));

    test PROG(.CLK(CLK), .nRST(nRST), .cuif(cuif));


endmodule



program test (
  input logic CLK,
  
  output logic nRST,
  control_unit_if.CU cuif  //memory cache to controller, we only need one here because the other isn't used in lab 3

);

parameter PERIOD = 10;
string tb_test_case;
integer tb_test_case_num;
logic tb_mismatch, tb_check;

task reset_dut;
  begin
    automatic string temp = tb_test_case;
    tb_test_case = "Reset";
    // Activate the reset
    nRST = 1'b0;

    // Maintain the reset for more than one cycle
    @(posedge CLK);
    @(posedge CLK);

    // Wait until safely away from rising edge of the clock before releasing
    @(negedge CLK);
    nRST = 1'b1;

    // Leave out of reset for a couple cycles before allowing other stimulus
    // Wait for negative clock edges, 
    // since inputs to DUT should normally be applied away from rising clock edges
    @(negedge CLK);
    @(negedge CLK);
    @(posedge CLK);
    tb_test_case = temp;
  end
endtask

task check_outputs;
    input opcode_t op;
    input funct_t f;
    begin
        logic Error;
        Error = 1;
    case(op)
        RTYPE: begin
                case(f)
                SLLV:   Error = cuif.alu_op == ALU_SLL ? 1 : 0;
                SRLV:   Error = cuif.alu_op == ALU_SRL ? 1 : 0;
                JR:     Error = cuif.alu_op == ALU_ADD ? 1 : 0; //Maybe something else here?
                ADD:    Error = cuif.alu_op == ALU_ADD ? 1 : 0;
                ADDU:   Error = cuif.alu_op == ALU_ADD ? 1 : 0;
                SUB:    Error = cuif.alu_op == ALU_SUB ? 1 : 0;
                SUBU:   Error = cuif.alu_op == ALU_SUB ? 1 : 0;
                AND:    Error = cuif.alu_op == ALU_AND ? 1 : 0;
                OR:     Error = cuif.alu_op == ALU_OR ? 1 : 0;
                XOR:    Error = cuif.alu_op == ALU_XOR ? 1 : 0;
                NOR:    Error = cuif.alu_op == ALU_NOR ? 1 : 0;
                SLT:    Error = cuif.alu_op == ALU_SLT ? 1 : 0;
                SLTU:   Error = cuif.alu_op == ALU_SLTU ? 1 : 0;
                endcase
            end

            // J: //Nothing here 
            // JAL:  //Nothing here

            BEQ:    Error = cuif.alu_op == ALU_SUB ? 1 : 0;
            BNE:     Error = cuif.alu_op == ALU_SUB ? 1 : 0;
            ADDI:    Error = cuif.alu_op == ALU_ADD ? 1 : 0;
            ADDIU:   Error = cuif.alu_op == ALU_ADD ? 1 : 0;
            SLTI:    Error = cuif.alu_op == ALU_SLT ? 1 : 0;
            SLTIU:   Error = cuif.alu_op == ALU_SLTU ? 1 : 0;
            ANDI:    Error = cuif.alu_op == ALU_AND ? 1 : 0;
            ORI:     Error = cuif.alu_op == ALU_OR ? 1 : 0;
            XORI:    Error = cuif.alu_op == ALU_XOR ? 1 : 0;
            LUI:     Error = cuif.alu_op == ALU_OR ? 1 : 0; //Another mode on the extender to zero from the bottom
            LW:      Error = cuif.alu_op == ALU_ADD ? 1 : 0;
            LBU:     Error = cuif.alu_op == ALU_ADD ? 1 : 0;
            LHU:    Error = cuif.alu_op == ALU_ADD ? 1 : 0;
            SB:     Error = cuif.alu_op == ALU_ADD ? 1 : 0;
            SH:     Error = cuif.alu_op == ALU_ADD ? 1 : 0;
            SW:     Error = cuif.alu_op == ALU_ADD ? 1 : 0;
            LL:     Error = cuif.alu_op == ALU_ADD ? 1 : 0;
            SC:     Error = cuif.alu_op == ALU_ADD ? 1 : 0;
            HALT:   Error = (cuif.halt == 1) ? 0 : 1;

    endcase
    if(Error) begin
        $display("State: O_Output nzv");
            $write("%c[1;32m",27);
            $write("PASSED ");
            $write("%c[0m",27);
            
            $display("");
        end
        else begin // Check failed
            tb_mismatch = 1;
            $display("State: O_Output nzv");
            $write("%c[1;31m",27);
            $write("FAILED ");
            $write("%c[0m",27);
        end



    end
endtask


task display_test_banner; 
begin
  $display("//***********************************************************************\\");
  $display("Test case %d: ", tb_test_case_num, tb_test_case);
  $display("//***********************************************************************\\");
end
endtask

//*******************************************************************\\
//ACTUAL TEST CASES BELOW HERE
//*******************************************************************\\
initial begin
    tb_test_case_num = 0;
  
//*******************************************\\
//Test Case 1: Reset Case
//*******************************************\ \
    tb_test_case = "Reset";
    tb_test_case_num = tb_test_case_num +1;
    display_test_banner();
    reset_dut();


//*******************************************\\
//Test Case 1: itype
//*******************************************\\
    tb_test_case = "itype";
    tb_test_case_num = tb_test_case_num + 1;
    display_test_banner();
    cuif.instr_op = ADDI;
    check_outputs(cuif.instr_op, cuif.funct_op);
    repeat(2) @(posedge CLK);

//*******************************************\\
//Test Case 1: rtype
//*******************************************\\
    tb_test_case = "rtype";
    tb_test_case_num = tb_test_case_num + 1;
    display_test_banner();
    cuif.instr_op = RTYPE;
    cuif.funct_op = ADD;
    check_outputs(cuif.instr_op, cuif.funct_op);
    
    repeat(10) @(posedge CLK);

//*******************************************\\
//Test Case 1: jtype
//*******************************************\\
    tb_test_case = "jtype";
    tb_test_case_num = tb_test_case_num + 1;
    display_test_banner();
    cuif.instr_op = JAL;
    check_outputs(cuif.instr_op, cuif.funct_op);
    
    repeat(10) @(posedge CLK);
    
end
endprogram