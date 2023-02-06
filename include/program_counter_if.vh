`ifndef PROGRAM_COUNTER_IF_VH
`define PROGRAM_COUNTER_IF_VH

`include "cpu_types_pkg.vh"

interface program_counter_if;
    import cpu_types_pkg::*;

    word_t PC, next_PC;
    logic EN;

    modport pc (
        input EN, next_PC,
        output PC
    );

    modport tb (
        input PC,
        output EN, next_PC
    );

endinterface

`endif