`include "cache_control_if.vh"
`include "caches_if.vh"
`include "cpu_ram_if.vh"
`include "cpu_types_pkg.vh"

import cpu_types_pkg::*;

`timescale 1 ns / 1 ns

module memory_control_tb ();

    parameter PERIOD = 10;

    int passed = 0;
    int total = 0;

    logic CLK = 0, nRST;

    // clock
    always #(PERIOD/2) CLK++;

    // interfaces
    caches_if cif0();
    caches_if cif1();
    cache_control_if #(.CPUS(2)) ccif (cif0, cif1);
    cpu_ram_if ramif ();

    // test program
    test PROG (CLK, nRST, ccif);

    // DUT
`ifndef MAPPED
    memory_control MEM(CLK, nRST, ccif);
    ram RAM (CLK, nRST, ramif);
`else
    memory_control MEM(
        // cache inputs
        .ccif.iREN (ccif.iREN),
        .ccif.dREN (ccif.dREN),
        .ccif.dWEN (ccif.dWEN),
        .ccif.dstore (ccif.dstore),
        .ccif.iaddr (ccif.iaddr),
        .ccif.daddr (ccif.daddr),
        // ram inputs
        .ccif.ramload (ccif.ramload),
        .ccif.ramstate (ccif.ramstate),
        // coherence inputs
        .ccif.ccwrite (ccif.ccwrite),
        .ccif.cctrans (ccif.cctrans),
        // cache outputs
        .ccif.iwait (ccif.iwait),
        .ccif.dwait (ccif.dwait),
        .ccif.iload (ccif.iload),
        .ccif.dload (ccif.dload),
        // ram outputs
        .ccif.ramstore (ccif.ramstore),
        .ccif.ramaddr (ccif.ramaddr),
        .ccif.ramWEN (ccif.ramWEN),
        .ccif.ramREN (ccif.ramREN),
        // coherence outputs
        .ccif.ccwait (ccif.ccwait),
        .ccif.ccinv (ccif.ccinv),
        .ccif.ccsnoopaddr (ccif.ccsnoopaddr),
        .nRST (nRST),
        .CLK (CLK)
    )
    ram RAM(
        .ramif.ramstate (ramif.ramstate),
        .ramif.ramload (ramif.ramload),
        .ramif.memaddr (ramif.memaddr),
        .ramif.memREN (ramif.memREN),
        .ramif.memWEN (ramif.memWEN),
        .ramif.memstore (ramif.memstore),
        .nRST (nRST),
        .CLK (CLK)
    )
`endif

    // connect interfaces
    assign ramif.ramaddr = ccif.ramaddr;
    assign ramif.ramstore = ccif.ramstore;
    assign ramif.ramREN = ccif.ramREN;
    assign ramif.ramWEN = ccif.ramWEN;
    assign ccif.ramstate = ramif.ramstate;
    assign ccif.ramload = ramif.ramload;

endmodule

