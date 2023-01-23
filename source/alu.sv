/*
  Cameron McCutcheon

  ALU interface
*/

`include "cpu_types_pkg.vh"
`include "alu_if.vh"
import cpu_types_pkg::*; //Why do we need this line?


module alu(
    alu_if.alu aluif
);

always_comb begin
    //Set all to be default zero
    aluif.neg = 0;
    aluif.zero = 0;
    aluif.over = 0;
    aluif.port_o = 0;
    case(aluif.alu_op)
        ALU_SLL: begin //Logical Shift left by n digits (n = port_b)
            aluif.port_o = aluif.port_b << aluif.port_a[4:0];
        end
        ALU_SRL: begin //Logical Shift right by n digits (n = port_b)
            aluif.port_o = aluif.port_b >> aluif.port_a[4:0];
        end
        ALU_ADD: begin //ADD A and B
            aluif.port_o = signed'(aluif.port_a) + signed'(aluif.port_b); //cast to signed may or may not work
            if (aluif.port_o == 0) aluif.zero = 1;
            if ((aluif.port_a[31] == aluif.port_b[31]) && (aluif.port_o[31] != aluif.port_a[31]))
                aluif.over = 1;
            if (aluif.port_o[31] == 1) aluif.neg = 1; //Maybe need edge case here when overflow is high
        end
        ALU_SUB: begin
            aluif.port_o = signed'(aluif.port_a) - signed'(aluif.port_b);
            if (aluif.port_o == 0) aluif.zero = 1;
            if ((aluif.port_a[31] != aluif.port_b[31]) && aluif.port_o[31] != aluif.port_a[31])
                aluif.over = 1;
            if (aluif.port_o[31] == 1) aluif.neg = 1; //Maybe need edge case here when overflow is high
        end
        ALU_AND: begin
            aluif.port_o = aluif.port_a & aluif.port_b;
        end
        ALU_OR: begin 
            aluif.port_o = aluif.port_a | aluif.port_b;
        end
        ALU_XOR: begin 
            aluif.port_o = aluif.port_a ^ aluif.port_b;
        end
        ALU_NOR: begin 
            aluif.port_o = ~(aluif.port_a | aluif.port_b);
        end
        ALU_SLT: begin 
            aluif.port_o = (signed'(aluif.port_a) < signed'(aluif.port_b)) ? 1 : 0;
        end
        ALU_SLTU: begin 
            aluif.port_o = ((aluif.port_a) < (aluif.port_b)) ? 1 : 0;
        end

    endcase
    if (aluif.port_o == 0) aluif.zero = 1;
    if (aluif.port_o[31] == 1) aluif.neg = 1;
end

endmodule 