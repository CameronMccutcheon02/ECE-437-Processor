`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH

`include "cpu_types_pkg.vh"

interface control_unit_if;
    import cpu_types_pkg::*;

    opcode_t opcode;
    funct_t func;
    aluop_t ALUctr;
    logic ihit, dhit, zero;
    logic jal, RegDst, RegWEN, ALUSrc, BEQ, BNE,
          halt, iREN, dREN, dWEN;
    logic [1:0] MemtoReg;
    logic [1:0] JumpSel; 
    logic [1:0] ExtOP;
     
    modport cu (
        input opcode, func, ihit, dhit,
        output JumpSel, jal, RegDst, RegWEN, ALUSrc, BEQ, BNE,
               ALUctr, MemtoReg, ExtOP, halt, iREN, dREN, dWEN
    );

    modport tb (
        input JumpSel, jal, RegDst, RegWEN, ALUSrc, BEQ, BNE,
              ALUctr, MemtoReg, ExtOP, halt, iREN, dREN, dWEN,
        output opcode, func, ihit, dhit
    );

endinterface

`endif