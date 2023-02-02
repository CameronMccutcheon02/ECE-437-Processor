/*
  Cameron McCutcheon

  control unit decode block
*/
`include "cpu_types_pkg.vh"
`include "control_unit_if.vh"
import cpu_types_pkg::*;

module control_unit(
    control_unit_if.CU cuif

);

//ALU_op decode
always_comb begin
  cuif.alu_op = ALU_ADD; //Default to ADD
  cuif.halt = 0;
  case(cuif.instr_op)
    RTYPE: begin
        case(cuif.funct_op)
          SLLV:   cuif.alu_op = ALU_SLL;
          SRLV:   cuif.alu_op = ALU_SRL;
          JR:     cuif.alu_op = ALU_ADD; //Maybe something else here?
          ADD:    cuif.alu_op = ALU_ADD;
          ADDU:   cuif.alu_op = ALU_ADD;
          SUB:    cuif.alu_op = ALU_SUB;
          SUBU:   cuif.alu_op = ALU_SUB;
          AND:    cuif.alu_op = ALU_AND;
          OR:     cuif.alu_op = ALU_OR;
          XOR:    cuif.alu_op = ALU_XOR;
          NOR:    cuif.alu_op = ALU_NOR;
          SLT:    cuif.alu_op = ALU_SLT;
          SLTU:   cuif.alu_op = ALU_SLTU;
        endcase
    end

    // J: //Nothing here 
    // JAL:  //Nothing here

    BEQ:    cuif.alu_op = ALU_SUB;
    BNE:    cuif.alu_op = ALU_SUB;
    ADDI:   cuif.alu_op = ALU_ADD;
    ADDIU:  cuif.alu_op = ALU_ADD;
    SLTI:   cuif.alu_op = ALU_SLT;
    SLTIU:  cuif.alu_op = ALU_SLTU;
    ANDI:   cuif.alu_op = ALU_AND;
    ORI:    cuif.alu_op = ALU_OR;
    XORI:   cuif.alu_op = ALU_XOR;
    LUI:    cuif.alu_op = ALU_OR; //Another mode on the extender to zero from the bottom
    LW:     cuif.alu_op = ALU_ADD;
    LBU:    cuif.alu_op = ALU_ADD;
    LHU:    cuif.alu_op = ALU_ADD;
    SB:     cuif.alu_op = ALU_ADD;
    SH:     cuif.alu_op = ALU_ADD;
    SW:     cuif.alu_op = ALU_ADD;
    LL:     cuif.alu_op = ALU_ADD;
    SC:     cuif.alu_op = ALU_ADD;
    HALT:   cuif.halt = 1;

  endcase
end

//Control Unit Decode
always_comb begin
  //Set Defaults
  cuif.RegDst     = 0; 
  cuif.ALUSRC     = 0;
  cuif.Jump       = 0; 
  cuif.Branch     = 0; 
  cuif.MemRead    = 0;
  cuif.MemToReg   = 0;
  cuif.MemWrite   = 0; 
  cuif.RegWrite   = 0;
  cuif.ExtType    = 0;
  cuif.JAL        = 0;

  if (1) begin
    cuif.RegDst = (cuif.instr_op == RTYPE) ? 1 : 0; //1 if we are using Rd for rtype

    cuif.ALUSRC = (cuif.instr_op == RTYPE) ||
                  (cuif.instr_op == J) ||
                  (cuif.instr_op == JAL) ||
                  (cuif.instr_op == BEQ) ||
                  (cuif.instr_op == BNE) ||
                  (cuif.instr_op == HALT) ? 0 : 1; //ALUSRC is 0 when we use register file output

    cuif.JAL = (cuif.instr_op == JAL) ? 1 : 0;

    cuif.Jump = (cuif.instr_op == J) || (cuif.instr_op == JAL) ? 2'b01 : //Normal jump for these two
                  (cuif.instr_op == RTYPE && cuif.funct_op == JR) ? 2'b10 : 2'b00; //Irregular jump and no jump

    cuif.Branch = (cuif.instr_op == BEQ) || (cuif.instr_op == BNE) ? 1 : 0;

    cuif.MemRead = (cuif.instr_op == LW) || 
                    (cuif.instr_op == LBU) || 
                    (cuif.instr_op == LHU) || 
                    (cuif.instr_op == LL) ? 1 : 0;

    cuif.MemWrite = (cuif.instr_op == SW) || 
                    (cuif.instr_op == SB) || 
                    (cuif.instr_op == SH) || 
                    (cuif.instr_op == SC) ? 1 : 0;

    cuif.MemToReg = (cuif.instr_op == LW) || (cuif.instr_op == LBU) || (cuif.instr_op == LHU) || (cuif.instr_op == LL) ? 2'b00 : //if load, use dmem
                    (cuif.instr_op == JAL) ? 2'b10 //if it is a jump, use PC + 4
                    : 2'b01; //Otherwise just grab ALU output

    cuif.RegWrite = (cuif.instr_op == RTYPE && cuif.funct_op == JR) ||  //on a jump to reg, don't write to the reg file
                    (cuif.instr_op == J) || //on a jump, no write
                    (cuif.MemWrite) || //if we are doing a store, no write
                    (cuif.Branch)  ? 0 : 1; //if we are branching, no write

    cuif.ExtType = (cuif.instr_op == LUI) ? 2'b10 : //zero fill bottom
                    (cuif.instr_op == ANDI) || (cuif.instr_op == ORI) || (cuif.instr_op == XORI) ? 2'b00 : 2'b01;
                    
                  // (cuif.MemRead) || (cuif.MemWrite) ? 2'b01 : //if it is a store/load sign extend
                    //(cuif.Branch) ? 2'b01 : //on branch we sign extend
                    //(cuif.instr_op == ADDI) ? 2'b            
  end  
end

endmodule