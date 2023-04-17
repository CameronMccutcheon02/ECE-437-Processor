//Cameron McCutcheon

//structs to make it easier to pass to pass things in and out of 

`ifndef CTP_IF_VH
`define CTP_IF_VH

`include "cpu_types_pkg.vh"


package custom_types_pkg;
    import cpu_types_pkg::*;

    parameter CACHE_W = 2;

    //Each of these structs describe the modular output of a given stage
    //Some control signals belong to the stage, but are passed as outputs 
    //to be used in other modules on the same clock cycle
    typedef struct packed{
        word_t  imemload; 
        word_t  NPC;
        word_t  PC;
        logic   branch_taken;
        word_t  pred_branch_addr;
    }   fetch_t;

    typedef struct packed{
        // hazard unit/Forwarding
        regbits_t Rt;
        regbits_t Rd;
        regbits_t Rs;

        //Execute Layer
        aluop_t ALUctr;
        logic ALUSrc;
        
        //Mem Layer
        logic  dREN;
        logic  dWEN;
        logic  BEQ;
        logic  BNE;
        logic  [1:0] JumpSel;
        word_t JumpAddr;
        word_t Instruction;
        logic  branch_taken;
        word_t PC;
        word_t pred_branch_addr;
        logic  atomic;

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
        // hazard unit/Forwarding
         
        //Mem Layer
        logic   dREN;
        logic   dWEN;
        logic   BEQ;
        logic   BNE;
        logic   zero;
        logic   [1:0] JumpSel;
        word_t  JumpAddr;
        word_t  Instruction;
        logic   branch_taken;
        word_t  PC;
        word_t  BranchAddr;
        word_t  pred_branch_addr;
        logic   emergency_flush;
        logic   atomic;

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
        // hazard unit/Forwarding

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
        // hazard unit/Forwarding

        //WB Layer
        logic RegWEN;
        logic halt;
        regbits_t Rw;

        //data signals
        word_t port_w;

    }   writeback_t;

    typedef enum logic [3:0] { 
        LAZY, 
        WB1, 
        WB2, 
        R1M, 
        R2M,

        FLCTR, 
        FL1, 
        FL2,

        CNTW, 
        STOP 
    } dcache_t;

    typedef struct packed {
        word_t addr;
        logic valid;
    } lr_t;

    typedef struct packed {
        logic [CACHE_W-1:0] iREN;
        logic [CACHE_W-1:0] dREN;
        logic [CACHE_W-1:0] dWEN;
        word_t [CACHE_W-1:0] dstore;
        word_t [CACHE_W-1:0] iaddr;
        word_t [CACHE_W-1:0] daddr;
        word_t ramload;
        ramstate_t ramstate;
        logic [CACHE_W-1:0] ccwrite;
        logic [CACHE_W-1:0] cctrans; 
        logic [CACHE_W-2:0] arb;
        logic [1:0] delay;
    } mc_t;

    typedef enum logic [3:0] {
        IDLE,
        PRRD,
        BUSRD1,
        BUSRD2,
        BUSWB1,
        BUSWB2,

        PRWR,
        BUSRDX1,
        BUSRDX2,
        BUSWBX1,
        BUSWBX2,

        IMEM,
        CACWB
    } memory_control_t;

endpackage
`endif

