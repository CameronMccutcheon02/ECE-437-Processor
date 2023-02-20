`ifndef BRP_IF_VH
`define BRP_IF_VH
`include "cpu_types_pkg.vh"
`include "custom_types_pkg.vh"

interface branch_predictor_if;
    import cpu_types_pkg::*;
    import custom_types_pkg::*;

    //Inputs to stage from inside fetch
    word_t PC_current, NPC_current;

    //Inputs from memory/branch resolution stage
    word_t PC_mem, NPC_mem; //taken directly from pipeline
    word_t branch_target_mem;
    logic branch_mispredict;
    logic BEQ, BNE; //taken directly from pipeline
    

    //Outputs to bus/next_pc logic
    logic branch_taken;
    word_t branch_target;
    
    
    //Outputs of stage
    execute_t execute_p;
    
    modport BP (
        input PC_current, NPC_current,
        input PC_mem, NPC_mem, branch_target_mem, branch_mispredict,
        output branch_taken, branch_target
    );

endinterface
`endif