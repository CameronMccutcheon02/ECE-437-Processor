`include "alu_if.vh"
`include "cpu_types_pkg.vh"

import cpu_types_pkg::*;

`timescale 1 ns / 1 ns

module alu_tb ();

    //parameter PERIOD = 10;

    int passed = 0;
    int total = 0;

    alu_if aluif ();

    test PROG ();

`ifndef MAPPED
    alu DUT(aluif);
`else
    alu DUT(
        .\aluif.ALUOP (aluif.ALUOP),
        .\aluif.porta (aluif.porta),
        .\aluif.portb (aluif.portb),
        .\aluif.oport (aluif.oport),
        .\aluif.negative (aluif.negative),
        .\aluif.zero (aluif.zero),
        .\aluif.overflow (aluif.overflow)        
    );
`endif

endmodule

task Reset_Input;
begin
    alu_tb.aluif.ALUOP = ALU_SLL;
    alu_tb.aluif.porta = '0;
    alu_tb.aluif.portb = '0;
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
    $display("       o        nzv");
end
endtask

task Check_Outputs;
    input logic [31:0] expected_oport;
    input logic expected_negative;
    input logic expected_zero;
    input logic expected_overflow;
begin
    assert (alu_tb.aluif.oport == expected_oport & 
            alu_tb.aluif.negative == expected_negative &
            alu_tb.aluif.overflow == expected_overflow &
            alu_tb.aluif.zero == expected_zero) begin
        $write("%c[1;32m",27);
        $write("PASSED ");
        $write("%c[0m",27);
        $display("%h %0d%0d%0d", expected_oport, expected_negative, expected_zero, expected_overflow, );
        alu_tb.passed = alu_tb.passed + 1;
    end else begin
        //$display("       o        nzv          o        nzv");
        $write("%c[1;31m",27);
        $write("FAILED ");
        $write("%c[0m",27);
        $display("%h %0d%0d%0d EXPECTED %h %0d%0d%0d", alu_tb.aluif.oport, alu_tb.aluif.negative, alu_tb.aluif.zero, alu_tb.aluif.overflow, expected_oport, expected_negative, expected_zero, expected_overflow);
    end
    alu_tb.total = alu_tb.total + 1;
end
endtask

