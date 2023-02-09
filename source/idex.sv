/*
  Cameron McCutcheon    
  mccutchc@purdue.edu

  
*/
//`include "cpu_types_pkg.vh"
`include "pipeline_if.vh"
`include "cpu_types_pkg.vh"

module idex(
  input logic CLK, nRST,
  pipeline_if.IDEX deif
);

  import cpu_types_pkg::*;

  always_ff @(posedge CLK, negedge nRST) begin: Reg_Logic
    if (~nRST | (deif.flush & deif.ihit)) begin
      //Execute Layer
      deif.ALUctr <= ALU_ADD;
      deif.ALUSrc <= '0;
      deif.BEQ <= '0;
      deif.BNE <= '0;
      deif.JumpSel <= '0;
      deif.JumpAddr <= '0;

      //Mem Layer
      deif.dREN <= '0;
      deif.dWEN <= '0;

      //WB Layer
      deif.jal <= '0;
      deif.RegDst <= '0;
      deif.RegWr <= '0;
      deif.MemtoReg <= '0;
      deif.halt <= '0;

      //Data Signals
      deif.NPC <= '0;
      deif.Rd <= '0;
      deif.Rt <= '0;
      deif.port_a <= '0;
      deif.port_b <= '0;
      deif.Imm_Ext <= '0;
    end else if (~deif.stall & deif.ihit) begin
      //Execute Layer
      deif.ALUctr <= deif.ALUctr_in;
      deif.ALUSrc <= deif.ALUSrc_in;
      deif.BEQ <= deif.BEQ_in;
      deif.BNE <= deif.BNE_in;
      deif.JumpSel <= deif.JumpSel_in;
      deif.JumpAddr <= deif.JumpAddr_in;

      //Mem Layer
      deif.dREN <= deif.dREN_in;
      deif.dWEN <= deif.dWEN_in;

      //WB Layer
      deif.jal <= deif.jal_in;
      deif.RegDst <= deif.RegDst_in;
      deif.RegWr <= deif.RegWr_in;
      deif.MemtoReg <= deif.MemtoReg_in;
      deif.halt <= deif.halt_in;

      //Data Signals
      deif.NPC <= deif.NPC_in;
      deif.Rd <= deif.Rd_in;
      deif.Rt <= deif.Rt_in;
      deif.port_a <= deif.port_a_in;
      deif.port_b <= deif.port_b_in;
      deif.Imm_Ext <= deif.Imm_Ext_in;
    end else begin
      //Execute Layer
      deif.ALUctr <= deif.ALUctr;
      deif.ALUSrc <= deif.ALUSrc;
      deif.BEQ <= deif.BEQ;
      deif.BNE <= deif.BNE;
      deif.JumpSel <= deif.JumpSel;
      deif.JumpAddr <= deif.JumpAddr;

      //Mem Layer
      deif.dREN <= deif.dREN;
      deif.dWEN <= deif.dWEN;

      //WB Layer
      deif.jal <= deif.jal;
      deif.RegDst <= deif.RegDst;
      deif.RegWr <= deif.RegWr;
      deif.MemtoReg <= deif.MemtoReg;
      deif.halt <= deif.halt;

      //Data Signals
      deif.NPC <= deif.NPC;
      deif.Rd <= deif.Rd;
      deif.Rt <= deif.Rt;
      deif.port_a <= deif.port_a;
      deif.port_b <= deif.port_b;
      deif.Imm_Ext <= deif.Imm_Ext;
    end
  end

function void transfer(); //on clock edge, we can call the store method to grab these output
        //Execute Layer
        deif.ALUctr = deif.ALUctr_in;
        deif.ALUSrc = deif.ALUSrc_in;
        deif.BEQ = deif.BEQ_in;
        deif.BNE = deif.BNE_in;

        //Mem Layer
        deif.dREN = deif.dREN_in;
        deif.dWEN = deif.dWEN_in;

        //WB Layer
        deif.jal = deif.jal_in;
        deif.RegDst = deif.RegDst_in;
        deif.RegWr = deif.RegWr_in;
        deif.MemtoReg = deif.MemtoReg_in;
        deif.halt = deif.halt_in;

        //Data Signals
        deif.Rd = deif.Rd_in;
        deif.Rt = deif.Rt_in;
        deif.NPC = deif.NPC_in;
        deif.port_a = deif.port_a_in;
        deif.port_b = deif.port_b_in;
        deif.Imm_Ext = deif.Imm_Ext_in;
endfunction

function void clear_to_nop();
        //Execute Layer
        //deif.ALUctr = 0;
        deif.ALUSrc = 0;
        deif.BEQ = 0;
        deif.BNE = 0;

        //Mem Layer
        deif.dREN = 0;
        deif.dWEN = 0;

        //WB Layer
        deif.jal = 0;
        deif.RegDst = 0;
        deif.RegWr = 0;
        deif.MemtoReg = 0;
        deif.halt = 0;

        //Data Signals
        deif.Rd = 0;
        deif.Rt = 0;
        deif.NPC = 0;
        deif.port_a = 0;
        deif.port_b = 0;
        deif.Imm_Ext = 0;
endfunction

endmodule