/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "register_file_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module register_file_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  register_file_if rfif ();
  // test program
  test PROG ();
  // DUT
`ifndef MAPPED
  register_file DUT(CLK, nRST, rfif);
`else
  register_file DUT(
    .\rfif.rdat2 (rfif.rdat2),
    .\rfif.rdat1 (rfif.rdat1),
    .\rfif.wdat (rfif.wdat),
    .\rfif.rsel2 (rfif.rsel2),
    .\rfif.rsel1 (rfif.rsel1),
    .\rfif.wsel (rfif.wsel),
    .\rfif.WEN (rfif.WEN),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule

task Async_Reset_DUT;
begin
  register_file_tb.nRST = 0;

  #(register_file_tb.PERIOD);
  #(register_file_tb.PERIOD);

  register_file_tb.nRST = 1;

  #(register_file_tb.PERIOD);
  #(register_file_tb.PERIOD);
end
endtask

task Reset_Input;
begin
  register_file_tb.rfif.rsel1 = '0;
  register_file_tb.rfif.rsel2 = '0;
  register_file_tb.rfif.wsel = '0;
  register_file_tb.rfif.wdat = '0;
  register_file_tb.rfif.WEN = 0;
end
endtask

task Check_Outputs;
  input string test_case;
  input logic [31:0] expected_rdat1;
  input logic [31:0] expected_rdat2;
begin
  assert (register_file_tb.rfif.rdat1 == expected_rdat1 && register_file_tb.rfif.rdat2 == expected_rdat2)
    $display("PASSED: %s", test_case);
  else $display("FAILED: %s", test_case);
end
endtask

program test;
  integer i;
  string format;
  initial begin
    // ************************************************************************
    // Test Case 0: Initialize Design
    // ************************************************************************
    Reset_Input();
    Async_Reset_DUT();

    $display("---TEST CASE 0: Initialization---");
    Check_Outputs("Initialization", '0, '0);
    $display(""); 

    // ************************************************************************
    // Test Case 1: Write to Reg0
    // ************************************************************************
    Reset_Input();
    Async_Reset_DUT();

    register_file_tb.rfif.wdat = 32'h12345678;
    register_file_tb.rfif.WEN = 1;
    register_file_tb.rfif.wsel = '0;
    register_file_tb.rfif.rsel1 = '0;
    register_file_tb.rfif.rsel2 = '0;

    $display("---TEST CASE 1: Writes to Reg 0---");
    Check_Outputs("Writes to Reg 0", '0, '0);
    $display("");
    // ************************************************************************
    // Test Case 2: Normal Reads and Writes
    // ************************************************************************
    Reset_Input();
    Async_Reset_DUT();
    
    $display("---TEST CASE 2: Normal Reads and Writes---");
    for (i = 1; i < 32; i++) begin
      #(register_file_tb.PERIOD);
      register_file_tb.rfif.rsel1 = i;
      register_file_tb.rfif.rsel2 = i;
      register_file_tb.rfif.WEN = 1;
      register_file_tb.rfif.wdat = i;
      register_file_tb.rfif.wsel = i;
      #(register_file_tb.PERIOD);
      $sformat(format,"Reading and Writing to Reg %0d", i);
      Check_Outputs(format, register_file_tb.rfif.wdat, register_file_tb.rfif.wdat);
    end
    $display("");

    $finish;
  end
endprogram