`ifndef FORWARD_UNIT_IF_VH
`define FORWARD_UNIT_IF_VH

`include "cpu_types_pkg.vh"

interface forwarding_unit_if;
    import cpu_types_pkg::*;


    //decode pipeline struct in (for RS and Rt)
    regbits_t Rs_dc;
    regbits_t Rt_dc;

    //execute struct in
    regbits_t Rw_ex;
    word_t execute_data_in;

    //memory struct in
    regbits_t Rw_wb;
    word_t writeback_data_in;

    //outputs
    word_t execute_data_out, writeback_data_out;
    logic [1:0] port_a_control, port_b_control;
    

    modport fw (
        input Rs_dc, Rt_dc, Rw_ex, Rw_wb,
        input execute_data_in, writeback_data_in,
        output execute_data_out, writeback_data_out,
        output port_a_control, port_b_control
    );

    modport tb (
        output Rs_dc, Rt_dc, Rw_ex, Rw_wb,
        output execute_data_in, writeback_data_in,
        input execute_data_out, writeback_data_out,
        input port_a_control, port_b_control
    );

endinterface
`endif