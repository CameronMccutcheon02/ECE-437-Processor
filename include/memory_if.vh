`ifndef MEM_IF_VH
`define MEM_IF_VH
`include "cpu_types_pkg.vh"

interface memory_if;
    import cpu_types_pkg::*;
    import structs::*;

    //Inputs to stage
    execute_t execute_p; //latch inputs from last stage
    logic ihit, dhit, flush, stall;
    word_t dmemload;


    //Outputs of stage
    memory_t memory_p;
    word_t dmemaddr, dmemstore;
    logic dmemREN, dmemWEN;
    
    modport MEM (
        input execute_p, ihit, dhit, dmemload,
        output memory_p, dmemaddr, dmemstore, dmemREN, dmemWEN
    );


endinterface
`endif