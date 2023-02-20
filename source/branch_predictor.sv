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


    logic [1:0] br_pred [2047:0]; //intialize the bits of the branch predictor table (state machine)
    logic [1:0] br_pred_nxt [2047:0]; //intialize the bits of the branch predictor table (state machine)

    logic [31:0] BTB [2047:0];
    logic [31:0] BTB_nxt [2047:0];

    always_ff @(posedge CLK, negedge nRST) begin
        if (~nRST) begin
            for (int i = 0; i < 2048; i++) begin
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
        case (br_pred[PC_mem[12:2]])
            2'b00: br_pred_nxt[PC_mem[12:2]] = 2'b01; //taken hard mispredict to taken soft
            2'b01: br_pred_nxt[PC_mem[12:2]] = 2'b10; //taken soft mispredict to not taken hard
            2'b10: br_pred_nxt[PC_mem[12:2]] = 2'b11; //not taken hard mispredict to not taken soft
            2'b11: br_pred_nxt[PC_mem[12:2]] = 2'b00; //not taken soft mispredict to taken hard
        endcase
    end
    else if begin
        case (br_pred[PC_mem[12:2]])
            2'b00: br_pred_nxt[PC_mem[12:2]] = 2'b00; //taken hard predict to taken hard
            2'b01: br_pred_nxt[PC_mem[12:2]] = 2'b00; //taken soft predict to taken hard
            2'b10: br_pred_nxt[PC_mem[12:2]] = 2'b10; //not taken hard predict to not taken hard
            2'b11: br_pred_nxt[PC_mem[12:2]] = 2'b10; //not taken soft predict to not taken hard
        endcase
    end
end

//branch target and branch taken logic
always_comb begin
    bpif.branch_taken = 1'b0;
    bpif.branch_target = 32'd0;
    case(br_pred[PC_current[12:2]])
        2'b00:  begin 
            //if we get a non-zero from the BTB table, send the target out
            if (BTB[PC_current[12:2]] != 0) begin
                bpif.branch_taken = 1'b1; 
                bpif.branch_target = BTB[PC_Current[12:2]];
            end
        end
        2'b01:  begin 
            //if we get a non-zero from the BTB table, send the target out
            if (BTB[PC_current[12:2]] != 0) begin
                bpif.branch_taken = 1'b1; 
                bpif.branch_target = BTB[PC_Current[12:2]];
            end
        end
        2'b10:  bpif.branch_taken = 1'b0;
        2'b11:  bpif.branch_taken = 1'b0;
    endcase
end


//BTB table updating logic
always_comb begin
    BTB_nxt = BTB;
    if((BTB[PC_mem[12:2]] != bpif.branch_target_mem) && (bpif.BEQ || bpif.BNE)) begin
        BTB_nxt[PC_mem[12:2]] = bpif.branch_target_mem;

    end
end

    


endmodule