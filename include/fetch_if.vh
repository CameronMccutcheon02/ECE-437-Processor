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

    //Outputs of stage
    fetch_t fetch_p;
    logic imemREN;
    word_t imemaddr;

    //Inputs from Mem
    logic   BranchTaken;
    word_t  BranchAddr;
    logic   [1:0] JumpSel;
    word_t  JumpAddr;
    word_t  port_a;
    word_t  PC_mem, NPC_mem;
    logic   branch_mispredict;
    logic   BNE, BEQ;
    
    modport FT (
        input ihit, dhit, flush, freeze, imemload, 
        input BranchTaken, BranchAddr, PC_mem, NPC_mem, branch_mispredict, BNE, BEQ,
        input JumpSel, JumpAddr, port_a, 
        output fetch_p, imemREN, imemaddr
    );


endinterface
`endif