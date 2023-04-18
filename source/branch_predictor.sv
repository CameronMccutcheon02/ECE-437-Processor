//Cameron McCutcheon

`include "alu_if.vh"
`include "execute_if.vh"

`include "cpu_types_pkg.vh"
`include "custom_types_pkg.vh"

module branch_predictor (
    input logic CLK, nRST,
    branch_predictor_if.BP bpif
);

    //grab all the structs values
    import cpu_types_pkg::*;
    import custom_types_pkg::*;

    // initialize structs
    localparam MEMSIZE = 32;
    localparam ADDRSIZE = 6;

    logic [1:0] br_pred [MEMSIZE -1:0]; //intialize the bits of the branch predictor table (state machine)
    logic [1:0] br_pred_nxt [MEMSIZE -1:0]; //intialize the bits of the branch predictor table (state machine)

    logic [31:0] BTB [MEMSIZE -1:0];
    logic [31:0] BTB_nxt [MEMSIZE -1:0];
    

    always_ff @(posedge CLK, negedge nRST) begin
        if (~nRST) begin
            for (int i = 0; i < MEMSIZE ; i++) begin
                br_pred[i] <= 2'b00; //initialize all in taken hard
                BTB[i] <= '0;
            end
        end 
        else begin
            br_pred <=  br_pred_nxt;
            BTB     <=  BTB_nxt;
        end
    end

//br_pred_next logic
always_comb begin
    br_pred_nxt = br_pred;
    if(bpif.branch_mispredict) begin
        case (br_pred[bpif.PC_mem[ADDRSIZE:2]])
            2'b00: br_pred_nxt[bpif.PC_mem[ADDRSIZE:2]] = 2'b01; //taken hard mispredict to taken soft
            2'b01: br_pred_nxt[bpif.PC_mem[ADDRSIZE:2]] = 2'b10; //taken soft mispredict to not taken hard
            2'b10: br_pred_nxt[bpif.PC_mem[ADDRSIZE:2]] = 2'b11; //not taken hard mispredict to not taken soft
            2'b11: br_pred_nxt[bpif.PC_mem[ADDRSIZE:2]] = 2'b00; //not taken soft mispredict to taken hard
        endcase
    end
    else begin
        case (br_pred[bpif.PC_mem[ADDRSIZE:2]])
            2'b00: br_pred_nxt[bpif.PC_mem[ADDRSIZE:2]] = 2'b00; //taken hard predict to taken hard
            2'b01: br_pred_nxt[bpif.PC_mem[ADDRSIZE:2]] = 2'b00; //taken soft predict to taken hard
            2'b10: br_pred_nxt[bpif.PC_mem[ADDRSIZE:2]] = 2'b10; //not taken hard predict to not taken hard
            2'b11: br_pred_nxt[bpif.PC_mem[ADDRSIZE:2]] = 2'b10; //not taken soft predict to not taken hard
        endcase
    end
end

//branch target and branch taken logic
always_comb begin
    bpif.branch_taken = 1'b0;
    bpif.branch_target = 32'd0;
    case(br_pred[bpif.PC_Current[ADDRSIZE:2]])
        2'b00:  begin 
            //if we get a non-zero from the BTB table, send the target out
            if (BTB[bpif.PC_Current[ADDRSIZE:2]] != 0) begin
                bpif.branch_taken = 1'b1; 
                bpif.branch_target = BTB[bpif.PC_Current[ADDRSIZE:2]];
            end
        end
        2'b01:  begin 
            //if we get a non-zero from the BTB table, send the target out
            if (BTB[bpif.PC_Current[ADDRSIZE:2]] != 0) begin
                bpif.branch_taken = 1'b1; 
                bpif.branch_target = BTB[bpif.PC_Current[ADDRSIZE:2]];
            end
        end
        2'b10:  bpif.branch_taken = 1'b0;
        2'b11:  bpif.branch_taken = 1'b0;
    endcase

    //BTB table updating logic
    BTB_nxt = BTB;
    if((BTB[bpif.PC_mem[ADDRSIZE:2]] != bpif.branch_addr_mem) && (bpif.BEQ || bpif.BNE)) begin
        BTB_nxt[bpif.PC_mem[ADDRSIZE:2]] = bpif.branch_addr_mem;
         //if the branch addr from mem does not 
        //match that in the table, use the address of the mem stage and flush
    end

    bpif.branch_taken = 1'b0;
    bpif.branch_target = 32'd0;
end





    


endmodule