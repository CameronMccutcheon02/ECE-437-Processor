`include "pipeline_latch.vh"
// `include "cpu_types_pkg.vh"

// import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`ifdef MAPPED
`timescale 1 ns / 1 ns
`endif


module pipeline_latch_tb;
    parameter PERIOD = 10;

    logic CLK = 0, nRST; //Technically don't need the clock, but we can use it to regularly space out stuff

    // clock
    always #(PERIOD/2) CLK++;



endmodule