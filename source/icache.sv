//Cameron McCutcheon

// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// cpu types
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module icache (
    input logic CLK, nRST,
    datapath_cache_if.cache dcif,
    caches_if cif
);

    localparam ASCT = 1; //sets associativity constant
    localparam BLKSZ = 1; //sets block size constant
    localparam TGSZ = 26;

    typedef struct packed {
        logic valid;
        logic [TGSZ-1:0] tag;
        word_t [BLKSZ-1:0] data;
    } frame_struct;

    icache_frame [15:0] icache;

    logic [25:0] tag;
    logic [3:0] index;

    assign tag = dcif.imemaddr[31:6];
    assign index = dcif.imemaddr[5:2];

    always_ff @(posedge CLK, negedge nRST) begin: Reg_Logic
        if (~nRST) begin
            // initialize icahce to 0's
            icache <= '0;
        end else if (~cif.iwait & dcif.imemREN) begin
            // on ihit, load instruction into icache as well
            icache <= icache;
            icache[index].valid <= 1'b1;
            icache[index].tag <= tag;
            icache[index].data <= cif.iload;
        end else begin
            // hold current instruction in cache
            icache <= icache;
        end
    end

    always_comb begin: Out_Logic
        cif.iREN = 0;
        cif.iaddr = dcif.imemaddr;

        dcif.ihit = 0;
        dcif.imemload = '0;

        // we only care about instruction fetches
        if (dcif.imemREN) begin
            if ((icache[index].tag == tag) & icache[index].valid) begin // if we have a valid hit, pass the block to datapath
                // give datapath the instruction we have ready in icache
                dcif.ihit = 1'b1;
                dcif.imemload = icache[index].data;
            end else begin // if we dont have a hit in the cache, pass the job to memory
                // send memory the instruction we want
                cif.iREN = dcif.imemREN;
                cif.iaddr = dcif.imemaddr;

                // give datapath the instruction that memory gives us
                dcif.ihit = ~cif.iwait;
                dcif.imemload = cif.iload;
            end
        end
    end

endmodule
