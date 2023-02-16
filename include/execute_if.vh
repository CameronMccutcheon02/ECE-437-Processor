`ifndef EXE_IF_VH
`define EXE_IF_VH
`include "cpu_types_pkg.vh"
`include "custom_types_pkg.vh"

interface execute_if;
    import cpu_types_pkg::*;
    import custom_types_pkg::*;

    //Inputs to stage
    logic ihit, dhit, flush, freeze;
    decode_t decode_p; //bus inputs from fetch stage
    
    //Outputs of stage
    execute_t execute_p;
    
    modport EX (
        input ihit, dhit, flush, freeze, decode_p, 
        output execute_p
    );

endinterface
`endif