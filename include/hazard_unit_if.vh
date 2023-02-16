`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

`include "cpu_types_pkg.vh"

interface hazard_unit_if;
    import cpu_types_pkg::*;

    logic [3:0] flush;
    logic [3:0] freeze;
    logic memread_dc, pc_en;
    word_t Rt_dc, Rs_ft, Rt_ft;

    modport hu (
        input memread_dc, Rt_dc, Rs_ft, Rt_ft,
        output flush, freeze
    );

    modport tb (
        input flush, freeze,
        output memread_dc, Rt_dc, Rs_ft, Rt_ft
    );

endinterface
`endif