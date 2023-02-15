`ifndef DEC_IF_VH
`define DEC_IF_VH
`include "cpu_types_pkg.vh"

interface decode_if;
    import cpu_types_pkg::*;
    import structs::*;

    //Inputs to stage
    logic ihit, dhit, flush, freeze;
    fetch_t fetch_p; //bus inputs from fetch stage
    memory_t memory_p; //bus inputs from writeback stage

    //Outputs of stage
    decode_t decode_p;
    
    modport DC (
        input ihit, dhit, flush, freeze, fetch_p, memory_p,
        output decode_p
    );

endinterface
`endif