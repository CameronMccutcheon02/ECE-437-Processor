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


        //Control Signals
        aluop_t ALUctr_in, ALUctr;
        logic jal_in, jal;
        logic RegDst_in, RegDst;
        logic RegWr_in, RegWr;
        logic ALUSrc_in, ALUSrc;
        logic BEQ_in, BEQ;
        logic BNE_in, BNE;
        logic halt_in, halt;
        logic dREN_in, dREN;
        logic dWEN_in, dWEN;
        logic [1:0] MemtoReg_in, MemtoReg;

        logic [4:0] Rd_in, Rd;
        logic [4:0] Rs_in, Rs;

        //Word datas
        word_t imemload_in, port_a_in, port_b_in, Imm_Ext_in, dmemstore_in, port_o_in, dmemload_in;
        word_t imemload, port_a, port_b, Imm_Ext, dmemstore, port_o, dmemload;

        //PC
        word_t NPC_in, NPC;
        


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
                jal = jal_in;
                RegDst = RegDst_in;
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
                jal = 0;
                RegDst = 0;
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
                input   imemload_in,
                output imemload;

        );

        modport IDEX (
                //Execute Layer
                input ALUctr_in;                        output ALUctr;
                input ALUSrc_in;                        output ALUSrc;
                input BEQ_in;                           output BEQ;
                input BNE_in;                           output BNE;

                //Mem Layer
                input dREN_in;                          output dREN;
                input dWEN_in;                          output dWEN;

                //WB Layer
                input jal_in;                           output jal;
                input RegDst_in;                        output RegDst;
                input RegWr_in;                         output RegWr;
                input MemtoReg_in;                      output MemtoReg;
                input halt_in;                          output halt;
                
                //data signals
                input Rd_in;                            output Rd;
                input Rs_in;                            output Rs;
                input NPC_in;                           output NPC;
                input port_a_in;                        output port_a;
                input port_b_in;                        output port_b;
                input Imm_Ext_in;                       output Imm_Ext;
                input dmemstore_in;                     output dmemstore;

        );

        modport EXMEM (
                //Mem Layer
                input dREN_in;                          output dREN;
                input dWEN_in;                          output dWEN;

                //WB Layer
                input jal_in;                           output jal;
                input RegDst_in;                        output RegDst;
                input RegWr_in;                         output RegWr;
                input MemtoReg_in;                      output MemtoReg;
                input halt_in;                          output halt;

                //data signals
                input NPC_in;                           output NPC;
                input Rd_in;                            output Rd;
                input Rs_in;                            output Rs;
                input port_o_in;                        output port_o;
                input Imm_Ext_in;                       output Imm_Ext;
                input dmemstore_in;                     output dmemstore;
        );


        modport MEMWB (

                //WB Layer
                input jal_in;                           output jal;
                input RegDst_in;                        output RegDst;
                input RegWr_in;                         output RegWr;
                input MemtoReg_in;                      output MemtoReg;
                input halt_in;                          output halt;

                //data signals
                input NPC_in;                           output NPC;
                input Rd_in;                            output Rd;
                input Rs_in;                            output Rs;
                input port_o_in;                        output port_o;
                input Imm_Ext_in;                       output Imm_Ext;
                input dmemload_in;                      output dmemload;
        );

        endinterface


        `endif

