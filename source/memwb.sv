/*
  Cameron McCutcheon    
  mccutchc@purdue.edu

  
*/
//`include "cpu_types_pkg.vh"
`include "pipeline_if.vh"

module memwb(
  input logic CLK, nRST,
  pipeline_if.MEMWB mwif
);

  always_ff @(posedge CLK, negedge nRST) begin: Reg_Logic
    if (~nRST) begin
      //WB Layer
      mwif.jal <= '0;
      mwif.RegDst <= '0;
      mwif.RegWr <= '0;
      mwif.MemtoReg <= '0;
      mwif.halt <= '0;

      //data signals
      mwif.NPC <= '0;
      mwif.Rd <= '0;
      mwif.Rt <= '0;
      mwif.port_o <= '0;
      mwif.LUI <= '0;
      mwif.dmemload <= '0; 
    end else if (mwif.ihit | mwif.dhit) begin
      //WB Layer
      mwif.jal <= mwif.jal_in;
      mwif.RegDst <= mwif.RegDst_in;
      mwif.RegWr <= mwif.RegWr_in;
      mwif.MemtoReg <= mwif.MemtoReg_in;
      mwif.halt <= mwif.halt_in;

      //data signals
      mwif.NPC <= mwif.NPC_in;
      mwif.Rd <= mwif.Rd_in;
      mwif.Rt <= mwif.Rt_in;
      mwif.port_o <= mwif.port_o_in;
      mwif.LUI <= mwif.LUI_in;
      mwif.dmemload <= mwif.dmemload_in;
    end else begin
      //WB Layer
      mwif.jal <= mwif.jal;
      mwif.RegDst <= mwif.RegDst;
      mwif.RegWr <= mwif.RegWr;
      mwif.MemtoReg <= mwif.MemtoReg;
      mwif.halt <= mwif.halt;

      //data signals
      mwif.NPC <= mwif.NPC;
      mwif.Rd <= mwif.Rd;
      mwif.Rt <= mwif.Rt;
      mwif.port_o <= mwif.port_o;
      mwif.LUI <= mwif.LUI;
      mwif.dmemload <= mwif.dmemload;
    end
  end

function void transfer(); //on clock edge, we can call the store method to grab these output
        //WB Layer
        mwif.jal = mwif.jal_in;
        mwif.RegDst = mwif.RegDst_in;
        mwif.RegWr = mwif.RegWr_in;
        mwif.MemtoReg = mwif.MemtoReg_in;
        mwif.halt = mwif.halt_in;

        //data signals
        mwif.NPC = mwif.NPC_in;
        mwif.Rd = mwif.Rd_in;
        mwif.Rt = mwif.Rt_in;
        mwif.port_o = mwif.port_o_in;
        //mwif.Imm_Ext = mwif.Imm_Ext_in;
        mwif.dmemload = mwif.dmemload_in;
endfunction

function void clear_to_nop();
        mwif.jal = 0;
        mwif.RegDst = 0;
        mwif.RegWr = 0;
        mwif.MemtoReg = 0;
        mwif.halt = 0;

        mwif.NPC = 0;
        mwif.Rd = 0;
        mwif.Rt = 0;
        mwif.port_o = 0;
        //mwif.Imm_Ext = 0;
        mwif.dmemload = 0;
endfunction

endmodule