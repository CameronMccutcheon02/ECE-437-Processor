`ifndef ALU_IF_VH
`define ALU_IF_VH

`include "cpu_types_pkg.vh"

interface alu_if;
    import cpu_types_pkg::*;

    aluop_t ALUOP;
    word_t porta, portb, oport;
    logic negative, zero, overflow;

    // alu ports
    modport alu (
        input ALUOP, porta, portb,
        output oport, negative, zero, overflow
    );
    // alu tb
    modport tb (
        input oport, negative, zero, overflow,
        output ALUOP, porta, portb
    );

endinterface

`endif