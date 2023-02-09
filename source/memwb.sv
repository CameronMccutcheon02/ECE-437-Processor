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
      mwif.RegWr <= '0;
      mwif.MemtoReg <= '0;
      mwif.halt <= '0;

      //data signals
      mwif.NPC <= '0;
      mwif.RW <= '0;
      mwif.port_o <= '0;
      mwif.LUI <= '0;
      mwif.dmemload <= '0; 
    end else if (mwif.ihit | mwif.dhit) begin
      //WB Layer
      mwif.RegWr <= mwif.RegWr_in;
      mwif.MemtoReg <= mwif.MemtoReg_in;
      mwif.halt <= mwif.halt_in;

      //data signals
      mwif.NPC <= mwif.NPC_in;
      mwif.RW <= mwif.RW_in;
      mwif.port_o <= mwif.port_o_in;
      mwif.LUI <= mwif.LUI_in;
      mwif.dmemload <= mwif.dmemload_in;
    end else begin
      //WB Layer
      mwif.RegWr <= mwif.RegWr;
      mwif.MemtoReg <= mwif.MemtoReg;
      mwif.halt <= mwif.halt;

      //data signals
      mwif.NPC <= mwif.NPC;
      mwif.RW <= mwif.RW;
      mwif.port_o <= mwif.port_o;
      mwif.LUI <= mwif.LUI;
      mwif.dmemload <= mwif.dmemload;
    end
  end

function void transfer(); //on clock edge, we can call the store method to grab these output
        //WB Layer
        mwif.RegWr = mwif.RegWr_in;
        mwif.MemtoReg = mwif.MemtoReg_in;
        mwif.halt = mwif.halt_in;

        //data signals
        mwif.NPC = mwif.NPC_in;
        mwif.RW = mwif.RW_in;
        mwif.port_o = mwif.port_o_in;
        //mwif.Imm_Ext = mwif.Imm_Ext_in;
        mwif.dmemload = mwif.dmemload_in;
endfunction

function void clear_to_nop();
        mwif.RegWr = 0;
        mwif.MemtoReg = 0;
        mwif.halt = 0;

        mwif.NPC = 0;
        mwif.RW = 0;
        mwif.port_o = 0;
        //mwif.Imm_Ext = 0;
        mwif.dmemload = 0;
endfunction

endmodule