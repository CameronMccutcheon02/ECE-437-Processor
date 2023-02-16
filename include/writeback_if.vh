`ifndef WB_IF_VH
`define WB_IF_VH
`include "cpu_types_pkg.vh"
`include "custom_types_pkg.vh"

interface writeback_if;
    import cpu_types_pkg::*;
    import custom_types_pkg::*;

    //Inputs to stage
    memory_t memory_p;
    logic ihit, dhit, flush, stall;


    //Outputs of stage
    writeback_t writeback_p;
    
    modport WB (
        input memory_p, ihit, dhit, flush, stall,
        output writeback_p
    );


endinterface
`endif