  /*
    Cameron McCutcheon
    mccutchc@purde.edu

    datapath contains register file, control, hazard,
    muxes, and glue logic for processor
  */

`include "fetch_if.vh"
`include "decode_if.vh"
`include "execute_if.vh"
`include "memory_if.vh"
`include "writeback_if.vh"

`include "cpu_types_pkg.vh"
`include "custom_types_pkg.vh"

module datapath (
	input logic CLK, nRST,
	datapath_cache_if.dp dpif
);
    // import types
    import cpu_types_pkg::*;
    import custom_types_pkg::*;

    // pc init
    parameter PC_INIT = 0;

//Local Declarations
  //*******************************************\\
	// interfaces
	fetch_if ftif();
	decode_if dcif();
	execute_if exif();
	memory_if mmif();
	writeback_if wbif();

	// DUT
	fetch_stage FT(CLK, nRST, ftif);
	decode_stage DC(CLK, nRST, dcif);
	execute_stage EX(CLK, nRST, exif);
	memory_stage MM(CLK, nRST, mmif);
	writeback_stage WB(wbif);

  //*******************************************\\
//

//Datapath-Cache Routings
  //*******************************************\\
	always_comb begin: Datapath_Logic
		// instruction memory
		dpif.imemREN = ftif.fetch_p.imemREN;
		dpif.imemaddr = ftif.fetch_p.imemaddr;
		ftif.imemload = dpif.imemload;

		// data memory
		dpif.dmemREN = mmif.memory_p.dREN;
		dpif.dmemWEN = mmif.memory_p.dWEN;
		dpif.dmemstore = mmif.memory_p.dmemstore;
		dpif.dmemaddr = mmif.memory_p.dmemaddr;
		mmif.dmemload = dpif.dmemload;
	end

	always_ff @(posedge CLK, negedge nRST) begin: Datapath_Reg_Logic
		if (~nRST)
			dpif.halt <= 1'b0;
		else if (mmif.memory_p.halt)
			dpif.halt <= mmif.memory_p.halt;
		else
			dpif.halt <= 1'b0;
	end
  //*******************************************\\
//


// TODO: CONNECT THE MODULARIZED STAGES TOGETHER BELOW


// EVERYTHING BELOW CAN BE DELETED ONCE REWRITTEN (can just stay for reference)
//Instruction Fetch/Decode Latch Connections
  always_comb begin: IFID_Logic
    // Datapath Signals
    fdif.ihit = dpif.ihit;

    // Decode Signals
    fdif.imemload_in = dpif.imemload;
    
    // Writeback Signals
    fdif.NPC_in = npc;
  end

//Instruction Decode/Execute Latch Connections
  always_comb begin: IDEX_Logic
    // Datapath Signals
    deif.ihit = dpif.ihit;
    deif.JumpSel_in = cuif.JumpSel;

    // Execute Signals
    deif.ALUctr_in = cuif.ALUctr;
    deif.ALUSrc_in = cuif.ALUSrc;
    deif.BEQ_in = cuif.BEQ;
    deif.BNE_in = cuif.BNE;
    deif.JumpAddr_in = {fdif.NPC[31:28], Instruction[25:0], 2'b00};

    // Mem Signals
    deif.dREN_in = cuif.dREN;
    deif.dWEN_in = cuif.dWEN;

    // Writeback Signals
    deif.RW_in = (cuif.jal) ? 5'd31 : (cuif.RegDst) ? rd : rt;
    deif.RegWr_in = cuif.RegWr;
    deif.MemtoReg_in = cuif.MemtoReg;
    deif.halt_in = cuif.halt;

    // Writeback Signals (Passthrough)
    deif.NPC_in = fdif.NPC;

    // Data Signals
    deif.port_a_in = rfif.rdat1;
    deif.port_b_in = rfif.rdat2;
    deif.Imm_Ext_in = Imm_Ext;
  end

// Execute/Memory Latch Connections
  always_comb begin: EXMEM_Logic
    // Datapath Signals
    emif.ihit = dpif.ihit;
    emif.dhit = dpif.dhit;

    // Mem Signals (Passthrough)
    emif.dREN_in = deif.dREN;
    emif.dWEN_in = deif.dWEN;

    // Writeback Signals (Passthrough)
    emif.NPC_in = deif.NPC;
    emif.RegWr_in = deif.RegWr;
    emif.MemtoReg_in = deif.MemtoReg;
    emif.halt_in = deif.halt;

    // Data Signals
    emif.port_o_in = aluif.oport;
    emif.LUI_in = {deif.Imm_Ext, 16'b0};

    // Data Signals (Passthrough)
    emif.RW_in = deif.RW;
    emif.dmemstore_in = deif.port_b;
  end

// Memory/Writeback Latch Connections
  always_comb begin: MEMWB_Logic
    // Datapath Signals
    mwif.ihit = dpif.ihit;
    mwif.dhit = dpif.dhit;

    // Writeback Signals (Passthrough)
    mwif.NPC_in = emif.NPC;
    mwif.RegWr_in = emif.RegWr;
    mwif.MemtoReg_in = emif.MemtoReg;
    mwif.halt_in = emif.halt;

    // Data Signals (Passthrough)
    mwif.RW_in = emif.RW;
    mwif.port_o_in = emif.port_o;
    mwif.LUI_in = emif.LUI;

    // Data Signals
    mwif.dmemload_in = dpif.dmemload;
  end

endmodule
