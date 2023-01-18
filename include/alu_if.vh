/*
  Cameron McCutcheon

  ALU interface
*/
`ifndef ALU_IF_VH
`define ALU_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface alu_if;
  // import types
  import cpu_types_pkg::*;

  aluop_t   alu_op; //alu opcode typedef
  logic     neg, zero, over;
  word_t    port_a, port_b, port_o;


  // register file ports
  modport alu (
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
