`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

`include "cpu_types_pkg.vh"

interface hazard_unit_if;
    import cpu_types_pkg::*;

    logic [1:0] flush;
    logic freeze;
    logic memread_de, pc_en;
    word_t Rt_de, Rs_fd, Rt_fd;

    modport hu (
        input memread_de, Rt_de, Rs_fd, Rt_fd,
        output flush, freeze
    );

    modport tb (
        input flush, freeze,
        output memread_de, Rt_de, Rs_fd, Rt_fd
    );