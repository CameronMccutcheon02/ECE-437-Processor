`ifndef FT_IF_VH
`define FT_IF_VH
`include "cpu_types_pkg.vh"

interface fetch_if;
    import cpu_types_pkg::*;
    import structs::*;

    //Inputs to stage
    word_t imemload;
    execute_t execute_p;

    //Outputs of stage
    fetch_t fetch_p;
    logic imemREN;
    word_t imemaddr;
    
    modport FT (
        input imemload, execute_p,
        output fetch_p, imemREN, imemaddr
    );


endinterface
`endif