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
    logic       neg, zero, over;
    word_t      port_a, port_b, port_o;


    // register file ports
    modport CU (
        input   alu_op, port_a, port_b,
        output  neg, zero, over, port_o
    );
    // register file tb
    modport tb (
        output   alu_op, port_a, port_b,
        input  neg, zero, over, port_o
    );
endinterface

`endif //REGISTER_FILE_IF_VH
