`include "alu_if.vh"

module alu_fpga (
    input logic CLOCK_50,
    input logic [3:0] KEY,
    input logic [17:0] SW,
    output logic [3:0] LEDG,
    output logic [17:0] LEDR,
    output logic [6:0]  HEX7, HEX6, HEX5, 
    HEX4, HEX3, HEX2, HEX1, HEX0
);

    // Interface
    alu_if aluif ();
    // ALU
    alu ALU(aluif);

    // Inputs
    assign aluif.ALUOP[3:0] = ~KEY[3:0];
    
    always_comb begin: Port_A_Logic
        if (SW[16])
            aluif.porta = {16'hffff, SW[15:0]};
        else
            aluif.porta = {16'b0, SW[15:0]};
    end

    always_ff @(posedge CLOCK_50) begin: Port_B_Logic
        if (SW[17])
            aluif.portb <= aluif.porta;
        else
            aluif.portb <= aluif.portb;
    end

    // Output
    assign LEDG[3:0] = aluif.ALUOP;
    assign LEDR[3:0] = {aluif.negative, aluif.zero, aluif.overflow};

    ssd hex0(aluif.oport[3:0], HEX0);
    ssd hex1(aluif.oport[7:4], HEX1);
    ssd hex2(aluif.oport[11:8], HEX2);
    ssd hex3(aluif.oport[15:12], HEX3);
    ssd hex4(aluif.oport[19:16], HEX4);
    ssd hex5(aluif.oport[23:20], HEX5);
    ssd hex6(aluif.oport[27:24], HEX6);
    ssd hex7(aluif.oport[31:28], HEX7);

endmodule

module ssd (
    input logic [3:0] out,
    output logic [6:0] HEX
);
    always_comb begin: Out_Logic
        case (out)
            4'h0: HEX = 7'b1000000;
            4'h1: HEX = 7'b1111001;
            4'h2: HEX = 7'b0100100;
            4'h3: HEX = 7'b0110000;
            4'h4: HEX = 7'b0011001;
            4'h5: HEX = 7'b0010010;
            4'h6: HEX = 7'b0000010;
            4'h7: HEX = 7'b1111000;
            4'h8: HEX = 7'b0000000;
            4'h9: HEX = 7'b0010000;
            4'hA: HEX = 7'b0001000;
            4'hB: HEX = 7'b0000011;
            4'hC: HEX = 7'b0100111;
            4'hD: HEX = 7'b0100001;
            4'hE: HEX = 7'b0000110;
            4'hF: HEX = 7'b0001110;
        endcase
    end
    
endmodule