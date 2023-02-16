`ifndef DEC_IF_VH
`define DEC_IF_VH
`include "cpu_types_pkg.vh"
`include "custom_types_pkg.vh"

interface decode_if;
    import cpu_types_pkg::*;
    import custom_types_pkg::*;

    //Inputs to stage
    logic ihit, dhit, flush, freeze;
    fetch_t fetch_p; //bus inputs from fetch stage
    writeback_t writeback_p; //bus inputs from writeback stage

    //Outputs of stage
    decode_t decode_p;
    logic BEQ, BNE, equal;
    logic [1:0] JumpSel;
    
    modport DC (
        input ihit, dhit, flush, freeze, fetch_p, writeback_p,
        output decode_p, BEQ, BNE, equal, JumpSel
    );

endinterface
`endif