`ifndef FT_IF_VH
`define FT_IF_VH
`include "cpu_types_pkg.vh"
`include "custom_types_pkg.vh"

interface fetch_if;
    import cpu_types_pkg::*;
    import custom_types_pkg::*;

    //Inputs to stage
    logic ihit, dhit, flush, freeze;
    word_t imemload;
    execute_t execute_p;

    //Outputs of stage
    fetch_t fetch_p;
    logic imemREN;
    word_t imemaddr;
    
    modport FT (
        input ihit, dhit, flush, freeze, imemload, execute_p,
        output fetch_p, imemREN, imemaddr
    );


endinterface
`endif