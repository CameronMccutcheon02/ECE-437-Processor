
`include "register_file_if.vh"

module register_file (
    //Write Inputs
    input logic CLK, nRST,
    register_file_if.rf rfif

);

logic [31:0] Primary_Data [31:0]; //Initialize primary data
logic [31:0] Primary_Data_nxt [31:0]; //Initialize primary data

always_ff @(posedge CLK, negedge nRST) begin 
    if (!nRST) begin
        for (integer j = 0; j < 32; j = j+1) Primary_Data[j] <= 0; //Reset Data Buffer 
    end
    else begin
        Primary_Data <= Primary_Data_nxt; 

    end
end

always_comb begin //Write Control
    Primary_Data_nxt = Primary_Data;
    if(rfif.WEN && rfif.wsel != 0) //Check that we are writing but not writing to reg.0
        Primary_Data_nxt[rfif.wsel] = rfif.wdat;
end

always_comb begin //Read Control
    rfif.rdat1 = Primary_Data[rfif.rsel1];  //Set the output of the read1
    rfif.rdat2 = Primary_Data[rfif.rsel2];  //set output of read2
end


endmodule