program test;
    integer i;
    initial begin
        // ************************************************************************
        // Test Case 1: Shift Left Logical
        // ************************************************************************
        New_Test(1, "Shift Left Logical");
        Reset_Input();
        alu_tb.aluif.ALUOP = ALU_SLL;
        for (i = 0; i < 5; i++) begin
            alu_tb.aluif.porta = $urandom();
            alu_tb.aluif.portb = $urandom();
            #(5);
            Check_Outputs((alu_tb.aluif.portb << alu_tb.aluif.porta[4:0]), alu_tb.aluif.oport[31], (alu_tb.aluif.oport == '0), 1'b0);
        end

        // ************************************************************************
        // Test Case 2: Shift Right Logical
        // ************************************************************************
        New_Test(2, "Shift Right Logical");
        Reset_Input();
        alu_tb.aluif.ALUOP = ALU_SRL;
        for (i = 0; i < 5; i++) begin
            alu_tb.aluif.porta = $urandom();
            alu_tb.aluif.portb = $urandom();
            #(5);
            Check_Outputs((alu_tb.aluif.portb >> alu_tb.aluif.porta[4:0]), alu_tb.aluif.oport[31], (alu_tb.aluif.oport == '0), 1'b0);
        end
        
        // ************************************************************************
        // Test Case 3: ADD Signed
        // ************************************************************************
        New_Test(3, "ADD Signed");
        Reset_Input();
        alu_tb.aluif.ALUOP = ALU_ADD;
        
        // Normal ADD
        alu_tb.aluif.porta = $urandom();
        alu_tb.aluif.portb = $urandom();
        #(5);
        Check_Outputs(($signed(alu_tb.aluif.porta) + $signed(alu_tb.aluif.portb)), alu_tb.aluif.oport[31], (alu_tb.aluif.oport == '0), ((alu_tb.aluif.oport[31] & ~alu_tb.aluif.porta[31] & ~alu_tb.aluif.portb[31]) | (~alu_tb.aluif.oport[31] & alu_tb.aluif.porta[31] & alu_tb.aluif.portb[31])));
        
        // Negative flag ADD
        alu_tb.aluif.porta = 32'h90000000;
        alu_tb.aluif.portb = 32'h00000001;
        #(5);
        Check_Outputs(($signed(alu_tb.aluif.porta) + $signed(alu_tb.aluif.portb)), alu_tb.aluif.oport[31], (alu_tb.aluif.oport == '0), ((alu_tb.aluif.oport[31] & ~alu_tb.aluif.porta[31] & ~alu_tb.aluif.portb[31]) | (~alu_tb.aluif.oport[31] & alu_tb.aluif.porta[31] & alu_tb.aluif.portb[31])));

        // Zero flag ADD
        alu_tb.aluif.porta = '0;
        alu_tb.aluif.portb = '0;
        #(5);
        Check_Outputs(($signed(alu_tb.aluif.porta) + $signed(alu_tb.aluif.portb)), alu_tb.aluif.oport[31], (alu_tb.aluif.oport == '0), ((alu_tb.aluif.oport[31] & ~alu_tb.aluif.porta[31] & ~alu_tb.aluif.portb[31]) | (~alu_tb.aluif.oport[31] & alu_tb.aluif.porta[31] & alu_tb.aluif.portb[31])));

        // Overflow flag ADD (negative)
        alu_tb.aluif.porta = 32'h7FFFFFFF;
        alu_tb.aluif.portb = 32'h7FFFFFFF;
        #(5);
        Check_Outputs(($signed(alu_tb.aluif.porta) + $signed(alu_tb.aluif.portb)), alu_tb.aluif.oport[31], (alu_tb.aluif.oport == '0), ((alu_tb.aluif.oport[31] & ~alu_tb.aluif.porta[31] & ~alu_tb.aluif.portb[31]) | (~alu_tb.aluif.oport[31] & alu_tb.aluif.porta[31] & alu_tb.aluif.portb[31])));

        // Overflow flag ADD (positive)
        alu_tb.aluif.porta = 32'h90000000;
        alu_tb.aluif.portb = 32'h90000000;
        #(5);
        Check_Outputs(($signed(alu_tb.aluif.porta) + $signed(alu_tb.aluif.portb)), alu_tb.aluif.oport[31], (alu_tb.aluif.oport == '0), ((alu_tb.aluif.oport[31] & ~alu_tb.aluif.porta[31] & ~alu_tb.aluif.portb[31]) | (~alu_tb.aluif.oport[31] & alu_tb.aluif.porta[31] & alu_tb.aluif.portb[31])));

        // ************************************************************************
        // Test Case 4: SUB Signed
        // ************************************************************************
        New_Test(4, "SUB Signal");
        Reset_Input();
        alu_tb.aluif.ALUOP = ALU_SUB;
        
        // Normal SUB
        alu_tb.aluif.porta = $urandom();
        alu_tb.aluif.portb = $urandom();
        #(5);
        Check_Outputs(($signed(alu_tb.aluif.porta) - $signed(alu_tb.aluif.portb)), alu_tb.aluif.oport[31], (alu_tb.aluif.oport == '0), (~alu_tb.aluif.oport[31] & alu_tb.aluif.porta[31] & ~alu_tb.aluif.portb[31]) | (alu_tb.aluif.oport[31] & ~alu_tb.aluif.porta[31] & alu_tb.aluif.portb[31]));

        // Negative flag SUB
        alu_tb.aluif.porta = 32'hF0000000;
        alu_tb.aluif.portb = 32'h00000001;
        #(5);
        Check_Outputs(($signed(alu_tb.aluif.porta) - $signed(alu_tb.aluif.portb)), alu_tb.aluif.oport[31], (alu_tb.aluif.oport == '0), (~alu_tb.aluif.oport[31] & alu_tb.aluif.porta[31] & ~alu_tb.aluif.portb[31]) | (alu_tb.aluif.oport[31] & ~alu_tb.aluif.porta[31] & alu_tb.aluif.portb[31]));

        // Zero flag SUB
        alu_tb.aluif.porta = '0;
        alu_tb.aluif.portb = '0;
        #(5);
        Check_Outputs(($signed(alu_tb.aluif.porta) - $signed(alu_tb.aluif.portb)), alu_tb.aluif.oport[31], (alu_tb.aluif.oport == '0), (~alu_tb.aluif.oport[31] & alu_tb.aluif.porta[31] & ~alu_tb.aluif.portb[31]) | (alu_tb.aluif.oport[31] & ~alu_tb.aluif.porta[31] & alu_tb.aluif.portb[31]));

        // Overflow flag SUB (negative)
        alu_tb.aluif.porta = 32'h7FFFFFFF;
        alu_tb.aluif.portb = 32'hFFFFFFFF;
        #(5);
        Check_Outputs(($signed(alu_tb.aluif.porta) - $signed(alu_tb.aluif.portb)), alu_tb.aluif.oport[31], (alu_tb.aluif.oport == '0), (~alu_tb.aluif.oport[31] & alu_tb.aluif.porta[31] & ~alu_tb.aluif.portb[31]) | (alu_tb.aluif.oport[31] & ~alu_tb.aluif.porta[31] & alu_tb.aluif.portb[31]));


        // Overflow flag SUB (positive)
        alu_tb.aluif.porta = 32'h80000000;
        alu_tb.aluif.portb = 32'h00000001;
        #(5);
        Check_Outputs(($signed(alu_tb.aluif.porta) - $signed(alu_tb.aluif.portb)), alu_tb.aluif.oport[31], (alu_tb.aluif.oport == '0), (~alu_tb.aluif.oport[31] & alu_tb.aluif.porta[31] & ~alu_tb.aluif.portb[31]) | (alu_tb.aluif.oport[31] & ~alu_tb.aluif.porta[31] & alu_tb.aluif.portb[31]));

        // ************************************************************************
        // Test Case 5: AND
        // ************************************************************************
        New_Test(5, "AND");
        Reset_Input();
        alu_tb.aluif.ALUOP = ALU_AND;
        for (i = 0; i < 5; i++) begin
            alu_tb.aluif.porta = $urandom();
            alu_tb.aluif.portb = $urandom();
            #(5);
            Check_Outputs((alu_tb.aluif.porta & alu_tb.aluif.portb), alu_tb.aluif.oport[31], (alu_tb.aluif.oport == '0), 1'b0);
        end

        // ************************************************************************
        // Test Case 6: OR
        // ************************************************************************
        New_Test(6, "OR");
        Reset_Input();
        alu_tb.aluif.ALUOP = ALU_OR;
        for (i = 0; i < 5; i++) begin
            alu_tb.aluif.porta = $urandom();
            alu_tb.aluif.portb = $urandom();
            #(5);
            Check_Outputs((alu_tb.aluif.porta | alu_tb.aluif.portb), alu_tb.aluif.oport[31], (alu_tb.aluif.oport == '0), 1'b0);
        end
        
        // ************************************************************************
        // Test Case 7: XOR
        // ************************************************************************
        New_Test(7, "XOR");
        Reset_Input();
        alu_tb.aluif.ALUOP = ALU_XOR;
        for (i = 0; i < 5; i++) begin
            alu_tb.aluif.porta = $urandom();
            alu_tb.aluif.portb = $urandom();
            #(5);
            Check_Outputs((alu_tb.aluif.porta ^ alu_tb.aluif.portb), alu_tb.aluif.oport[31], (alu_tb.aluif.oport == '0), 1'b0);
        end
        
        // ************************************************************************
        // Test Case 8: NOR
        // ************************************************************************
        New_Test(8, "NOR");
        Reset_Input();
        alu_tb.aluif.ALUOP = ALU_NOR;
        for (i = 0; i < 5; i++) begin
            alu_tb.aluif.porta = $urandom();
            alu_tb.aluif.portb = $urandom();
            #(5);
            Check_Outputs(~(alu_tb.aluif.porta | alu_tb.aluif.portb), alu_tb.aluif.oport[31], (alu_tb.aluif.oport == '0), 1'b0);
        end

        // ************************************************************************
        // Test Case 9: Set Less than Signed
        // ************************************************************************
        New_Test(9, "Set Less than Signed");
        Reset_Input();
        alu_tb.aluif.ALUOP = ALU_SLT;
        for (i = 0; i < 5; i++) begin
            alu_tb.aluif.porta = $urandom();
            alu_tb.aluif.portb = $urandom();
            #(5);
            Check_Outputs(($signed(alu_tb.aluif.porta) < $signed(alu_tb.aluif.portb)), alu_tb.aluif.oport[31], (alu_tb.aluif.oport == '0), 1'b0);
        end

        // ************************************************************************
        // Test Case 10: Set Less than Unsigned
        // ************************************************************************
        New_Test(10, "Set Less than Unsigned");
        Reset_Input();
        alu_tb.aluif.ALUOP = ALU_SLTU;
        for (i = 0; i < 5; i++) begin
            alu_tb.aluif.porta = $urandom();
            alu_tb.aluif.portb = $urandom();
            #(5);
            Check_Outputs((alu_tb.aluif.porta < alu_tb.aluif.portb), alu_tb.aluif.oport[31], (alu_tb.aluif.oport == '0), 1'b0);
        end
        
        $display("Passed %0d / %0d", alu_tb.passed, alu_tb.total);
        $finish;
    end
endprogram