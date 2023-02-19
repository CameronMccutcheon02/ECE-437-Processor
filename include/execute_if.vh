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

    //Fowrwarding unit inputs
    logic [1:0] port_a_forwarding_control, port_b_forwarding_control;
    word_t FW_execute_data, FW_writeback_data;
    
    //Outputs of stage
    execute_t execute_p;
    
    modport EX (
        input ihit, dhit, flush, freeze, decode_p, 
        input port_a_forwarding_control, port_b_forwarding_control,
        input FW_execute_data, FW_writeback_data,
        output execute_p
    );

endinterface
`endif