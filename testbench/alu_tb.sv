/*
  Cameron McCutcheon

  ALU test bench
*/

// mapped needs this
`include "alu_if.vh"
import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`ifdef MAPPED
`timescale 1 ns / 1 ns
`endif

`timescale 1 ns / 10 ps

module alu_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST; //Technically don't need the clock, but we can use it to regularly space out stuff

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  alu_if aluif();
  // test program
  test PROG (.CLK(CLK), .nRST(nRST), .tbif(aluif));
  // DUT
`ifndef MAPPED
  alu DUT(aluif);
`else
  alu DUT(
    .\aluif.alu_op (aluif.alu_op),
    .\aluif.port_a (aluif.port_a),
    .\aluif.port_b (aluif.port_b),
    .\aluif.port_o (aluif.port_o),
    .\aluif.neg (aluif.neg),
    .\aluif.zero (aluif.zero),
    .\aluif.over (aluif.over)
  );
`endif


endmodule


program test (
  input logic CLK,
  
  output logic nRST,
  alu_if.tb tbif

);

parameter PERIOD = 10;
string tb_test_case;
integer tb_test_case_num;
logic tb_mismatch, tb_check;

task check_outputs;
  input int expected_data, zero, neg, over, data_a, data_b;
begin
  #(0.1);
  tb_mismatch = 0;
  tb_check = 1;
  assert(signed'(expected_data) == tbif.port_o & 
          zero == tbif.zero &
          neg == tbif.neg &
          over == tbif.over) begin // Check passed
    $display("State: O_Output nzv");
    $write("%c[1;32m",27);
    $write("PASSED ");
    $write("%c[0m",27);
    $display("%h %0d%0d%0d ------> %h = %h (op) %h", expected_data, neg, zero, over, expected_data, data_a, data_b);
    $display("");
  end
  else begin // Check failed
    tb_mismatch = 1;
    $display("State: O_Output nzv");
    $write("%c[1;31m",27);
    $write("FAILED ");
    $write("%c[0m",27);
    $display("%h %0d%0d%0d ------> %0d = %0d (op) %0d", expected_data, neg, zero, over, expected_data, data_a, data_b);
    $display("ACTUAL:%h %0d%0d%0d ------> %h = %h (op) %h", tbif.port_o, tbif.neg, tbif.zero, tbif.over, tbif.port_o, tbif.port_a, tbif.port_b);
    $display("");
  end

  #(0.1);
  tb_check = 0;
end
endtask

task send_command;
  input aluop_t command;
  input word_t data_a, data_b;
begin
  @(posedge CLK); //Wait for a posedge of clock for sync purposes
  tbif.alu_op = command;
  tbif.port_a = data_a;
  tbif.port_b = data_b;
  @(negedge CLK);
  find_outputs(.command(command), .data_a(data_a), .data_b(data_b));

end
endtask


task find_outputs; 
  input aluop_t command;
  input word_t data_a, data_b;
begin
  word_t expected;
  logic neg, zero, over;
  neg = 0; zero = 0; over = 0;
  case(command)
        ALU_SLL: begin //Logical Shift left by n digits (n = port_b)
            expected =  data_b << data_a[4:0];
        end
        ALU_SRL: begin //Logical Shift right by n digits (n = port_b)
            expected = data_b >> data_a[4:0];
        end
        ALU_ADD: begin //ADD A and B
            expected = data_a + data_b; 
            if (expected == 0) zero = 1;
            //$display("data a: %0d, data b: %0d, expected: %0d", data_a, data_b, expected);
            if ((data_a[31] == data_b[31]) && expected[31] != data_a[31])
                over = 1;
            if (expected[31] == 1) neg = 1; //Maybe need edge case here when overflow is high
        end
        ALU_SUB: begin
            expected = data_a - data_b;
            if (expected == 0) zero = 1;
            if ((data_a[31] != data_b[31]) && expected[31] != data_a[31])
                over = 1;
            if (expected[31] == 1) neg = 1; //Maybe need edge case here when overflow is high
        end
        ALU_AND: begin
            expected = data_a & data_b;
        end
        ALU_OR: begin 
            expected = data_a | data_b;
        end
        ALU_XOR: begin 
            expected = data_a ^ data_b;
        end
        ALU_NOR: begin 
            expected = ~(data_a | data_b);
        end
        ALU_SLT: begin 
            expected = signed'(data_a) < signed'(data_b) ? 1 : 0;
        end
        ALU_SLTU: begin 
            expected = (unsigned'(data_a) < unsigned'(data_b)) ? 1 : 0;
        end
  endcase

  check_outputs(expected, zero, neg, over, data_a, data_b);
