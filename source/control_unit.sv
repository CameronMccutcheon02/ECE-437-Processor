`include "control_unit_if.vh"
`include "cpu_types_pkg.vh"

module control_unit (
    control_unit_if.cu cuif
);

    import cpu_types_pkg::*;

    always_comb begin: CONTROL_LOGIC
        cuif.JumpSel = 2'b0;
        cuif.jal = 1'b0;
        cuif.RegDst = 1'b0;
        cuif.RegWr = 1'b0;
        cuif.ALUSrc = 1'b0;
        cuif.ALUctr = ALU_ADD;
        cuif.MemtoReg = 2'b0;
        cuif.ExtOP = 1'b1; // 0 = zero 1 = signed
        cuif.halt = 1'b0;
        cuif.iREN = 1'b1;
        cuif.dREN = 1'b0;
        cuif.dWEN = 1'b0;
        cuif.BEQ = 1'b0;
        cuif.BNE = 1'b0;
        case (cuif.opcode)
            // rtype
            RTYPE: begin
                cuif.RegDst = 1'b1;
                case (cuif.func)
                    ADDU: cuif.RegWr = 1'b1;
                    ADD: cuif.RegWr = 1'b1;
                    AND: begin 
                        cuif.RegWr = 1'b1;
                        cuif.ALUctr = ALU_AND;
                    end
                    JR: cuif.JumpSel = 2'd2;
                    NOR: begin 
                        cuif.RegWr = 1'b1;
                        cuif.ALUctr = ALU_NOR;
                    end
                    OR: begin
                        cuif.RegWr = 1'b1;
                        cuif.ALUctr = ALU_OR;
                        cuif.ExtOP = 1'b0;
                    end
                    SLT: begin 
                        cuif.RegWr = 1'b1;
                        cuif.ALUctr = ALU_SLT;
                    end
                    SLTU: begin
                        cuif.RegWr = 1'b1;
                        cuif.ALUctr = ALU_SLTU;
                    end
                    SLLV: begin
                        cuif.RegWr = 1'b1;
                        cuif.ALUctr = ALU_SLL;
                    end
                    SRLV: begin
                        cuif.RegWr = 1'b1;
                        cuif.ALUctr = ALU_SRL;
                    end
                    SUBU: begin
                        cuif.RegWr = 1'b1;
                        cuif.ALUctr = ALU_SUB;
                    end
                    SUB: begin
                        cuif.RegWr = 1'b1;
                        cuif.ALUctr = ALU_SUB;
                    end
                    XOR: begin
                        cuif.RegWr = 1'b1;
                        cuif.ALUctr = ALU_XOR;
                    end
                endcase
            end

            // itype
            ADDIU: begin
                cuif.RegWr = 1'b1;
                cuif.ALUSrc = 1'b1;
            end
            ADDI: begin
                cuif.RegWr = 1'b1;
                cuif.ALUSrc = 1'b1;
            end
            ANDI: begin
                cuif.RegWr = 1'b1;
                cuif.ALUSrc = 1'b1;
                cuif.ALUctr = ALU_AND;
            end
            BEQ: begin
                cuif.ALUctr = ALU_SUB;
                cuif.BEQ = 1'b1;
            end
            BNE: begin
                cuif.ALUctr = ALU_SUB;
                cuif.BNE = 1'b1;
            end
            LUI: begin
                cuif.RegWr = 1'b1;
                cuif.ALUSrc = 1'b1;
                cuif.MemtoReg = 2'd3;
            end
            LW: begin
                cuif.RegWr = 1'b1;
                cuif.dREN = 1'b1;
                cuif.ALUSrc = 1'b1;
                cuif.MemtoReg = 2'd2;
            end
            ORI: begin
                cuif.RegWr = 1'b1;
                cuif.ALUSrc = 1'b1;
                cuif.ALUctr = ALU_OR;
                cuif.ExtOP = 1'b0;
            end
            SLTI: begin
                cuif.RegWr = 1'b1;
                cuif.ALUSrc = 1'b1;
                cuif.ALUctr = ALU_SLT;
            end
            SLTIU: begin
                cuif.RegWr = 1'b1;
                cuif.ALUSrc = 1'b1;
                cuif.ALUctr = ALU_SLTU;
            end
            SW: begin
                cuif.dWEN = 1'b1;
                cuif.ALUSrc = 1'b1;
            end           
            XORI: begin
                cuif.RegWr = 1'b1;
                cuif.ALUSrc = 1'b1;
                cuif.ALUctr = ALU_XOR;
                cuif.ExtOP = 1'b0;
            end

            // jtype
            J: cuif.JumpSel = 2'd1;
            JAL: begin
                cuif.RegWr = 1'b1;
                cuif.JumpSel = 2'd1;
                cuif.MemtoReg = 2'd1;
                cuif.jal = 1'b1;
            end

            // other
            HALT: cuif.halt = 1'b1;
        endcase

    end

endmodule