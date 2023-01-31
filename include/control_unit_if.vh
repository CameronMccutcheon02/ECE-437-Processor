/*
  Cameron McCutcheon

  Control Unit IF
*/
`ifndef CU_IF_VH
`define CU_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface CU_if;
    // import types
    import cpu_types_pkg::*;
    
    //Instruction memory ports
    opcode_t    instr_op; //Instr <31:26>
    funct_t     funct_op; //Instr <5:0>

    aluop_t     alu_op; //alu opcode typedef
    logic       RegDst, Branch, MemRead, MemToReg, MemWrite, RegWrite;
    logic [1:0] ExtType, Jump;


    // register file ports
    modport CU (
        input   instr_op, funct_op,
        output  alu_op, 
        output  RegDst, Jump, Branch, MemRead, MemToReg, MemWrite, RegWrite, ExtType
    );
    // register file tb
    modport tb (
        output   instr_op, funct_op,
        input  alu_op, 
        input  RegDst, Jump, Branch, MemRead, MemToReg, MemWrite, RegWrite, ExtType
    );
endinterface

`endif //REGISTER_FILE_IF_VH
