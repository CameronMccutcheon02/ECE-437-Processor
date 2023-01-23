/*
  Eric Villasenor
  evillase@gmail.com

  register file fpga wrapper
*/

// interface
`include "alu_if.vh"

module alu_fpga (
  input logic CLOCK_50,
  input logic [3:0] KEY,
  input logic [17:0] SW,
  output logic [6:0] HEX0, HEX1, HEX2,HEX3,HEX4,HEX5,HEX6,HEX7
);

  // interface
  alu_if aluif();
  // rf
  alu DUT(aluif);

assign aluif.alu_op = aluop_t'(KEY[3:0]);

LUT H0(.val(aluif.port_o[3:0]),   .HEX0(HEX0));
LUT H1(.val(aluif.port_o[7:4]),   .HEX0(HEX1));
LUT H2(.val(aluif.port_o[11:8]),  .HEX0(HEX2));
LUT H3(.val(aluif.port_o[15:12]), .HEX0(HEX3));
LUT H4(.val(aluif.port_o[19:16]), .HEX0(HEX4));
LUT H5(.val(aluif.port_o[23:20]), .HEX0(HEX5));
LUT H6(.val(aluif.port_o[27:24]), .HEX0(HEX6));
LUT H7(.val(aluif.port_o[31:27]), .HEX0(HEX7));

always_ff @(posedge CLOCK_50) begin
  if (SW[17]) 
    aluif.port_b = {{16{SW[16]}}, SW[15:0]};
end

assign aluif.port_a = {{16{SW[16]}}, SW[15:0]};


endmodule


module LUT (
  input [3:0] val,
  output [6:0] HEX0
);

always_comb
  begin
    unique casez (val)
      'h0: HEX0 = 7'b1000000;
      'h1: HEX0 = 7'b1111001;
      'h2: HEX0 = 7'b0100100;
      'h3: HEX0 = 7'b0110000;
      'h4: HEX0 = 7'b0011001;
      'h5: HEX0 = 7'b0010010;
      'h6: HEX0 = 7'b0000010;
      'h7: HEX0 = 7'b1111000;
      'h8: HEX0 = 7'b0000000;
      'h9: HEX0 = 7'b0010000;
      'ha: HEX0 = 7'b0001000;
      'hb: HEX0 = 7'b0000011;
      'hc: HEX0 = 7'b0100111;
      'hd: HEX0 = 7'b0100001;
      'he: HEX0 = 7'b0000110;
      'hf: HEX0 = 7'b0001110;
    endcase
  end


endmodule
