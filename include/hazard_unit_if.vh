`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

`include "cpu_types_pkg.vh"

interface hazard_unit_if;
    import cpu_types_pkg::*;

    logic [3:0] flush;
    logic [3:0] freeze;
    logic memread_dc, memread_ex;
    word_t Rs_ft; //Rs's
    word_t Rt_dc, Rt_ex, Rt_ft; //Rt's
    word_t Rd_dc, Rd_ex; //Rd's

    logic BEQ, BNE, zero;
    logic [1:0] JumpSel;
    logic BranchTaken;

    modport hu (
        input memread_dc, memread_ex, BranchTaken, JumpSel,
        input Rs_ft, //Rs's
        input Rt_dc, Rt_ex, Rt_ft, //Rt's
        input Rd_dc, Rd_ex, //Rd's
        output flush, freeze
    );

    modport tb (
        input flush, freeze,
        output memread_dc, memread_ex, Rt_dc, Rs_ft, Rt_ft, Rt_ex, BranchTaken, JumpSel
    );

endinterface
`endif