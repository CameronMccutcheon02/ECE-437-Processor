/*
  Cameron McCutcheon

  extender unit block
*/
`include "cpu_types_pkg.vh"

module extender(
    input logic [15:0] in_data,
    input logic [1:0] ExtType,
    output logic [31:0] out_data //Doesnt like a word_t here

);

always_comb begin
    case(ExtType)
        2'b00: out_data = {16'd0, in_data}; //Zero extend
        2'b01: out_data = {{16{in_data[15]}}, in_data}; //Sign Extend
        2'b10: out_data = {in_data, 16'd0}; //fill 0 bottom
        default: out_data = {16'd0, in_data};
    endcase
end

endmodule