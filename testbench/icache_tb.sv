// mapped needs this
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// mapped timing needs this. 1ns is too fast
`ifdef MAPPED
`timescale 1 ns / 1 ns
`endif

`timescale 1 ns / 10 ps

module hazard_unit_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  datapath_cache_if dcif();
  caches_if cif();

  // test program
  test PROG (.CLK(CLK), .nRST(nRST), .dcif(dcif), .cif(cif));
  // DUT
`ifndef MAPPED
  icache DUT(CLK, nRST, dcif, cif);
`else
  
`endif


endmodule

task Async_Reset_DUT;
begin

end
endtask

program test(
    input logic CLK, nRST,
    datapath_cache_if.cache dcif,
    caches_if cif
);

task Reset_Input;
begin
  dcif.imemREN = 1;
  dcif.dmemWEN = 0;
  dcif.dmemREN = 0;

  cif.imemREN = 0;
  cif.imemaddr = '0;

end
endtask

task Check_Datapath;
  input string test_case;
  input logic  exp_ihit;
  input logic [31:0] exp_imemload;
begin
  assert (exp_ihit == dcif.ihit && exp_imemload == dcif.imemload)
    $display("PASSED: %s", test_case);
  else $display("FAILED: %s", test_case);
end
endtask

  integer i;
  string format;
  string testcase;
  initial begin
    // ************************************************************************
    // Test Case 0: Initialize Design
    // ************************************************************************
    Reset_Input();
    testcase = "Reset";

    $display("---TEST CASE 0: Initialization---");
    Check_Outputs("Initialization", '0, '0);
    repeat(5)
        @(posedge CLK)
    $display(""); 

    // ************************************************************************
    // Test Case 1: Memread in execute hazard
    // ************************************************************************
    Reset_Input();
    testcase = "Test 1";

    $display("---TEST CASE 1: Load Use Hazard---");
    huif.memread_dc = 1;
    huif.memread_ex = 0;
    huif.Rt_dc = 5'b00110;
    huif.Rs_ft = 0;
    huif.Rt_ft = 5'b00110;
    huif.Rt_ex = 0;
    @(posedge CLK)

    Check_Outputs("Load Use Hazard 1", 4'b0100, 4'b1000);
    repeat(5)
        @(posedge CLK)
    $display(""); 

    // ************************************************************************
    // Test Case 2: Memread in memory "hazard"
    // ************************************************************************
    Reset_Input();
    testcase = "Test 2";

    $display("---TEST CASE 2: Load Use Hazard2---");
    huif.memread_dc = 0;
    huif.memread_ex = 1;
    huif.Rt_dc = 0;
    huif.Rs_ft = 0;
    huif.Rt_ft = 5'b00110;
    huif.Rt_ex = 5'b00110;
    @(posedge CLK)

    Check_Outputs("Load Use Hazard 2", 4'b0100, 4'b1000);
    repeat(5)
        @(posedge CLK)
    $display(""); 

    // ************************************************************************
    // Test Case 3: Branch Not taken no hazard
    // ************************************************************************
    Reset_Input();
    testcase = "Test 3";

    $display("---TEST CASE 3: Branch Not taken no hazard---");
    huif.BranchTaken = 0;
    huif.JumpSel = 0;
    @(posedge CLK)

    Check_Outputs("Branch NT no hazard", 4'b0000, 4'b0000);
    repeat(5)
        @(posedge CLK)
    $display(""); 


    // ************************************************************************
    // Test Case 4: Branch Taken Hazard
    // ************************************************************************
    Reset_Input();
    testcase = "Test 4";

    $display("---TEST CASE 4: Branch Taken Hazard---");
    huif.BranchTaken = 1;
    huif.JumpSel = 0;
    @(posedge CLK)

    Check_Outputs("Branch Taken Hazard", 4'b1000, 4'b0000);
    repeat(5)
        @(posedge CLK)
    $display(""); 

    // ************************************************************************
    // Test Case 5: Branch Taken Hazard
    // ************************************************************************
    Reset_Input();
    testcase = "Test 5";

    $display("---TEST CASE 5: Branch Taken Hazard---");
    huif.BranchTaken = 0;
    huif.JumpSel = 1;
    @(posedge CLK)

    Check_Outputs("Branch Taken Hazard", 4'b1000, 4'b0000);
    repeat(5)
        @(posedge CLK)
    $display(""); 

    $finish;
  end
endprogram