program test(
    input logic CLK,
    output logic nRST,
    // ccif doesnt give us a tb modport :(
    cache_control_if ccif
);
    string test_num;
    string test_case;

    int passed = 0;
    int total = 0;

    parameter PERIOD = 10;

    initial begin
        test_num = 0;
        // ************************************************************************
        // Test Case 0: Initial Reset
        // ************************************************************************
        New_Test("Initial Reset");
        Reset_DUT();

        Check_Cache_Outputs(2'b11, '0, 2'b11, '0);
        Check_Ram_Outputs('0, '0, '0, '0);
        Check_Coherence_Outputs('0, '0, '0);

        // ************************************************************************
        // Test Case 1: Instruction Fetch
        // ************************************************************************
        New_Test("Instruction Fetch");
        Reset_DUT();
        Reset_Input();



        Check_Ram_Outputs('0, '0, '0, '0);

        // ************************************************************************
        // Test Case 2: PrRd with no snoopy hit
        // ************************************************************************
        New_Test("PrRd with no snoopy hit");
        Reset_DUT();
        Reset_Input();

        // ************************************************************************
        // Test Case 3: PrRd with snoopy hit
        // ************************************************************************
        New_Test("PrRd with snoopy hit");
        Reset_DUT();
        Reset_Input();

        // ************************************************************************
        // Test Case 4: PrWr with no snoopy hit
        // ************************************************************************
        New_Test("PrWr with no snoopy hit");
        Reset_DUT();
        Reset_Input();

        // ************************************************************************
        // Test Case 5: PrWr with snoopy hit
        // ************************************************************************
        New_Test("PrWr with snoopy hit");
        Reset_DUT();
        Reset_Input();

        // ************************************************************************
        // Test Case 6: Flush
        // ************************************************************************
        New_Test("Flush to RAM");
        Reset_DUT();
        Reset_Input();


        $display("Passed %0d / %0d", passed, total);
        $finish();
    end

    task Reset_DUT;
    begin
        nRST = 1'b0;

        #(PERIOD);
        #(PERIOD);

        nRST = 1'b1;

        #(PERIOD);
        #(PERIOD);
    end
    endtask

    task Reset_Input;
    begin
        ccif.cif0.iREN     = 1'b0;
        ccif.cif0.dREN     = 1'b0;
        ccif.cif0.dWEN     = 1'b0;
        ccif.cif0.dstore   = '0;
        ccif.cif0.iaddr    = '0;
        ccif.cif0.daddr    = '0;
        ccif.cif0.ramload  = '0;
        ccif.cif0.ramstate = '0;
        ccif.cif0.ccwrite  = 1'b0;
        ccif.cif0.cctrans  = 1'b0;

        ccif.cif1.iREN     = 1'b0;
        ccif.cif1.dREN     = 1'b0;
        ccif.cif1.dWEN     = 1'b0;
        ccif.cif1.dstore   = '0;
        ccif.cif1.iaddr    = '0;
        ccif.cif1.daddr    = '0;
        ccif.cif1.ramload  = '0;
        ccif.cif1.ramstate = '0;
        ccif.cif1.ccwrite  = 1'b0;
        ccif.cif1.cctrans  = 1'b0;
    end
    endtask

    task New_Test;
    input string test_string;
    begin
        $display("");
        $display("************************************************************************");
        $display("Test Case %0d: %s", test_num, test_string);
        $display("************************************************************************");
        
        // set global navigation params
        test_num = test_num + 1;
        test_case = test_string;
    end
    endtask

    task Check_Cache_Outputs;
    input logic [1:0] iwait;
    input word_t [1:0] iload;
    input logic [1:0] dwait;
    input word_t [1:0] dload;
    begin
        // I-CACHE
        assert (
            iwait == {ccif.cif1.iwait, ccif.cif0.iwait}
        ) begin
            $write("%c[1;32m",27);
            $write("PASSED ");
            $write("%c[0m",27);
            $display("%b", iwait);
            passed = passed + 1;
        end else begin
            $write("%c[1;31m",27);
            $write("FAILED ");
            $write("%c[0m",27);
            $display("EXPECTED %b, GOT %b", iwait, {ccif.cif1.iwait, ccif.cif0.iwait});
        end
        assert (
            iload == {ccif.cif1.iload, ccif.cif0.iload}
        ) begin
            $write("%c[1;32m",27);
            $write("PASSED ");
            $write("%c[0m",27);
            $display("%h", iload);
            passed = passed + 1;
        end else begin
            $write("%c[1;31m",27);
            $write("FAILED ");
            $write("%c[0m",27);
            $display("EXPECTED %h, GOT %h", iload, {ccif.cif1.iload, ccif.cif0.iload});
        end

        // D-CACHE
        assert (
            dwait == {ccif.cif1.dwait, ccif.cif0.dwait}
        ) begin
            $write("%c[1;32m",27);
            $write("PASSED ");
            $write("%c[0m",27);
            $display("%b", dwait);
            passed = passed + 1;
        end else begin
            $write("%c[1;31m",27);
            $write("FAILED ");
            $write("%c[0m",27);
            $display("EXPECTED %b, GOT %b", dwait, {ccif.cif1.dwait, ccif.cif0.dwait});
        end
        assert (
            dload == {ccif.cif1.dload, ccif.cif0.dload}
        ) begin
            $write("%c[1;32m",27);
            $write("PASSED ");
            $write("%c[0m",27);
            $display("%h", dload);
            passed = passed + 1;
        end else begin
            $write("%c[1;31m",27);
            $write("FAILED ");
            $write("%c[0m",27);
            $display("EXPECTED %h, GOT %h", dload, {ccif.cif1.dload, ccif.cif0.dload});
        end
        total = total + 4;
    end
    endtask

    task Check_Ram_Outputs;
    input logic [1:0] ramREN;
    input logic [1:0] ramWEN;
    input word_t [1:0] ramaddr;
    input word_t [1:0] ramstore;
    begin
        assert (
            ramREN == {ccif.cif1.ramREN, ccif.cif0.ramREN}
        ) begin
            $write("%c[1;32m",27);
            $write("PASSED ");
            $write("%c[0m",27);
            $display("%b", ramREN);
            passed = passed + 1;
        end else begin
            $write("%c[1;31m",27);
            $write("FAILED ");
            $write("%c[0m",27);
            $display("EXPECTED %b, GOT %b", ramREN, {ccif.cif1.ramREN, ccif.cif0.ramREN});
        end
        assert (
            ramWEN == {ccif.cif1.ramWEN, ccif.cif0.ramWEN}
        ) begin
            $write("%c[1;32m",27);
            $write("PASSED ");
            $write("%c[0m",27);
            $display("%h", ramWEN);
            passed = passed + 1;
        end else begin
            $write("%c[1;31m",27);
            $write("FAILED ");
            $write("%c[0m",27);
            $display("EXPECTED %h, GOT %h", ramWEN, {ccif.cif1.ramWEN, ccif.cif0.ramWEN});
        end
        assert (
            ramaddr == {ccif.cif1.ramaddr, ccif.cif0.ramaddr}
        ) begin
            $write("%c[1;32m",27);
            $write("PASSED ");
            $write("%c[0m",27);
            $display("%b", ramaddr);
            passed = passed + 1;
        end else begin
            $write("%c[1;31m",27);
            $write("FAILED ");
            $write("%c[0m",27);
            $display("EXPECTED %b, GOT %b", ramaddr, {ccif.cif1.ramaddr, ccif.cif0.ramaddr});
        end
        assert (
            ramstore == {ccif.cif1.ramstore, ccif.cif0.ramstore}
        ) begin
            $write("%c[1;32m",27);
            $write("PASSED ");
            $write("%c[0m",27);
            $display("%h", ramstore);
            passed = passed + 1;
        end else begin
            $write("%c[1;31m",27);
            $write("FAILED ");
            $write("%c[0m",27);
            $display("EXPECTED %h, GOT %h", ramstore, {ccif.cif1.ramstore, ccif.cif0.ramstore});
        end
        total = total + 4;
    end
    endtask

    task Check_Coherence_Outputs;
    input logic [1:0] ccwait;
    input logic [1:0] ccinv;
    input word_t [1:0] ccsnoopaddr;
    begin
        assert (
            ccwait == {ccif.cif1.ccwait, ccif.cif0.ccwait}
        ) begin
            $write("%c[1;32m",27);
            $write("PASSED ");
            $write("%c[0m",27);
            $display("%b", ccwait);
            passed = passed + 1;
        end else begin
            $write("%c[1;31m",27);
            $write("FAILED ");
            $write("%c[0m",27);
            $display("EXPECTED %b, GOT %b", ccwait, {ccif.cif1.ccwait, ccif.cif0.ccwait});
        end
        assert (
            ccinv == {ccif.cif1.ccinv, ccif.cif0.ccinv}
        ) begin
            $write("%c[1;32m",27);
            $write("PASSED ");
            $write("%c[0m",27);
            $display("%h", ccinv);
            passed = passed + 1;
        end else begin
            $write("%c[1;31m",27);
            $write("FAILED ");
            $write("%c[0m",27);
            $display("EXPECTED %h, GOT %h", ccinv, {ccif.cif1.ccinv, ccif.cif0.ccinv});
        end
        assert (
            ccsnoopaddr == {ccif.cif1.ccsnoopaddr, ccif.cif0.ccsnoopaddr}
        ) begin
            $write("%c[1;32m",27);
            $write("PASSED ");
            $write("%c[0m",27);
            $display("%b", ccsnoopaddr);
            passed = passed + 1;
        end else begin
            $write("%c[1;31m",27);
            $write("FAILED ");
            $write("%c[0m",27);
            $display("EXPECTED %b, GOT %b", ccsnoopaddr, {ccif.cif1.ccsnoopaddr, ccif.cif0.ccsnoopaddr});
        end
        total = total + 3;
    end
    endtask
endprogram