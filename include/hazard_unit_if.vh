`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

`include "cpu_types_pkg.vh"

interface hazard_unit_if;
    import cpu_types_pkg::*;

    logic [3:0] flush;
    logic [3:0] freeze;
    logic memread_dc, memread_ex;
    word_t Rt_dc, Rs_ft, Rt_ft, Rt_ex;
    logic BEQ, BNE, zero;
    logic [1:0] JumpSel;
    logic BranchTaken;

    modport hu (
        input memread_dc, memread_ex, Rt_dc, Rs_ft, Rt_ft, Rt_ex, BranchTaken, JumpSel,
        output flush, freeze
    );

    modport tb (
        input flush, freeze,
        output memread_dc, Rt_dc, Rs_ft, Rt_ft, Rt_ex, BranchTaken, JumpSel
    );

endinterface
`endif