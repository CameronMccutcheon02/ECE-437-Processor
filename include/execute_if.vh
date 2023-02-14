`ifndef EXE_IF_VH
`define EXE_IF_VH
`include "cpu_types_pkg.vh"

interface execute_if;
    import cpu_types_pkg::*;
    import structs::*;

    //Inputs to stage
    decode_t decode_p; //bus inputs from fetch stage
    logic ihit, dhit, flush, stall;
    

    //Outputs of stage
    execute_t execute_p;
    
    modport EX (
        input decode_p, ihit, dhit,
        output execute_p
    );







endinterface
`endif