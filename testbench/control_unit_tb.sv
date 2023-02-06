`include "control_unit_if.vh"
`include "cpu_types_pkg.vh"

import cpu_types_pkg::*;

`timescale 1 ns / 1 ns

module control_unit_tb ();

    parameter PERIOD = 10;

    int passed = 0;
    int total = 0;

    control_unit_if cuif();

    test PROG ();

`ifndef MAPPED
    control_unit CU(cuif);
`else
    control_unit CU(
        .cuif.JumpSel (cuif.JumpSel),
        .cuif.jal (cuif.jal),
        .cuif.RegDst (cuif.RegDst),
        .cuif.RegWr (cuif.RegWr),
        .cuif.ALUSrc (cuif.ALUSrc),
        .cuif.BEQ (cuif.BEQ),
        .cuif.BNE (cuif.BNE),
        .cuif.ALUctr (cuif.ALUctr),
        .cuif.MemtoReg (cuif.MemtoReg),
        .cuif.ExtOP (cuif.ExtOP),
        .cuif.halt (cuif.halt),
        .cuif.iREN (cuif.iREN),
        .cuif.dREN (cuif.dREN),
        .cuif.dWEN (cuif.dWEN),
        .cuif.opcode (cuif.opcode),
        .cuif.func (cuif.func),
        .cuif.ihit (cuif.ihit),
        .cuif.dhit (cuif.dhit)
    )
`endif 

endmodule

program test;
    initial begin
        // ************************************************************************
        // Test Case 1: R-Type Instructions
        // ************************************************************************
        control_unit_tb.cuif.opcode = RTYPE;
        control_unit_tb.cuif.func = control_unit_tb.cuif.func.first;
        do begin
            #(5);
            control_unit_tb.cuif.func = control_unit_tb.cuif.func.next;
        end while (control_unit_tb.cuif.func.first != control_unit_tb.cuif.func);

        // ************************************************************************
        // Test Case 2: I-Type and J-Type Instructions
        // ************************************************************************
        control_unit_tb.cuif.opcode = control_unit_tb.cuif.opcode.first;
        do begin
            #(5);
            control_unit_tb.cuif.opcode = control_unit_tb.cuif.opcode.next;
        end while (control_unit_tb.cuif.opcode != control_unit_tb.cuif.opcode.first);
        $finish;
    end
endprogram