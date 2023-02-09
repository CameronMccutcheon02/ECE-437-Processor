/*
  Cameron McCutcheon    
  mccutchc@purdue.edu

  
*/
//`include "cpu_types_pkg.vh"
`include "pipeline_if.vh"

module exmem(
  input logic CLK, nRST,
  pipeline_if.EXMEM emif
);

  always_ff @(posedge CLK, negedge nRST) begin: Reg_Logic
    if (~nRST | emif.flush | emif.dhit) begin
      //mem layer
      emif.dREN <= '0;
      emif.dWEN <= '0;

      //wb layer
      emif.jal <= '0;
      emif.RegDst <= '0;
      emif.RegWr <= '0;
      emif.MemtoReg <= '0;
      emif.halt <= '0;

      //datas
      emif.NPC <= '0;
      emif.Rd <= '0;
      emif.Rt <= '0;
      emif.port_o <= '0;
      emif.LUI <= '0;
      emif.dmemstore <= '0;
    end else if (emif.ihit & ~emif.dhit) begin
      //mem layer
      emif.dREN <= emif.dREN_in;
      emif.dWEN <= emif.dWEN_in;

      //wb layer
      emif.jal <= emif.jal_in;
      emif.RegDst <= emif.RegDst_in;
      emif.RegWr <= emif.RegWr_in;
      emif.MemtoReg <= emif.MemtoReg_in;
      emif.halt <= emif.halt_in;

      //datas
      emif.NPC <= emif.NPC_in;
      emif.Rd <= emif.Rd_in;
      emif.Rt <= emif.Rt_in;
      emif.port_o <= emif.port_o_in;
      emif.LUI <= emif.LUI_in;
      emif.dmemstore <= emif.dmemstore_in;
    end else begin
      //mem layer
      emif.dREN <= emif.dREN;
      emif.dWEN <= emif.dWEN;

      //wb layer
      emif.jal <= emif.jal;
      emif.RegDst <= emif.RegDst;
      emif.RegWr <= emif.RegWr;
      emif.MemtoReg <= emif.MemtoReg;
      emif.halt <= emif.halt;

      //datas
      emif.NPC <= emif.NPC;
      emif.Rd <= emif.Rd;
      emif.Rt <= emif.Rt;
      emif.port_o <= emif.port_o;
      emif.LUI <= emif.LUI;
      emif.dmemstore <= emif.dmemstore;
    end

  end

function void transfer(); //on clock edge, we can call the store method to grab these output
        //mem layer
        emif.dREN = emif.dREN_in;
        emif.dWEN = emif.dWEN_in;

        //wb layer
        emif.jal = emif.jal_in;
        emif.RegDst = emif.RegDst_in;
        emif.RegWr = emif.RegWr_in;
        emif.MemtoReg = emif.MemtoReg_in;
        emif.halt = emif.halt_in;

        //datas
        emif.NPC = emif.NPC_in;
        emif.Rd = emif.Rd_in;
        emif.Rt = emif.Rt_in;
        emif.port_o = emif.port_o_in;
        //emif.Imm_Ext = emif.Imm_Ext_in;
        emif.dmemstore = emif.dmemstore_in;
endfunction

function void clear_to_nop();
        emif.dREN = 0;
        emif.dWEN = 0;

        emif.jal = 0;
        emif.RegDst = 0;
        emif.RegWr = 0;
        emif.MemtoReg = 0;
        emif.halt = 0;

        emif.NPC = 0;
        emif.Rd = 0;
        emif.Rt = 0;
        emif.port_o = 0;
        //emif.Imm_Ext = 0;
        emif.dmemstore = 0;
endfunction

endmodule