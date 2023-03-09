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

//Struct and data container declarations
    typedef enum logic [3:0] { IDLE, WB1, WB2, R1M, R2M, FL1, FL2, CNTW, STOP } CacheState;
    CacheState cur_state, nxt_state;

    localparam ASCT = 2; //sets associativity constant
    localparam BLKSZ = 2; //sets number of data words per block
    localparam TGSZ = 26; //sets tag size
    localparam CCSZ = 8; //Sets number of cache columns
    typedef struct packed {
        logic valid;
        logic [TGSZ-1:0] tag;
        word_t [BLKSZ-1:0] data;
        logic dirty;
    } frame_struct;

    frame_struct cache [CCSZ:0][ASCT-1:0];
    frame_struct nxt_cache [CCSZ:0][ASCT-1:0];

    logic LRU [CCSZ:0]; //least recently used associative block FSM
    logic nxt_LRU [CCSZ:0]; //least recently used associative block FSM
//********************************************************************\\


//Internal Variable Declarations
    logic [TGSZ-1:0] datapath_tag;
    assign datapath_tag = dcif.dmemaddr[31:31-TGSZ];

    logic [32-TGSZ-BLKSZ:0] datapath_index; //not that the BLKSZ here is actually the log2(BLKSZ)
    assign datapath_index = dcif.dmemaddr[32-TGSZ-BLKSZ+1:3];

    logic datapath_block_offset;
    assign datapath_block_offset = dcif.dmemaddr[2];


    logic miss, hit;
    logic valid, dirty; //easy to grab copies of the valid and dirty bits of the currently accessed cache val
//********************************************************************\\


always_ff @(posedge CLK, negedge nRST) begin : clockblock
    if(~nRST) begin
        cur_state <= IDLE;
        //cache <= '0;
    end
    else begin
        cur_state <= nxt_state;
        cache <= nxt_cache;
    end
end


always_comb begin : nxt_state_logic
    nxt_state = cur_state;
    case(cur_state)
        IDLE: begin 
                if(dcif.halt) nxt_state = FL1;
                else if(miss & (~dirty | ~valid)) nxt_state = R1M;
                else if(miss & valid & dirty) nxt_state = WB1;
        end
        WB1:    nxt_state = (cif.dwait) ? WB1 : WB2;
        WB2:    nxt_state = (cif.dwait) ? WB2 : R1M;
        R1M:    nxt_state = (cif.dwait) ? R1M : R2M;
        R2M:    nxt_state = (cif.dwait) ? R2M : IDLE;
        FL1:    nxt_state = (cif.dwait) ? FL1 : FL2;
        FL2:    nxt_state = (cif.dwait) ? FL2 : 
                                (dirty) ? FL1 : CNTW;
        CNTW:   nxt_state = (cif.dwait) ? CNTW : STOP;
        STOP:   nxt_state = STOP;
    endcase
end

always_comb begin : memory_read_write_logic
    nxt_cache = cache;
    nxt_LRU = LRU;

    //valid for memory side transactions
    cif.dREN = 0;
    cif.dWEN = 0;
    cif.daddr = 0;
    cif.dstore = 0;

    //valid only for datapath size transactions
    dcif.dhit = 0;
    hit = 0;
    dcif.dmemload = 32'd0;
    miss = 1;
    dirty = 0;
    valid = 0;
    case(cur_state)  
        IDLE: begin
            //Read Logic
            if(dcif.dmemREN) begin //drives read outputs to the datapath
                for (int i = 0; i < ASCT; i++) begin
                    if (cache[datapath_index][i].tag == datapath_tag && cache[datapath_index][i].valid) begin
                        dcif.dhit = 1;
                        hit = 1;
                        miss = 0;
                        dcif.dmemload = cache[datapath_index][i].data[datapath_block_offset];
                        nxt_LRU[datapath_index] = (i == 0) ? 1 : 0;
                        break;
                    end
                end
            end

            //Write Logic
            if(dcif.dmemWEN) begin //drives write outputs into the cache
                for (int i = 0; i < ASCT; i++) begin
                    if (cache[datapath_index][i].tag == datapath_tag && cache[datapath_index][i].valid) begin
                        dcif.dhit = 1;
                        hit = 1;
                        miss = 0;
                        nxt_cache[datapath_index][i].data[datapath_block_offset] = dcif.dmemstore;
                        nxt_LRU[datapath_index] = (i == 0) ? 1 : 0;
                        break;
                    end
                end
            end

            if(miss) begin  //if no block matches our tag, set up signals for WB1 or R1M transfers
                    dirty = cache[datapath_index][LRU[datapath_index]].dirty;
                    valid = cache[datapath_index][LRU[datapath_index]].valid;
                end
        end

        R1M:    begin
            cif.dREN = 1;
            cif.daddr = dcif.dmemaddr;
            nxt_cache[datapath_index][LRU[datapath_index]].data[0] = cif.dload;

        end
        R2M:    begin
            cif.dREN = 1;
            cif.daddr = dcif.dmemaddr + 4;
            nxt_cache[datapath_index][LRU[datapath_index]].data[1] = cif.dload;
        end
        WB1:    begin
            cif.dWEN = 1;
            cif.daddr   = {cache[datapath_index][LRU[datapath_index]].tag, datapath_index, 1'b0/*use first block here*/, 2'b00};
            cif.dstore  = cache[datapath_index][LRU[datapath_index]].data[0];
        end    
        WB2:    begin
            cif.dWEN = 1;
            cif.daddr   = {cache[datapath_index][LRU[datapath_index]].tag, datapath_index, 1'b1/*use second block here*/, 2'b00};
            cif.dstore  = cache[datapath_index][LRU[datapath_index]].data[0];
        end       
        FL1:    begin

        end    
        FL2:    begin

        end    
        CNTW:   begin

        end   

    endcase
end





endmodule
