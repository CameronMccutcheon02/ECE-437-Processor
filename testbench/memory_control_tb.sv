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
    int test_num;
    string test_case;
    string temp;

    logic check = 0;

    int passed = 0;
    int total = 0;

    word_t [1:0] tempdata;

    parameter PERIOD = 10;

    initial begin
        test_num = 0;
        // ************************************************************************
        // Test Case 0: Initial Reset
        // ************************************************************************
        Reset_Input();
        New_Test("Initial Reset");
        Reset_DUT();

        Check_Cache_Outputs(.iwait(2'b11), .iload('0), .dwait(2'b11), .dload('0));
        Check_Ram_Outputs(.ramREN('0), .ramWEN('0), .ramaddr('0), .ramstore('0));
        Check_Coherence_Outputs(.ccwait('0), .ccinv('0), .ccsnoopaddr('0));
        @(posedge CLK);
        @(posedge CLK);
        @(posedge CLK);
        @(posedge CLK);

        // ************************************************************************
        // Test Case 1: Instruction Fetch
        // ************************************************************************
        New_Test("Instruction Fetch");
        Reset_Input();
        Reset_DUT();

        //set icache side inputs to bus
        Read_I_MEM(.iaddr(4), .cache_num(0));

        //Check to make sure we are reading from ram
        Check_Ram_Outputs(.ramREN(1), .ramWEN('0), .ramaddr(4), .ramstore('0));
        Check_Cache_Outputs(.iwait(2'b11), .iload(32'hBAD1BAD1), .dwait(2'b11), .dload('0));

        while(ccif.ramstate != ACCESS) 
            @(posedge CLK);

        @(negedge CLK)

        Check_Ram_Inputs(.ramstate(ACCESS), .ramload(0));
        

        @(posedge CLK);
        
        
        // ************************************************************************
        // Test Case 2: PrRd with no snoopy hit
        // ************************************************************************
        New_Test("PrRd with no snoopy hit");
        Reset_Input();
        Reset_DUT();

        cache_read(.daddr(500), .cache_num(0));

        @(posedge CLK);

        while(ccif.ramstate != ACCESS) 
            @(posedge CLK);
        
        @(posedge CLK);
        Check_Cache_Outputs(.iwait(2'b11), .iload('0), .dwait(2'b10), .dload('0));
        Check_Ram_Outputs(.ramREN(1), .ramWEN('0), .ramaddr(500), .ramstore('0));
        Check_Coherence_Outputs(.ccwait('0), .ccinv('0), .ccsnoopaddr('0));

        cache_read(.daddr(504), .cache_num(0));

        while(ccif.ramstate != ACCESS) 
            @(posedge CLK);
            

        @(posedge CLK);

        Check_Cache_Outputs(.iwait(2'b11), .iload('0), .dwait(2'b10), .dload('0));
        Check_Ram_Outputs(.ramREN(1), .ramWEN('0), .ramaddr(504), .ramstore('0));
        Check_Coherence_Outputs(.ccwait('0), .ccinv('0), .ccsnoopaddr('0));


        // ************************************************************************
        // Test Case 3: PrRd with snoopy hit
        // ************************************************************************
        test_num = test_num + 1;
        New_Test("PrRd with snoopy hit");
        Reset_Input();
        Reset_DUT();

        cache_read(.daddr(500), .cache_num(0));
        @(posedge CLK) //should now be in PrRd
        ccif.cif1.ccwrite = 1;
        ccif.cif1.daddr = 500;
        ccif.cif1.dstore = 42;
        @(posedge CLK); //Should be in BUSWB1 after this

        ccif.cif1.ccwrite = 0;

        while(ccif.ramstate != ACCESS) //wait for ram 
            @(posedge CLK);

        @(negedge CLK);
        tempdata[0] = ccif.cif1.dstore;
        tempdata[1] = 0;
        Check_Cache_Outputs(.iwait(2'b11), .iload('0), .dwait(2'b10), .dload(tempdata));
        Check_Ram_Outputs(.ramREN(0), .ramWEN(1), .ramaddr(500), .ramstore(tempdata[0]));
        Check_Coherence_Outputs(.ccwait(2'b10), .ccinv('0), .ccsnoopaddr({ccif.cif1.daddr, 32'h0}));

        @(posedge CLK); //stay in access for a moment

        
        ccif.cif1.daddr = 504;
        ccif.cif1.dstore = 69;
        cache_read(.daddr(504), .cache_num(0));
        @(posedge CLK);

        while(ccif.ramstate != ACCESS) //wait for ram 
            @(posedge CLK);

        @(negedge CLK);
        tempdata[0] = ccif.cif1.dstore;
        tempdata[1] = 0;
        Check_Cache_Outputs(.iwait(2'b11), .iload('0), .dwait(2'b10), .dload(tempdata));
        Check_Ram_Outputs(.ramREN(0), .ramWEN(1), .ramaddr(504), .ramstore(tempdata[0]));
        Check_Coherence_Outputs(.ccwait(2'b10), .ccinv('0), .ccsnoopaddr({ccif.cif1.daddr, 32'h0}));

        @(posedge CLK);


        // ************************************************************************
        // Test Case 4: PrWr with no snoopy hit
        // ************************************************************************
        New_Test("PrWr with no snoopy hit");
        Reset_Input();
        Reset_DUT();

        cache_write(.daddr(600), .dstore(69), .cache_num(0));
        ccif.cif0.ccwrite = 1;

        @(posedge CLK); //Go to PrWr

        @(posedge CLK); //Start bus RDx1
        while(ccif.ramstate != ACCESS) 
            @(posedge CLK);

        @(negedge CLK);
        tempdata[0] = ccif.cif1.dstore;
        tempdata[1] = 0;
        Check_Cache_Outputs(.iwait(2'b11), .iload('0), .dwait(2'b10), .dload('0));
        Check_Ram_Outputs(.ramREN(1), .ramWEN(0), .ramaddr(600), .ramstore(0));
        Check_Coherence_Outputs(.ccwait(2'b10), .ccinv(2'b00), .ccsnoopaddr('0));
        
        @(posedge CLK); //Go to busRDX2
        cache_read(.daddr(600), .cache_num(0));

        while(ccif.ramstate != ACCESS) 
            @(posedge CLK);

        @(negedge CLK);
        tempdata[0] = ccif.cif1.dstore;
        tempdata[1] = 0;
        Check_Cache_Outputs(.iwait(2'b11), .iload('0), .dwait(2'b10), .dload('0));
        Check_Ram_Outputs(.ramREN(1), .ramWEN(0), .ramaddr(600), .ramstore(0));
        Check_Coherence_Outputs(.ccwait(2'b10), .ccinv(2'b10), .ccsnoopaddr('0));

        @(posedge CLK);

        // ************************************************************************
        // Test Case 5: PrWr with snoopy hit
        // ************************************************************************
        New_Test("PrWr with snoopy hit");
        Reset_Input();
        Reset_DUT();

        cache_write(.daddr(700), .dstore(69), .cache_num(0));
        ccif.cif0.ccwrite = 1;

        @(posedge CLK); //Go to PrWr
        ccif.cif1.ccwrite = 1;
        ccif.cif1.daddr = 700;
        ccif.cif1.dstore = 42;

        @(posedge CLK); //Start bus WBX1

        @(negedge CLK);
        tempdata[0] = ccif.cif1.dstore;
        tempdata[1] = 0;
        Check_Cache_Outputs(.iwait(2'b11), .iload('0), .dwait(2'b10), .dload(tempdata));
        Check_Ram_Outputs(.ramREN(0), .ramWEN(0), .ramaddr(0), .ramstore(0));
        Check_Coherence_Outputs(.ccwait(2'b10), .ccinv(0), .ccsnoopaddr({ccif.cif1.daddr, 32'h0}));
        
        @(posedge CLK); //Go to busWB2
        cache_read(.daddr(704), .cache_num(0));
        ccif.cif1.ccwrite = 1;
        ccif.cif1.daddr = 704;
        ccif.cif1.dstore = 69;

        @(negedge CLK);
        tempdata[0] = ccif.cif1.dstore;
        tempdata[1] = 0;
        Check_Cache_Outputs(.iwait(2'b11), .iload('0), .dwait(2'b10), .dload(tempdata));
        Check_Ram_Outputs(.ramREN(0), .ramWEN(0), .ramaddr(0), .ramstore(0));
        Check_Coherence_Outputs(.ccwait(2'b10), .ccinv(2'b10), .ccsnoopaddr({ccif.cif1.daddr, 32'h0}));

        @(posedge CLK);

        // ************************************************************************
        // Test Case 6: Flush
        // ************************************************************************
        New_Test("Flush to RAM");
        Reset_Input();
        Reset_DUT();
        cache_write(.daddr(600), .dstore(69), .cache_num(0));

        @(posedge CLK);

        while(ccif.ramstate != ACCESS) 
            @(posedge CLK);

        @(negedge CLK);
        tempdata[0] = ccif.cif1.dstore;
        tempdata[1] = 0;
        Check_Cache_Outputs(.iwait(2'b11), .iload('0), .dwait(2'b10), .dload('0));
        Check_Ram_Outputs(.ramREN(0), .ramWEN(1), .ramaddr(600), .ramstore(69));
        Check_Coherence_Outputs(.ccwait(2'b00), .ccinv(2'b00), .ccsnoopaddr('0));
        
        @(posedge CLK);


        $display("Passed %0d / %0d", passed, total);


        // ************************************************************************
        // Test Case 7: Arbitration test
        // ************************************************************************
        New_Test("PrWr with snoopy hit");
        Reset_Input();
        Reset_DUT();

        cache_read(.daddr(700), .cache_num(0));
        cache_read(.daddr(750), .cache_num(1));
        

        @(posedge CLK); //should be in service for cache 1
        @(posedge CLK);

        Check_Coherence_Outputs(.ccwait(2'b10), .ccinv(2'b00), .ccsnoopaddr('0));
        $finish();
    end

    task Reset_DUT;
    begin
        nRST = 1'b0;
        temp = test_case;
        test_case = "Reset";

        @(posedge CLK);
        @(posedge CLK);

        nRST = 1'b1;

        @(posedge CLK);
        @(posedge CLK);
        test_case = temp;
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
        ccif.cif0.ccwrite  = 1'b0;
        ccif.cif0.cctrans  = 1'b0;

        ccif.cif1.iREN     = 1'b0;
        ccif.cif1.dREN     = 1'b0;
        ccif.cif1.dWEN     = 1'b0;
        ccif.cif1.dstore   = '0;
        ccif.cif1.iaddr    = '0;
        ccif.cif1.daddr    = '0;
        ccif.cif1.ccwrite  = 1'b0;
        ccif.cif1.cctrans  = 1'b0;
    end
    endtask

    task New_Test;
    input string test_string;
    begin
        test_num = test_num + 1;
        $display("");
        $display("************************************************************************");
        $display("Test Case %0d: %s", test_num, test_string);
        $display("************************************************************************");
        
        // set global navigation params
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
        check = 1;
        #(0.2);
        check = 0;
        assert (
            iwait == {ccif.cif1.iwait, ccif.cif0.iwait}
        ) begin
            $write("%c[1;32m",27);
            $write("PASSED ");
            $write("%c[0m",27);
            $display("iwait ");
            $display("%b", iwait);
            passed = passed + 1;
        end else begin
            $write("%c[1;31m",27);
            $write("FAILED ");
            $write("%c[0m",27);
            $display("iwait ");
            $display("EXPECTED %b, GOT %b", iwait, {ccif.cif1.iwait, ccif.cif0.iwait});
        end
        assert (
            iload == {ccif.cif1.iload, ccif.cif0.iload}
        ) begin
            $write("%c[1;32m",27);
            $write("PASSED ");
            $write("%c[0m",27);
            $display("iload ");
            $display("%h", iload);
            passed = passed + 1;
        end else begin
            $write("%c[1;31m",27);
            $write("FAILED ");
            $write("%c[0m",27);
            $display("iload ");
            $display("EXPECTED %h, GOT %h", iload, {ccif.cif1.iload, ccif.cif0.iload});
        end

        // D-CACHE
        assert (
            dwait == {ccif.cif1.dwait, ccif.cif0.dwait}
        ) begin
            $write("%c[1;32m",27);
            $write("PASSED ");
            $write("%c[0m",27);
            $display("dwait ");
            $display("%b", dwait);
            passed = passed + 1;
        end else begin
            $write("%c[1;31m",27);
            $write("FAILED ");
            $write("%c[0m",27);
            $display("dwait ");
            $display("EXPECTED %b, GOT %b", dwait, {ccif.cif1.dwait, ccif.cif0.dwait});
        end
        assert (
            dload == {ccif.cif1.dload, ccif.cif0.dload}
        ) begin
            $write("%c[1;32m",27);
            $write("PASSED ");
            $write("%c[0m",27);
            $display("dload ");
            $display("%h", dload);
            passed = passed + 1;
        end else begin
            $write("%c[1;31m",27);
            $write("FAILED ");
            $write("%c[0m",27);
            $display("dload ");
            $display("EXPECTED %h, GOT %h", dload, {ccif.cif1.dload, ccif.cif0.dload});
        end
        total = total + 4;
    end
    endtask

    task Check_Ram_Outputs;
    input logic ramREN;
    input logic ramWEN;
    input word_t ramaddr;
    input word_t ramstore;
    begin
        check = 1;
        #(0.2);
        check = 0;
        assert (
            ramREN == ccif.ramREN
        ) begin
            $write("%c[1;32m",27);
            $write("PASSED ");
            $write("%c[0m",27);
            $display("ramREN ");
            $display("%b", ramREN);
            passed = passed + 1;
        end else begin
            $write("%c[1;31m",27);
            $write("FAILED ");
            $write("%c[0m",27);
            $display("ramREN ");
            $display("EXPECTED %b, GOT %b", ramREN, ccif.ramREN);
        end
        assert (
            ramWEN == ccif.ramWEN
        ) begin
            $write("%c[1;32m",27);
            $write("PASSED ");
            $write("%c[0m",27);
            $display("ramWEN ");
            $display("%h", ramWEN);
            passed = passed + 1;
        end else begin
            $write("%c[1;31m",27);
            $write("FAILED ");
            $write("%c[0m",27);
            $display("ramWEN ");
            $display("EXPECTED %h, GOT %h", ramWEN, ccif.ramWEN);
        end
        assert (
            ramaddr == ccif.ramaddr
        ) begin
            $write("%c[1;32m",27);
            $write("PASSED ");
            $write("%c[0m",27);
            $display("ramaddr ");
            $display("%b", ramaddr);
            passed = passed + 1;
        end else begin
            $write("%c[1;31m",27);
            $write("FAILED ");
            $write("%c[0m",27);
            $display("ramaddr ");
            $display("EXPECTED %b, GOT %b", ramaddr, ccif.ramaddr);
        end
        assert (
            ramstore == ccif.ramstore
        ) begin
            $write("%c[1;32m",27);
            $write("PASSED ");
            $write("%c[0m",27);
            $display("%h", ramstore);
            $display("ramstore ");
            passed = passed + 1;
        end else begin
            $write("%c[1;31m",27);
            $write("FAILED ");
            $write("%c[0m",27);
            $display("ramstore ");
            $display("EXPECTED %h, GOT %h", ramstore, ccif.ramstore);
        end
        total = total + 4;
    end
    endtask

    task Check_Ram_Inputs;
    input word_t ramload;
    input ramstate_t ramstate;
    begin
        check = 1;
        #(0.2);
        check = 0;
        assert (
            ramload == ccif.ramload
        ) begin
            $write("%c[1;32m",27);
            $write("PASSED ");
            $write("%c[0m",27);
            $display("ramload ");
            $display("%h", ramload);
            passed = passed + 1;
        end else begin
            $write("%c[1;31m",27);
            $write("FAILED ");
            $write("%c[0m",27);
            $display("ramload ");
            $display("EXPECTED %h, GOT %h", ramload, ccif.ramload);
        end
        // assert (
        //     ramstate == ccif.ramstate
        // ) begin
        //     $write("%c[1;32m",27);
        //     $write("PASSED ");
        //     $write("%c[0m",27);
        //     $display("%h", ramWEN);
        //     passed = passed + 1;
        // end else begin
        //     $write("%c[1;31m",27);
        //     $write("FAILED ");
        //     $write("%c[0m",27);
        //     $display("EXPECTED %h, GOT %h", ramWEN, ccif.ramstate);
        // end
        total = total + 1;
    end
    endtask

    task Check_Coherence_Outputs;
    input logic [1:0] ccwait;
    input logic [1:0] ccinv;
    input word_t [1:0] ccsnoopaddr;
    begin
        check = 1;
        #(0.2);
        check = 0;
        assert (
            ccwait == {ccif.cif1.ccwait, ccif.cif0.ccwait}
        ) begin
            $write("%c[1;32m",27);
            $write("PASSED ");
            $write("%c[0m",27);
            $display("ccwait ");
            $display("%b", ccwait);
            passed = passed + 1;
        end else begin
            $write("%c[1;31m",27);
            $write("FAILED ");
            $write("%c[0m",27);
            $display("ccwait ");
            $display("EXPECTED %b, GOT %b", ccwait, {ccif.cif1.ccwait, ccif.cif0.ccwait});
        end
        assert (
            ccinv == {ccif.cif1.ccinv, ccif.cif0.ccinv}
        ) begin
            $write("%c[1;32m",27);
            $write("PASSED ");
            $write("%c[0m",27);
            $display("ccinv ");
            $display("%h", ccinv);
            passed = passed + 1;
        end else begin
            $write("%c[1;31m",27);
            $write("FAILED ");
            $write("%c[0m",27);
            $display("ccinv ");
            $display("EXPECTED %h, GOT %h", ccinv, {ccif.cif1.ccinv, ccif.cif0.ccinv});
        end
        assert (
            ccsnoopaddr == {ccif.cif1.ccsnoopaddr, ccif.cif0.ccsnoopaddr}
        ) begin
            $write("%c[1;32m",27);
            $write("PASSED ");
            $write("%c[0m",27);
            $display("ccsnoopaddr ");
            $display("%b", ccsnoopaddr);
            passed = passed + 1;
        end else begin
            $write("%c[1;31m",27);
            $write("FAILED ");
            $write("%c[0m",27);
            $display("ccsnoopaddr ");
            $display("EXPECTED %b, GOT %b", ccsnoopaddr, {ccif.cif1.ccsnoopaddr, ccif.cif0.ccsnoopaddr});
        end
        total = total + 3;
    end
    endtask


    task Read_I_MEM;
    input word_t iaddr;
    input logic cache_num;
    begin
        ccif.cif0.iREN = cache_num == 0 ? 1 : 0;
        ccif.cif1.iREN = cache_num == 1 ? 1 : 0;

        ccif.cif0.iaddr = cache_num == 0 ? iaddr : ccif.cif0.iaddr;
        ccif.cif1.iaddr = cache_num == 1 ? iaddr : ccif.cif1.iaddr;

        @(posedge CLK);

    end
    endtask

    task cache_read;
    input word_t daddr; 
    input logic cache_num;
    begin
        ccif.cif0.dREN = cache_num == 0 ? 1 : 0;
        ccif.cif1.dREN = cache_num == 1 ? 1 : 0;

        ccif.cif0.daddr = cache_num == 0 ? daddr : ccif.cif0.daddr;
        ccif.cif1.daddr = cache_num == 1 ? daddr : ccif.cif1.daddr;
    end
    endtask

    task cache_write;
    input word_t daddr; 
    input word_t dstore; 
    input logic cache_num;
    begin
        ccif.cif0.dWEN = cache_num == 0 ? 1 : 0;
        ccif.cif1.dWEN = cache_num == 1 ? 1 : 0;

        ccif.cif0.daddr = cache_num == 0 ? daddr : ccif.cif0.daddr;
        ccif.cif1.daddr = cache_num == 1 ? daddr : ccif.cif1.daddr;

        ccif.cif0.dstore = cache_num == 0 ? dstore : ccif.cif0.dstore;
        ccif.cif1.dstore = cache_num == 1 ? dstore : ccif.cif1.dstore;
    end
    endtask

endprogram