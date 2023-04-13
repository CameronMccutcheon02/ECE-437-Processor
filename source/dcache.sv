//Cameron McCutcheon

// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// cpu types
`include "cpu_types_pkg.vh"
`include "custom_types_pkg.vh"

import cpu_types_pkg::*;
import custom_types_pkg::*;

module dcache (
    input logic CLK, nRST,
    datapath_cache_if.dcache dcif,
    caches_if.dcache cif
);

//Struct and data container declarations
    dcache_t cur_state, nxt_state, prev_state;

    localparam ASCT = 2; //sets associativity constant
    localparam BLKSZ = 2; //sets number of data words per block
    localparam TGSZ = 26; //sets tag size
    localparam CCSZ = 8; //Sets number of cache rows
    typedef struct packed {
        logic valid;
        logic [TGSZ-1:0] tag;
        word_t [BLKSZ-1:0] data;
        logic dirty;
    } frame_struct;

    typedef struct packed {
        frame_struct [ASCT-1:0] frame;
        logic LRU;
    } set_struct;

    set_struct [CCSZ-1:0] dcache;
    set_struct [CCSZ-1:0] nxt_dcache;

//********************************************************************\\


//Internal Variable Declarations
    dcachef_t addr;
    assign addr = dcachef_t'(dcif.dmemaddr);

    dcachef_t snoopaddr;
    assign snoopaddr = dcachef_t'(cif.ccsnoopaddr);

    logic [TGSZ-1:0] datapath_tag;
    assign datapath_tag = addr.tag; //dcif.dmemaddr[31:31-TGSZ+1];

    logic [32-TGSZ-BLKSZ-1-1:0] datapath_index; //not that the BLKSZ here is actually the log2(BLKSZ)
    assign datapath_index = addr.idx; //dcif.dmemaddr[32-TGSZ-BLKSZ+1:3];

    logic datapath_block_offset;
    assign datapath_block_offset = addr.blkoff; //dcif.dmemaddr[2];

    logic [1:0] datapath_byte_offset;
    assign datapath_byte_offset = addr.bytoff;


    logic [3:0] row;
    logic [3:0] nxt_row;

    word_t hit_count;
    word_t nxt_hit_count;

    logic miss;
    logic valid, dirty; //easy to grab copies of the valid and dirty bits of the currently accessed cache val

    lr_t lr, nxt_lr; // link register attached to the cache

//********************************************************************\\


always_ff @(posedge CLK, negedge nRST) begin : clockblock
    if(~nRST) begin
        cur_state <= LAZY;
        prev_state <= LAZY;
        dcache <= '0;
        row <= '0;
        hit_count <= '0;
        lr <= '0;
    end
    else begin
        prev_state <= cur_state;
        cur_state <= nxt_state;
        dcache <= nxt_dcache;
        row <= nxt_row;
        hit_count <= nxt_hit_count;
        lr <= nxt_lr;
    end
end


