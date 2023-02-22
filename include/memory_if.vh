`ifndef MEM_IF_VH
`define MEM_IF_VH
`include "cpu_types_pkg.vh"
`include "custom_types_pkg.vh"

interface memory_if;
    import cpu_types_pkg::*;
    import custom_types_pkg::*;

    //Inputs to stage
    logic ihit, dhit, flush, freeze;
    execute_t execute_p; //latch inputs from last stage
    word_t dmemload;

    //Outputs of stage
    memory_t memory_p;
    word_t dmemaddr, dmemstore;
    logic dmemREN, dmemWEN;
    word_t BranchAddr, JumpAddr, port_a;
    logic [1:0] JumpSel;
    logic BranchTaken, branch_mispredict;
    word_t PC;

    word_t forwarding_unit_data;
    
    modport MEM (
        input ihit, dhit, flush, freeze, execute_p, dmemload,
        output forwarding_unit_data,
        output memory_p, dmemaddr, dmemstore, dmemREN, dmemWEN, 
        output BranchAddr, BranchTaken, branch_mispredict, PC,
        output JumpSel, JumpAddr, port_a
    );

endinterface
`endif