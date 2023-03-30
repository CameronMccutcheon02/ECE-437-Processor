`include "cache_control_if.vh"
`include "caches_if.vh"
`include "cpu_ram_if.vh"

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
    cache_control_if #(.CPUS(1)) ccif (cif0, cif1);
    cpu_ram_if ramif ();

    // test program
    test PROG ();

    // DUT
`ifndef MAPPED
    memory_control MEM(CLK, nRST, ccif);
    ram #(.LAT(3)) RAM (CLK, nRST, ramif);
`else
    memory_control MEM(
        .ccif.iREN (ccif.iREN),
        .ccif.dREN (ccif.dREN),
        .ccif.dWEN (ccif.dWEN),
        .ccif.dstore (ccif.dstore),
        .ccif.iaddr (ccif.iaddr),
        .ccif.daddr (ccif.daddr),
        .ccif.ramload (ccif.ramload),
        .ccif.ramstate (ccif.ramstate),
        .ccif.iwait (ccif.iwait),
        .ccif.dwait (ccif.dwait),
        .ccif.iload (ccif.iload),
        .ccif.dload (ccif.dload),
        .ccif.ramstore (ccif.ramstore),
        .ccif.ramaddr (ccif.ramaddr),
        .ccif.ramWEN (ccif.ramWEN),
        .ccif.ramREN (ccif.ramREN),
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

program test;
    initial begin
        // ************************************************************************
        // Test Case 0: Reset Test Case
        // ************************************************************************
        New_Test(0, "Reset Test Case");
        Reset_DUT();


        // ************************************************************************
        // Test Case 1: DWEN
        // ************************************************************************
        New_Test(1, "DWEN");
        Reset_DUT();
        Reset_Input();

        memory_control_tb.cif0.dWEN = 1'b1;
        memory_control_tb.cif0.dstore = 32'h12345678;
        memory_control_tb.cif0.daddr = 32'd16;

        #(5);
        while (memory_control_tb.cif0.dwait == 1'b1)
            @(posedge memory_control_tb.CLK);
        Check_Outputs(1'b1, memory_control_tb.cif0.dstore);        

        // ************************************************************************
        // Test Case 2: DREN
        // ************************************************************************
        New_Test(2, "DREN");
        Reset_DUT();
        Reset_Input();

        memory_control_tb.cif0.dREN = 1'b1;
        memory_control_tb.cif0.daddr = 32'd8;

        #(5);
        while (memory_control_tb.cif0.dwait == 1'b1)
            @(posedge memory_control_tb.CLK);
        Check_Outputs(1'b0, memory_control_tb.cif0.dload);

        // ************************************************************************
        // Test Case 3: IREN
        // ************************************************************************
        New_Test(3, "IREN");
        Reset_DUT();
        Reset_Input();

        memory_control_tb.cif0.iREN = 1'b1;
        memory_control_tb.cif0.iaddr = 32'd4;

        #(5);
        while (memory_control_tb.cif0.iwait == 1'b1)
            @(posedge memory_control_tb.CLK);
        Check_Outputs(1'b0, memory_control_tb.cif0.iload);

        // ************************************************************************
        // Test Case 4: DWEN + IREN Arbitration
        // ************************************************************************
        New_Test(4, "DWEN and IREN Arbitration");
        Reset_DUT();
        Reset_Input();

        memory_control_tb.cif0.iREN = 1'b1;
        memory_control_tb.cif0.iaddr = 32'd8;
        memory_control_tb.cif0.dWEN = 1'b1;
        memory_control_tb.cif0.daddr = 32'd8;
        memory_control_tb.cif0.dstore = 32'hABCDEFAB;

        #(5);
        while (memory_control_tb.cif0.dwait == 1'b1)
            @(posedge memory_control_tb.CLK);
        Check_Outputs(1'b1, memory_control_tb.cif0.dstore);

        memory_control_tb.cif0.dWEN = 1'b0;
        #(5);
        while (memory_control_tb.cif0.iwait == 1'b1)
            @(posedge memory_control_tb.CLK);
        Check_Outputs(1'b0, memory_control_tb.cif0.iload);

        // ************************************************************************
        // Test Case 5: DREN + IREN Arbitration
        // ************************************************************************
        New_Test(5, "DREN + IREN Arbitration");
        Reset_DUT();
        Reset_Input();

        memory_control_tb.cif0.dREN = 1'b1;
        memory_control_tb.cif0.iREN = 1'b1;
        memory_control_tb.cif0.iaddr = 32'd4;
        memory_control_tb.cif0.daddr = 32'd4;

        #(5);
        while (memory_control_tb.cif0.dwait == 1'b1)
            @(posedge memory_control_tb.CLK);
        Check_Outputs(1'b0, memory_control_tb.cif0.dload);

        memory_control_tb.cif0.dREN = 1'b0;
        #(5);
        while (memory_control_tb.cif0.iwait == 1'b1)
            @(posedge memory_control_tb.CLK);
        Check_Outputs(1'b0, memory_control_tb.cif0.iload);

        $display("Passed %0d / %0d", memory_control_tb.passed, memory_control_tb.total);
        
        dump_memory();
        $finish;
        
    end

    task Reset_DUT;
    begin
        memory_control_tb.nRST = 0;

        #(memory_control_tb.PERIOD);
        #(memory_control_tb.PERIOD);

        memory_control_tb.nRST = 1;

        #(memory_control_tb.PERIOD);
        #(memory_control_tb.PERIOD);
    end
    endtask

    task Reset_Input;
    begin
        memory_control_tb.cif0.iREN = 1'b0;
        memory_control_tb.cif0.dREN = 1'b0;
        memory_control_tb.cif0.dWEN = 1'b0;
        memory_control_tb.cif0.dstore = 1'b0;
        memory_control_tb.cif0.iaddr = '0;
        memory_control_tb.cif0.daddr = '0;
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
    input logic write;
    input logic [31:0] expected_ram_loadstore;
    begin
        if (write) begin
            assert (
                memory_control_tb.ccif.ramstore == expected_ram_loadstore
            ) begin
                $write("%c[1;32m",27);
                $write("PASSED ");
                $write("%c[0m",27);
                $display("%h", expected_ram_loadstore);
                memory_control_tb.passed = memory_control_tb.passed + 1;
            end else begin
                $write("%c[1;31m",27);
                $write("FAILED ");
                $write("%c[0m",27);
                $display(" EXPECTED ");
            end
        end else begin
            assert (
                memory_control_tb.ccif.ramload == expected_ram_loadstore
            ) begin
                $write("%c[1;32m",27);
                $write("PASSED ");
                $write("%c[0m",27);
                $display("%h", expected_ram_loadstore);
                memory_control_tb.passed = memory_control_tb.passed + 1;
            end else begin
                $write("%c[1;31m",27);
                $write("FAILED ");
                $write("%c[0m",27);
                $display("%h EXPECTED %h", memory_control_tb.ccif.ramload, expected_ram_loadstore);
            end
        end
        
        memory_control_tb.total = memory_control_tb.total + 1;
    end
    endtask

    task automatic dump_memory();
        string filename = "memcpu.hex";
        int memfd;

        memory_control_tb.cif0.daddr = 0;
        memory_control_tb.cif0.dWEN = 0;
        memory_control_tb.cif0.dREN = 0;

        memfd = $fopen(filename,"w");
        if (memfd)
            $display("Starting memory dump.");
        else begin 
            $display("Failed to open %s.",filename); 
            $finish; 
        end

        for (int unsigned i = 0; memfd && i < 16384; i++) begin
            int chksum = 0;
            bit [7:0][7:0] values;
            string ihex;

            memory_control_tb.cif0.daddr = i << 2;
            memory_control_tb.cif0.dREN = 1;
            repeat (4) @(posedge memory_control_tb.CLK);
            if (memory_control_tb.cif0.dload === 0)
                continue;
            values = {8'h04,16'(i),8'h00, memory_control_tb.cif0.dload};
            foreach (values[j])
                chksum += values[j];
            chksum = 16'h100 - chksum;
            ihex = $sformatf(":04%h00%h%h",16'(i),memory_control_tb.cif0.dload,8'(chksum));
            $fdisplay(memfd,"%s",ihex.toupper());
        end //for
        if (memfd) begin
            memory_control_tb.cif0.dREN = 0;
            $fdisplay(memfd,":00000001FF");
            $fclose(memfd);
            $display("Finished memory dump.");
        end
    endtask 
endprogram