always_comb begin : nxt_state_logic
    nxt_row = row;
    nxt_state = cur_state;
    if (~cif.ccwait) begin
        case(cur_state)
            LAZY: begin 
                    if(dcif.halt) nxt_state = FLCTR;
                    if (dcif.dmemREN | dcif.dmemWEN) begin //dcif 
                        if(miss & (~dirty | ~valid)) nxt_state = R1M;
                        else if(miss & valid & dirty) nxt_state = WB1;
                    end
            end
            WB1:    nxt_state = (~cif.dwait) ? WB2 : WB1;
            WB2:    nxt_state = (~cif.dwait) ? R1M : WB2;
            R1M:    nxt_state = (~cif.dwait) ? R2M : R1M;
            R2M:    nxt_state = (~cif.dwait) ? LAZY : R2M;
            FLCTR: begin
                    nxt_row = row;
                    nxt_state = cur_state;
                    if (dcache[row[3:1]].frame[row[0]].dirty) begin
                        nxt_state = FL1;
                    end else begin
                        nxt_row = row + 1;
                    end
                    if (row == 4'd15 && nxt_row == 0)
                        nxt_state = STOP;
            end
            FL1:    nxt_state = (~cif.dwait) ? FL2 : FL1;
            FL2:    nxt_state = (~cif.dwait) ? FLCTR: FL2;
            CNTW:   nxt_state = (~cif.dwait) ? STOP : CNTW;
            STOP:   nxt_state = STOP;
        endcase
    end
end

always_comb begin : memory_read_write_logic
    nxt_dcache = dcache;
    nxt_hit_count = hit_count;

    //valid for memory side transactions
    cif.dREN = 0;
    cif.dWEN = 0;
    cif.daddr = 0;
    cif.dstore = 0;

    //valid only for datapath size transactions
    dcif.dhit = 0;
    dcif.dmemload = 32'd0;
    dcif.flushed = 0;
    miss = 1;
    dirty = 0;
    valid = 0;

    //coherence defaults
    cif.ccwrite = 0;
    cif.cctrans = 0;

    //link register
    nxt_lr.addr = lr.addr;
    nxt_lr.valid = lr.valid;

    //coherence handlers
    if(cif.ccwait) begin //if we are doing a transaction for the bus, we need to make sure we do it here
        for (int i = 0; i < ASCT; i++) begin
            if (dcache[snoopaddr.idx].frame[i].tag == snoopaddr.tag && dcache[snoopaddr.idx].frame[i].valid) begin
                cif.ccwrite = 1'b1; //if we get a hit in the cache, tell the bus we have it
                cif.dstore = dcache[snoopaddr.idx].frame[i].data[snoopaddr.blkoff];
                cif.daddr = cif.ccsnoopaddr;
                if(cif.ccinv) 
                    nxt_dcache[snoopaddr.idx].frame[i].valid = 1'b0;
                else 
                    nxt_dcache[snoopaddr.idx].frame[i].dirty = 1'b0;

                nxt_dcache[datapath_index].LRU = (i == 1) ? 1 : 0;
            end
        end
        if (cif.ccsnoopaddr == lr.addr) begin
            nxt_lr.addr = '0;
            nxt_lr.valid = 1'b0;
        end
    end


    //normal transaction handlings
    else begin
    case(cur_state)  
        LAZY: begin
            if (dcif.halt) begin
                nxt_hit_count = hit_count;
            //Read Logic
            end else if(dcif.dmemREN) begin //drives read outputs to the datapath
                for (int i = 0; i < ASCT; i++) begin
                    if (dcache[datapath_index].frame[i].tag == datapath_tag && dcache[datapath_index].frame[i].valid) begin
                        dcif.dhit = 1'b1;
                        miss = 0;
                        dcif.dmemload = dcache[datapath_index].frame[i].data[datapath_block_offset];
                        nxt_dcache[datapath_index].LRU = (i == 0) ? 1 : 0;
                        if (prev_state != R2M)
                            nxt_hit_count = hit_count + 1;
                        break;
                    end
                end
            end

            //Write Logic
            else if(dcif.dmemWEN) begin //drives write outputs into the cache
                for (int i = 0; i < ASCT; i++) begin
                    if (dcache[datapath_index].frame[i].tag == datapath_tag && dcache[datapath_index].frame[i].valid) begin
                        dcif.dhit = 1;
                        miss = 0;
                        nxt_dcache[datapath_index].frame[i].data[datapath_block_offset] = dcif.dmemstore;
                        nxt_dcache[datapath_index].frame[i].dirty = 1;

                        nxt_dcache[datapath_index].LRU = (i == 0) ? 1 : 0;

                        cif.cctrans = 1;
                        cif.daddr = dcif.dmemaddr;

                        if (dcif.datomic) begin // SC instruction
                            if (lr.addr == dcif.dmemaddr & lr.valid == 1'b1) begin // return 1 and store
                                dcif.dmemload = 1'b1;
                                nxt_lr.valid = 1'b0;
                            end
                            else if (lr.addr == dcif.dmemaddr & lr.valid == 1'b0) begin // return 0 and dont store
                                dcif.dmemload = 1'b0;

                                nxt_dcache[datapath_index].frame[i].data[datapath_block_offset] = dcache[datapath_index].frame[i].data[datapath_block_offset];
                                nxt_dcache[datapath_index].frame[i].dirty = dcache[datapath_index].frame[i].dirty;

                                nxt_dcache[datapath_index].LRU = dcache[datapath_index].LRU;
                            end
                        end

                        break;
                    end
                end
            end

            if(miss) begin  //if no block matches our tag, set up signals for WB1 or R1M transfers
                dirty = dcache[datapath_index].frame[dcache[datapath_index].LRU].dirty;
                valid = dcache[datapath_index].frame[dcache[datapath_index].LRU].valid;
            end
        end

        R1M:    begin
            cif.dREN = 1;
            cif.daddr = {datapath_tag, datapath_index, 1'b0, 2'b00};
            if (~cif.dwait) begin 
                nxt_dcache[datapath_index].frame[dcache[datapath_index].LRU].data[0] = cif.dload;
                nxt_dcache[datapath_index].frame[dcache[datapath_index].LRU].valid = 1'b1;
            end
        end
        R2M:    begin
            cif.dREN = 1;
            cif.daddr = {datapath_tag, datapath_index, 1'b1, 2'b00};
            if (~cif.dwait) begin
                nxt_dcache[datapath_index].frame[dcache[datapath_index].LRU].data[1] = cif.dload;
                nxt_dcache[datapath_index].frame[dcache[datapath_index].LRU].tag = datapath_tag;
                nxt_dcache[datapath_index].frame[dcache[datapath_index].LRU].dirty = 1'b0;
            end
            if (dcif.datomic) begin
                nxt_lr.valid = 1'b1;
                nxt_lr.addr = dcif.dmemaddr;
            end
        end
        WB1:    begin
            cif.dWEN = 1;
            cif.daddr   = {dcache[datapath_index].frame[dcache[datapath_index].LRU].tag, datapath_index, 1'b0, 2'b00};
            cif.dstore  = dcache[datapath_index].frame[dcache[datapath_index].LRU].data[0];
        end    
        WB2:    begin
            cif.dWEN = 1;
            cif.daddr   = {dcache[datapath_index].frame[dcache[datapath_index].LRU].tag, datapath_index, 1'b1, 2'b00};
            cif.dstore  = dcache[datapath_index].frame[dcache[datapath_index].LRU].data[1];
        end    
        FL1:    begin
            cif.dWEN = 1;
            cif.daddr = {dcache[row[3:1]].frame[row[0]].tag, row[3:1], 1'b0, 2'b00};
            cif.dstore = dcache[row[3:1]].frame[row[0]].data[0];
            nxt_dcache[row[3:1]].frame[row[0]].dirty = 0;
        end
        FL2:    begin
            cif.dWEN = 1;
            cif.daddr = {dcache[row[3:1]].frame[row[0]].tag, row[3:1], 1'b1, 2'b00};
            cif.dstore = dcache[row[3:1]].frame[row[0]].data[1];
        end    
        CNTW:   begin
            cif.dWEN = 1;
            cif.daddr = 32'h00003100;
            cif.dstore = hit_count;
        end   
        STOP: begin
            dcif.flushed = 1;

        end
    endcase
    end
end

endmodule
