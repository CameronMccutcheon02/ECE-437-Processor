/*
  Cameron McCutcheon

  Control Unit IF
*/
`ifndef PL_IF_VH
`define PL_IF_VH

// all types
//`include "cpu_types_pkg.vh"


interface pipeline_if #(parameter int NUM_INPUTS=1);
    logic [][]data
    logic [NUM_INPUTS-1:0] in_data[]; //each array will be some amount wide, but there will be n many of them
    logic [NUM_INPUTS-1:0] out_data[]; //each array will be some amount wide, but there will be n many of them

    function void transfer(); //on clock edge, we can call the store method to grab these outputs
        for (int i=0; i<NUM_INPUTS; i++) begin
            out_data[i] = in_data[i];
        end
    endfunction

    function void clear_to_nop();
        for (int i=0; i<NUM_INPUTS; i++) begin
            out_data[i] = 0;
        end
    endfunction
endinterface


// function new_stage #(parameter int NUM_INPUTS=1);
//         pipeline_stage #(NUM_INPUTS) pipe_stage;
//         for (int i=0; i<NUM_INPUTS; i++) begin
//             pipe_stage.valid[i] <= 0;
//             pipe_stage.ready[i] <= 1;
//         end
//         return pipe_stage;
//     endfunction

`endif

