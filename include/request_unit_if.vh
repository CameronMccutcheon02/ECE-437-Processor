/*
  Cameron McCutcheon

  Control Unit IF
*/
`ifndef RU_IF_VH
`define RU_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface request_unit_if;
    // import types
    import cpu_types_pkg::*;
    
    //Datapath side signals 
    //inputs
    logic       MemRead, MemWrite, stall;

    //outputs
    opcode_t    instr_op;
    funct_t     funct_op;

    //Cache side signals
    // datapath signals
    // stop processing
    logic               halt;

    // Icache signals
    // hit and enable
    logic               ihit, imemREN;
    // instruction addr
    word_t             imemload, imemaddr, pc, imem;

    // Dcache signals
    // hit, atomic and enables
    logic               dhit, datomic, dmemREN, dmemWEN, flushed;
    // data and address
    word_t              dmemload, dmemstore, dmemaddr, port_o, port_b, dmem;


    // register file ports
    modport RU (
        //Cache side inputs
        input   imemload, dmemload, //data inputs
        input   ihit, dhit, 

        //Datapath side inputs
        input   MemRead, MemWrite, port_o, pc, port_b,

        //Cache side
        output  dmemstore, //Data output
        output  dmemREN, imemREN, dmemWEN, halt, datomic,


        //Datapath side outputs
        output  imemaddr, dmemaddr, //Data outputs
        output  instr_op, funct_op, stall, dmem, imem
        
    );
endinterface

`endif //REGISTER_FILE_IF_VH
