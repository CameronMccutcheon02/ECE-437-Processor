//Cameron McCutcheon

//structs to make it easier to pass to pass things in and out of 

`include "cpu_types_pkg.vh"


//Each of these structs describe the modular output of a given stage
//Some control signals belong to the stage, but are passed as outputs 
//to be used in other modules on the same clock cycle
typedef struct {
    word_t  imemload; 
    word_t  NPC;
    logic   ihit;

}   fetch_t;


typedef struct {
    logic stall, flush, ihit;

    //Execute Layer
    aluop_t ALUctr;
    logic ALUSrc;
    
    //Mem Layer
    logic dREN;
    logic dWEN;
    logic BEQ;
    logic BNE;
    logic [1:0] JumpSel;
    word_t JumpAddr;

    //WB Layer
    logic RegWr;
    logic [1:0] MemtoReg;
    logic halt;
    logic [4:0] RW;
    word_t NPC;
    
    //data signals
    word_t port_a;
    word_t port_b;
    word_t Imm_Ext;
}   decode_t;


typedef struct {
    logic stall, flush, ihit, dhit;
    
    //Mem Layer
    logic dREN;
    logic dWEN;
    logic BEQ;
    logic BNE;
    logic alu_zero;
    logic [1:0] JumpSel;
    word_t JumpAddr;

    //WB Layer
    logic RegWr;
    logic [1:0] MemtoReg;
    logic halt;
    logic [4:0] RW;
    word_t NPC;

    //data signals
    word_t port_o;
    word_t port_b;
    word_t Imm_Ext;

}   execute_t;



typedef struct {
    logic stall, flush, ihit, dhit;

    //Mem Layer
    logic BEQ;
    logic BNE;
    logic alu_zero;
    logic [1:0] JumpSel;
    
    //WB Layer
    logic RegWr;
    logic [1:0] MemtoReg;
    logic halt;
    logic [4:0] RW;
    
    //data signals
    word_t port_o;
    word_t port_a;
    word_t dmemload;
    word_t Imm_Ext;
    word_t NPC;
    word_t JumpAddr;

}   memory_t;


typedef struct {

    //WB Layer
    logic RegWr;
    logic halt;
    logic [4:0] RW;
    word_t NPC;

    //data signals
    word_t port_w;

}   writeback;