end
endtask

task display_test_banner; 
begin
  $display("//***********************************************************************\\");
  $display("Test case %d: ", tb_test_case_num, tb_test_case);
  $display("//***********************************************************************\\");
end
endtask

//***********************************************************************\\
//Test 1- Reset Test
//***********************************************************************\\

initial begin
  aluop_t command;
  tb_test_case = "Reset Case";
  tb_test_case_num = 1;

//***********************************************************************\\
//Test 2 Logical shift Left
//***********************************************************************\\
  tb_test_case = "Shift Left";
  tb_test_case_num = tb_test_case_num+ 1;
  display_test_banner();
  command = ALU_SLL;
  send_command(command, 16, 1);
  send_command(command, 1, 2);
  send_command(command, 4, 2);


//***********************************************************************\\
//Test 3 Logical shift Right
//***********************************************************************\\
  tb_test_case = "Shift Right";
  tb_test_case_num = tb_test_case_num+ 1;

  display_test_banner();
  command = ALU_SRL;
  send_command(command, 4, 64);
  send_command(command, 4, 64);

//***********************************************************************\\
//Test 4 ADD
//***********************************************************************\\
  tb_test_case = "ADD";
  tb_test_case_num = tb_test_case_num+ 1;

  display_test_banner();
  command = ALU_ADD;
  send_command(command, 16, 1);
  send_command(command, 2147483647, 1); //Overflow test
  send_command(command, -16, 2); //Negative Test
  send_command(command, 0, 0); //Zero Test


//***********************************************************************\\
//Test 5 SUB
//***********************************************************************\\
  tb_test_case = "SUB";
  tb_test_case_num = tb_test_case_num+ 1;

  display_test_banner();
  command = ALU_SUB; 
  send_command(command, 16, 1); //Standard Test
  send_command(command, 2147483647, 1); //Large number test
  send_command(command, -1, 1); //All negative test
  send_command(command, 1, 1); //Zero Test
  send_command(command, -2147483648, 1); //Overflow type 1
  send_command(command, 2147483647, -1); //Overflow type 2
  send_command(command, -3, -4);

//***********************************************************************\\
//Test 6 AND
//***********************************************************************\\
  tb_test_case = "AND";
  tb_test_case_num = tb_test_case_num+ 1;

  display_test_banner();
  command = ALU_AND; 
  send_command(command, 16, 1); //Standard Test
  send_command(command, 16, 17); //Standard Test


//***********************************************************************\\
//Test 7 OR
//***********************************************************************\\
  tb_test_case = "OR";
  tb_test_case_num = tb_test_case_num+ 1;

  display_test_banner();
  command = ALU_OR; 
  send_command(command, 16, 1); //Standard Test
  send_command(command, 16, 17); //Standard Test


//***********************************************************************\\
//Test 8 XOR
//***********************************************************************\\
  tb_test_case = "XOR";
  tb_test_case_num = tb_test_case_num+ 1;

  display_test_banner();
  command = ALU_XOR; 
  send_command(command, 16, 1); //Standard Test
  send_command(command, 16, 17); //Standard Test


//***********************************************************************\\
//Test 9 NOR
//***********************************************************************\\
  tb_test_case = "NOR";
  tb_test_case_num = tb_test_case_num+ 1;

  display_test_banner();
  command = ALU_NOR; 
  send_command(command, 16, 1); //Standard Test
  send_command(command, 16, 17); //Standard Test

//***********************************************************************\\
//Test 10 SLT
//***********************************************************************\\
  tb_test_case = "SLT";
  tb_test_case_num = tb_test_case_num+ 1;

  display_test_banner();
  command = ALU_SLT; 
  send_command(command, 16, 1); //Standard Test
  send_command(command, 16, 17); //Standard Test
  send_command(command, -5, -6); //Standard Test
  send_command(command, -6, -5); //Standard Test
  send_command(command, 0, -5); //Standard Test


//***********************************************************************\\
//Test 11 SLTU
//***********************************************************************\\
  tb_test_case = "SLTU";
  tb_test_case_num = tb_test_case_num+ 1;

  display_test_banner();
  command = ALU_SLTU; 
  send_command(command, 16, 1); //Standard Test
  send_command(command, 16, 17); //Standard Test
  send_command(command, -5, -6); //Standard Test
  send_command(command, 0, -5); //Standard Test
  
  

end
endprogram
