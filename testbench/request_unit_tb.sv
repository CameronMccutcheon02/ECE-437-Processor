`include "request_unit_if.vh"

`timescale 1 ns / 1 ns

module request_unit_tb ();

    parameter PERIOD = 10;

    int passed = 0;
    int total = 0;

    logic CLK = 0, nRST;

    always #(PERIOD/2) CLK++;

    request_unit_if ruif();

    test PROG ();

`ifndef MAPPED
    request_unit RU(CLK, nRST, ruif);
`else
    request_unit RU(
        .ruif.iREN (ruif.iREN),
        .ruif.dREN (ruif.dREN),
        .ruif.dWEN (ruif.dWEN),
        .ruif.ihit (ruif.ihit),
        .ruif.dhit (ruif.dhit),
        .ruif.dmemREN (ruif.dmemREN),
        .ruif.dmemWEN (ruif.dmemWEN),
        .nRST (nRST),
        .CLK (CLK)
    )
`endif 

endmodule

program test;
    initial begin
        // ************************************************************************
        // Test Case 0: Reset Test Case
        // ************************************************************************
        New_Test(0, "Reset Test Case");
        Reset_DUT();

        Check_Outputs(0,0);

        // ************************************************************************
        // Test Case 1: Instruction Ready
        // ************************************************************************
        New_Test(1, "Instruction Ready");
        Reset_DUT();

        request_unit_tb.ruif.ihit = 1'b1;
        request_unit_tb.ruif.dREN = 1'b0;
        request_unit_tb.ruif.dWEN = 1'b1;

        #(request_unit_tb.PERIOD);
        Check_Outputs(1'b0, 1'b1);

        // ************************************************************************
        // Test Case 2: Data Ready
        // ************************************************************************
        New_Test(2, "Data Ready");
        Reset_DUT();

        request_unit_tb.ruif.dhit = 1'b1;
        request_unit_tb.ruif.dREN = 1'b1;
        request_unit_tb.ruif.dWEN = 1'b1;

        #(request_unit_tb.PERIOD);
        Check_Outputs(1'b0, 1'b0);

        // ************************************************************************
        // Test Case 3: Nothing Ready
        // ************************************************************************
        New_Test(3, "Nothing Ready");
        Reset_DUT();

        request_unit_tb.ruif.dREN = 1'b1;
        request_unit_tb.ruif.dWEN = 1'b1;

        #(request_unit_tb.PERIOD);
        Check_Outputs(1'b0, 1'b0);

        $display("Passed %0d / %0d", request_unit_tb.passed, request_unit_tb.total);

        $finish;
    end

    task Reset_DUT;
    begin
        request_unit_tb.nRST = 0;

        #(request_unit_tb.PERIOD);
        #(request_unit_tb.PERIOD);

        request_unit_tb.nRST = 1;

        #(request_unit_tb.PERIOD);
        #(request_unit_tb.PERIOD);
    end
    endtask

    task New_Test;
    input integer test_num;
    input string test_string;
    begin
        $display("");
        $display("************************************************************************");
        $display("Test Case %0d: %s", test_num, test_string);
        $display("************************************************************************");
        $display("// TODO: add header values");
    end
    endtask

    task Check_Outputs;
    input logic expected_dmemREN;
    input logic expected_dmemWEN;
    begin
        assert (request_unit_tb.ruif.dmemREN == expected_dmemREN) begin
            $write("%c[1;32m",27);
            $write("PASSED ");
            $write("%c[0m",27);
            $display("%h", expected_dmemREN);
            request_unit_tb.passed = request_unit_tb.passed + 1;
        end else begin
            $write("%c[1;31m",27);
            $write("FAILED ");
            $write("%c[0m",27);
            $display(" EXPECTED ");
        end
        assert (request_unit_tb.ruif.dmemWEN == expected_dmemWEN) begin
            $write("%c[1;32m",27);
            $write("PASSED ");
            $write("%c[0m",27);
            $display("%h", expected_dmemWEN);
            request_unit_tb.passed = request_unit_tb.passed + 1;
        end else begin
            $write("%c[1;31m",27);
            $write("FAILED ");
            $write("%c[0m",27);
            $display(" EXPECTED ");
        end
        request_unit_tb.total = request_unit_tb.total + 2;
    end
    endtask
endprogram