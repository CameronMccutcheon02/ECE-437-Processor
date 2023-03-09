//Cameron McCutcheon

// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// cpu types
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module dcache (
    input logic CLK, nRST,
    datapath_cache_if.dcache dcif,
    caches_if cif
);

typedef enum logic [3:0] { IDLE, WB1, WB2, R1M, R2M, WC, FL1, FL2, CNTW, STOP } CacheState;

CacheState cur_state, nxt_state;

localparam ASCT = 2; //sets associativity constant
localparam BLKSZ = 2; //sets block size constant
localparam TGSZ = 28;
typedef struct packed {
    logic valid;
    logic [TGSZ-1:0] tag;
    word_t data [BLKSZ-1:0];
    logic dirty;
} frame_struct;

always_ff @(posedge CLK, negedge nRST) begin : blockName
    
end



endmodule
