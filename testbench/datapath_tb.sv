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


module datapath_tb;
    parameter PERIOD = 10;

    logic CLK = 0, nRST; //Technically don't need the clock, but we can use it to regularly space out stuff

    // clock
    always #(PERIOD/2) CLK++;

    datapath_cache_if dpif();
    
    datapath DUT(.CLK(CLK), .nRST(nRST), .dpif(dpif));

    test PROG(.CLK(CLK), .nRST(nRST), .dpif(dpif));


endmodule



program test (
  input logic CLK,
  
  output logic nRST,
  datapath_cache_if.dp dpif //memory cache to controller, we only need one here because the other isn't used in lab 3

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
//Test Case 1: imemread
//*******************************************\\
    tb_test_case = "imemread";
    tb_test_case_num = tb_test_case_num + 1;
    display_test_banner();
    dpif.imemload = 'haecd0000;
    repeat(10) @(posedge CLK);
    
end
endprogram