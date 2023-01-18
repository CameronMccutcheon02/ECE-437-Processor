/*
  Cameron McCutcheon

  ALU test bench
*/

// mapped needs this
`include "alu_if.vh"

// mapped timing needs this. 1ns is too fast
`ifdef MAPPED
`timescale 1 ns / 1 ns
`endif

`timescale 1 ns / 10 ps

module alu_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  alu_if aluif ();
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
    .\aluif.over (aluif.over),
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
task reset_dut;
  begin
    // Activate the reset
    tbif.WEN = 0;
    tbif.wsel =0;
    tbif.rsel1 = 0;
    tbif.rsel2 = 0;
    tbif.wdat = 0;
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
  end
endtask

task check_outputs;
  input real expected_r1, expected_r2;
begin
  #(0.1);
  tb_mismatch = 0;
  tb_check = 1;
  if(expected_r1 == rfif.rdat1) begin // Check passed
    $info("Correct 'r1' output %s during %s test case", tb_test_case, tb_test_case_num);
  end
  else begin // Check failed
    tb_mismatch = 1;
    $error("Incorrect 'r1' output %s during %s test case", tb_test_case, tb_test_case_num);
  end

  if(expected_r2 == rfif.rdat2) begin // Check passed
    $info("Correct 'r2' output %s during %s test case", tb_test_case, tb_test_case_num);
  end
  else begin // Check failed
    tb_mismatch = 1;
    $error("Incorrect 'r2' output %s during %s test case", tb_test_case, tb_test_case_num);
  end
  #(0.1);
  tb_check = 0;
end
endtask



//int data[int];

//***********************************************************************\\
//Test 1- Reset Test
//***********************************************************************\\

initial begin
  tb_test_case = "Reset Case";
  tb_test_case_num = 1;
reset_dut();

end
endprogram
