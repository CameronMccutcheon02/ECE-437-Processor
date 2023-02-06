`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH

`include "cpu_types_pkg.vh"

interface control_unit_if;
    import cpu_types_pkg::*;

    opcode_t opcode;
    funct_t func;
    aluop_t ALUctr;
    logic ihit, dhit, zero;
    logic jal, RegDst, RegWr, ALUSrc, BEQ, BNE,
          ExtOP, halt, iREN, dREN, dWEN;
    logic [1:0] MemtoReg;
    logic [1:0] JumpSel; 
     
    modport cu (
        input opcode, func, ihit, dhit,
        output JumpSel, jal, RegDst, RegWr, ALUSrc, BEQ, BNE,
               ALUctr, MemtoReg, ExtOP, halt, iREN, dREN, dWEN
    );

    modport tb (
        input JumpSel, jal, RegDst, RegWr, ALUSrc, BEQ, BNE,
              ALUctr, MemtoReg, ExtOP, halt, iREN, dREN, dWEN,
        output opcode, func, ihit, dhit
    );

endinterface

`endif