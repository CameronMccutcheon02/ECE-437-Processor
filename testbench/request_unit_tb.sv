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


module request_unit_tb;
    parameter PERIOD = 10;

    logic CLK = 0, nRST; //Technically don't need the clock, but we can use it to regularly space out stuff

    // clock
    always #(PERIOD/2) CLK++;

    request_unit_if ruif();
    
    request_unit DUT(.CLK(CLK), .nRST(nRST), .ruif(ruif));

    test PROG(.CLK(CLK), .nRST(nRST), .ruif(ruif));


endmodule



program test (
  input logic CLK,
  
  output logic nRST,
  request_unit_if.RU ruif  //memory cache to controller, we only need one here because the other isn't used in lab 3

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
    input logic R, W;
    begin
        if(R == ruif.MemRead) begin
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

        if(W == ruif.MemWrite) begin
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
    ruif.ihit = 0;
    ruif.dhit = 0;
    ruif.MemRead = 0;
    ruif.MemWrite = 0;
  
//*******************************************\\
//Test Case 1: Reset Case
//*******************************************\ \
    tb_test_case = "Reset";
    tb_test_case_num = tb_test_case_num +1;
    display_test_banner();
    reset_dut();


//*******************************************\\
//Test Case 1: ihit case
//*******************************************\\
    tb_test_case = "ihit";
    tb_test_case_num = tb_test_case_num + 1;
    display_test_banner();
    @(posedge CLK)
    ruif.ihit = 1;
    @(posedge CLK)
    ruif.ihit = 0;
    check_outputs(0, 0);
    
    repeat(10) @(posedge CLK);

//*******************************************\\
//Test Case 1: dhit
//*******************************************\\
    tb_test_case = "imemread";
    tb_test_case_num = tb_test_case_num + 1;
    display_test_banner();
    @(posedge CLK)
    ruif.dhit = 1;
    @(posedge CLK)
    ruif.dhit = 0;
    check_outputs(0, 0);
    
    repeat(10) @(posedge CLK);

//*******************************************\\
//Test Case 1: Read case
//*******************************************\\
    tb_test_case = "imemread";
    tb_test_case_num = tb_test_case_num + 1;
    display_test_banner();
    ruif.MemRead = 1;
    @(posedge CLK)
    ruif.ihit = 1;
    @(posedge CLK)
    ruif.ihit = 0;
    check_outputs(1, 0);
    repeat(2) @(posedge CLK);
    ruif.dhit = 1;
    @(posedge CLK);
    ruif.dhit = 0;


//*******************************************\\
//Test Case 1: Write case
//*******************************************\\
    tb_test_case = "imemread";
    tb_test_case_num = tb_test_case_num + 1;
    display_test_banner();
    ruif.MemWrite = 1;
    @(posedge CLK)
    ruif.ihit = 1;
    @(posedge CLK)
    ruif.ihit = 0;
    check_outputs(0, 1);
    repeat(2) @(posedge CLK);
    ruif.dhit = 1;
    @(posedge CLK); 
    ruif.dhit = 0;
    
end
endprogram