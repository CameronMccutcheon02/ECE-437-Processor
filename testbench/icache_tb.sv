// mapped needs this
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// mapped timing needs this. 1ns is too fast
`ifdef MAPPED
`timescale 1 ns / 1 ns
`endif

`timescale 1 ns / 10 ps

module icache_tb;

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

program test(
    input logic CLK, nRST,
    datapath_cache_if.cache dcif,
    caches_if cif
);

task Async_Reset_DUT;
begin
  icache_tb.nRST = 0;

  #(icache_tb.PERIOD);
  #(icache_tb.PERIOD);

  icache_tb.nRST = 1;

  #(icache_tb.PERIOD);
  #(icache_tb.PERIOD);
end
endtask

task Reset_Input;
begin
  // FROM DATAPATH
  dcif.halt = 0;
  dcif.imemREN = 1;
  dcif.dmemWEN = 0;
  dcif.dmemREN = 0;

  // FROM MEM
  icache_tb.cif.dWEN = 0;
  icache_tb.cif.dREN = 0;
  icache_tb.cif.iREN = 0;
  icache_tb.cif.iaddr = '0;
  icache_tb.cif.iwait = 1;
  icache_tb.cif.iload = '0;
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

task Check_Memory;
  input string test_case;
  input logic exp_iREN;
  input logic [31:0] exp_iaddr;
begin
  assert (exp_iREN == cif.iREN && exp_iaddr == cif.iaddr)
    $display("PASSED: %s", test_case);
  else $display("FAILED: %s", test_case);
end
endtask

  integer i;
  string format;
  string testcase;
  logic [3:0] index;
  logic [25:0] tag;
  initial begin
    // ************************************************************************
    // Test Case 0: Initialize Design
    // ************************************************************************
    Async_Reset_DUT();
    Reset_Input();
    testcase = "Reset";

    $display("---TEST CASE 0: Initialization---");
    Check_Datapath("Initialization", '0, '0);
    Check_Memory("Initialization", '0, '0);
    repeat(5)
        @(posedge CLK)
    $display(""); 

    // ************************************************************************
    // Test Case 1: Memread in execute hazard
    // ************************************************************************
    Async_Reset_DUT();
    Reset_Input();
    testcase = "Test 1";

    $display("---TEST CASE 1: Fill the cache---");
    dcif.imemREN = 1'b1;
    dcif.imemaddr = {{26{1'b1}}, 6'b000100};
    #(5);
    icache_tb.cif.iload = 32'hABCDEF00;
    icache_tb.cif.iwait = 1'b0;
    #(15);
    icache_tb.cif.iwait = 1'b1;
    dcif.imemaddr = {{26{1'b1}}, 6'b001000};
    #(5);
    icache_tb.cif.iload = 32'h12345678;
    icache_tb.cif.iwait = 1'b0;
    #(15);
    icache_tb.cif.iwait = 1'b1;

    dcif.imemaddr = {{26{1'b1}}, 6'b000100};
    #(5);
    if (dcif.imemload == 32'hABCDEF00)
      $display("GOODOSOIDFJOISDJFOI");
    else $display("LKSJDFKLJSD");
    #(15);
    dcif.imemaddr = {{26{1'b1}}, 6'b001000};
    #(5);
    if (dcif.imemload == 32'h12345678)
      $display("GOODOSOIDFJOISDJFOI");
    else $display("LKSJDFKLJSD");
    @(posedge CLK)

    repeat(5)
        @(posedge CLK)
    $display("");  

    $finish;
  end
endprogram