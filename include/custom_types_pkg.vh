//Cameron McCutcheon

//structs to make it easier to pass to pass things in and out of 

`ifndef CTP_IF_VH
`define CTP_IF_VH

`include "cpu_types_pkg.vh"


package custom_types_pkg;
    import cpu_types_pkg::*;
    //Each of these structs describe the modular output of a given stage
    //Some control signals belong to the stage, but are passed as outputs 
    //to be used in other modules on the same clock cycle
    typedef struct packed{
        word_t  imemload; 
        word_t  NPC;

    }   fetch_t;

    typedef struct packed{
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
        regbits_t Rw;
        logic RegWEN;
        logic [1:0] MemtoReg;
        logic halt;
        word_t NPC;
        
        //data signals
        word_t port_a;
        word_t port_b;
        word_t Imm_Ext;
    }   decode_t;


    typedef struct packed {    
        //Mem Layer
        logic dREN;
        logic dWEN;
        logic BEQ;
        logic BNE;
        logic zero;
        logic [1:0] JumpSel;
        word_t JumpAddr;

        //WB Layer
        regbits_t Rw;
        logic RegWEN;
        logic [1:0] MemtoReg;
        logic halt;
        word_t NPC;

        //data signals
        word_t port_o;
        word_t port_a;
        word_t port_b;
        word_t Imm_Ext;

    }   execute_t;



    typedef struct packed{    
        //WB Layer
        regbits_t Rw;
        logic RegWEN;
        logic [1:0] MemtoReg;
        logic halt;
        word_t NPC;
        
        //data signals
        word_t port_o;
        word_t dmemload;
        word_t Imm_Ext;

    }   memory_t;


    typedef struct packed{
        //WB Layer
        logic RegWEN;
        logic halt;
        regbits_t Rw;

        //data signals
        word_t port_w;

    }   writeback_t;

endpackage
`endif

