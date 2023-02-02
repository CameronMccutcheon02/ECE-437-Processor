/*
  Cameron McCutcheon

  Control Unit IF
*/
`ifndef CU_IF_VH
`define CU_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface control_unit_if;
    // import types
    import cpu_types_pkg::*;
    
    //Instruction memory ports
    opcode_t    instr_op; //Instr <31:26>
    funct_t     funct_op; //Instr <5:0>

    aluop_t     alu_op; //alu opcode typedef
    logic       RegDst, Branch, MemRead, MemWrite, RegWrite, JAL, ALUSRC, halt, stall;
    logic [1:0] ExtType, Jump, MemToReg;


    // register file ports
    modport CU (
        input   instr_op, funct_op, stall,
        output  alu_op, 
        output  RegDst, Jump, Branch, MemRead, MemToReg, MemWrite, RegWrite, ExtType, JAL, ALUSRC, halt
    );
    // register file tb
    modport tb (
        output   instr_op, funct_op, stall,
        input  alu_op, 
        input  RegDst, Jump, Branch, MemRead, MemToReg, MemWrite, RegWrite, ExtType, JAL, ALUSRC, halt
    );
endinterface

`endif //REGISTER_FILE_IF_VH
