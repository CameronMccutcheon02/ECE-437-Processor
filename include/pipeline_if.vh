/*
Cameron McCutcheon

Control Unit IF
*/
`ifndef PL_IF_VH
`define PL_IF_VH

// all types
`include "cpu_types_pkg.vh"
`include "control_unit_if.vh"


interface pipeline_if
();
import cpu_types_pkg::*;

logic stall, flush;

//Control Signals
aluop_t ALUctr_in, ALUctr;
logic RegWr_in, RegWr;
logic ALUSrc_in, ALUSrc;
logic BEQ_in, BEQ;
logic BNE_in, BNE;
logic halt_in, halt;
logic dREN_in, dREN;
logic dWEN_in, dWEN;
logic [1:0] MemtoReg_in, MemtoReg;
logic [1:0] JumpSel_in, JumpSel;

logic [4:0] RW_in, RW;

//Word datas
word_t imemload_in, port_a_in, port_b_in, Imm_Ext_in, dmemstore_in, port_o_in, dmemload_in;
word_t imemload, port_a, port_b, Imm_Ext, dmemstore, port_o, dmemload;
word_t LUI_in, LUI;
word_t JumpAddr_in, JumpAddr;

//PC
word_t NPC_in, NPC;

logic ihit, dhit;

function void transfer(); //on clock edge, we can call the store method to grab these output
        imemload = imemload_in;
        port_a = port_a_in;
        port_b = port_b_in;
        Imm_Ext = Imm_Ext_in;
        dmemstore = dmemstore_in;
        port_o = port_o_in;
        dmemload = dmemload_in;
        NPC = NPC_in;

        ALUctr = ALUctr_in;
        RegWr = RegWr_in;
        ALUSrc = ALUSrc_in;
        BEQ = BEQ_in;
        BNE = BNE_in;
        halt = halt_in;
        dREN = dREN_in;
        dWEN = dWEN_in;
        MemtoReg = MemtoReg_in;
endfunction

function void clear_to_nop();
        imemload = 0;
        port_a = 0;
        port_b = 0;
        Imm_Ext = 0;
        dmemstore = 0;
        port_o = 0;
        dmemload = 0;
        NPC = 0;

        ALUctr = ALU_ADD;
        RegWr = 0;
        ALUSrc = 0;
        BEQ = 0;
        BNE = 0;
        halt = 0;
        dREN = 0;
        dWEN = 0;
        MemtoReg = 0;
endfunction

modport IFID (
        input stall, flush, ihit,
        input imemload_in,                      output imemload,
        input NPC_in,                           output NPC
);

modport IDEX (
        input stall, flush, ihit,

        //Execute Layer
        input ALUctr_in,                        output ALUctr,
        input ALUSrc_in,                        output ALUSrc,
        input BEQ_in,                           output BEQ,
        input BNE_in,                           output BNE,
        input JumpSel_in,                       output JumpSel,
        input JumpAddr_in,                      output JumpAddr,

        //Mem Layer
        input dREN_in,                          output dREN,
        input dWEN_in,                          output dWEN,

        //WB Layer
        input RegWr_in,                         output RegWr,
        input MemtoReg_in,                      output MemtoReg,
        input halt_in,                          output halt,
        
        //data signals
        input NPC_in,                           output NPC,
        input RW_in,                            output RW,
        input port_a_in,                        output port_a,
        input port_b_in,                        output port_b,
        input Imm_Ext_in,                       output Imm_Ext
);

modport EXMEM (
        input stall, flush, ihit, dhit,

        //Mem Layer
        input dREN_in,                          output dREN,
        input dWEN_in,                          output dWEN,

        //WB Layer
        input RegWr_in,                         output RegWr,
        input MemtoReg_in,                      output MemtoReg,
        input halt_in,                          output halt,

        //data signals
        input NPC_in,                           output NPC,
        input RW_in,                            output RW,
        input port_o_in,                        output port_o,
        input LUI_in,                           output LUI,
        input dmemstore_in,                     output dmemstore
);


modport MEMWB (
        input stall, flush, ihit, dhit,

        //WB Layer
        input RegWr_in,                         output RegWr,
        input MemtoReg_in,                      output MemtoReg,
        input halt_in,                          output halt,

        //data signals
        input NPC_in,                           output NPC,
        input RW_in,                            output RW,
        input port_o_in,                        output port_o,
        input LUI_in,                           output LUI,
        input dmemload_in,                      output dmemload
);

endinterface


`endif

