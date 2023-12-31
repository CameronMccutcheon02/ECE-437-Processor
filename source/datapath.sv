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
`include "a_writeback_if.vh"
`include "hazard_unit_if.vh"
`include "forwarding_unit_if.vh"

`include "cpu_types_pkg.vh"
`include "custom_types_pkg.vh"
import cpu_types_pkg::*;
import custom_types_pkg::*;

module datapath (
	input logic CLK, nRST,
	datapath_cache_if.dp dpif
);
    // import types
    

    // pc init
    parameter PC_INIT = 0;

//Local Declarations
  //*******************************************\\
	// interfaces
	fetch_if ftif();
	decode_if dcif();
	execute_if exif();
	memory_if mmif();
	a_writeback_if wbif();

  hazard_unit_if huif();
  forwarding_unit_if fwif();

	// DUT
	fetch_stage #(.PC_INIT(PC_INIT)) FT(CLK, nRST, ftif);
	decode_stage DC(CLK, nRST, dcif);
	execute_stage EX(CLK, nRST, exif);
	memory_stage MM(CLK, nRST, mmif);
	a_writeback_stage WB(wbif);

  hazard_unit HU(huif);
  forwarding_unit FU(fwif);

  //Local Variables
  logic [3:0] flush, freeze;

  //*******************************************\\
//

//Datapath-Cache Routings
  //*******************************************\\
	always_comb begin: Datapath_Logic
		// instruction memory
    
		dpif.imemREN = ftif.imemREN && ~exif.execute_p.halt; //if halt, stop, if 
		dpif.imemaddr = ftif.imemaddr;

		ftif.imemload = dpif.imemload;

		// data memory
		dpif.dmemREN = mmif.dmemREN;
		dpif.dmemWEN = mmif.dmemWEN;
		dpif.dmemstore = mmif.dmemstore;
		dpif.dmemaddr = mmif.dmemaddr;
    dpif.datomic = mmif.atomic;

		mmif.dmemload = dpif.dmemload;
  
	end

	always_ff @(posedge CLK, negedge nRST) begin: Datapath_Reg_Logic
		if (~nRST)
			dpif.halt <= 1'b0;
		else if (exif.execute_p.halt)
			dpif.halt <= exif.execute_p.halt;
		else
			dpif.halt <= 1'b0;
	end
  //*******************************************\\
//

// Hazard unit
  always_comb begin: hazard_unit
    huif.memread_dc = dcif.decode_p.dREN;
    huif.memwrite_dc = dcif.decode_p.dWEN;
    huif.mematomic_dc = dcif.decode_p.atomic;
    huif.memread_ex = exif.execute_p.dREN;
    huif.memwrite_ex = exif.execute_p.dWEN;
    //Rt's
    huif.Rt_ft = ftif.fetch_p.imemload[20:16];
    huif.Rt_dc = dcif.decode_p.Rt;

    //Rd's
    huif.Rd_dc = dcif.decode_p.Rd;

    //Rs's
    huif.Rs_ft = ftif.fetch_p.imemload[25:21];
    
    huif.JumpSel = mmif.JumpSel;
    huif.branch_mispredict = mmif.branch_mispredict;
    flush = huif.flush;
    freeze = huif.freeze;
    huif.halt = exif.execute_p.halt;
  end

//

// Forwarding Unit
  always_comb begin
    //Execute Stage
    fwif.Rs_dc = dcif.decode_p.Rs;
    fwif.Rt_dc = dcif.decode_p.Rt;

    //Mem Stage 
    fwif.Rw_ex = exif.execute_p.Rw; //grab from registered output of ex stage
    fwif.execute_data_in = mmif.forwarding_unit_data;

    //Writeback Stage
    fwif.Rw_wb = wbif.writeback_p.Rw;
    fwif.writeback_data_in = wbif.writeback_p.port_w;

    //Forwarding unit outputs
    exif.port_a_forwarding_control = fwif.port_a_control;
    exif.port_b_forwarding_control = fwif.port_b_control;

    exif.FW_execute_data = fwif.execute_data_out;
    exif.FW_writeback_data = fwif.writeback_data_out;

  end


//

//Pipeline Data passages
  always_comb begin : fetch_to_decode
    dcif.fetch_p = ftif.fetch_p;
    dcif.writeback_p = wbif.writeback_p;
  end

  always_comb begin : in_fetch
    //fetch branch/jump related inputs
    ftif.BranchTaken  = mmif.BranchTaken;
    ftif.BranchAddr   = mmif.BranchAddr;
    ftif.JumpSel  = mmif.JumpSel;
    ftif.JumpAddr = mmif.JumpAddr;
    ftif.port_a   = mmif.port_a;
    ftif.PC_mem   = mmif.execute_p.PC;
    ftif.NPC_mem  = mmif.execute_p.NPC;
    ftif.branch_mispredict = mmif.branch_mispredict;
    ftif.BNE      = exif.execute_p.BNE;
    ftif.BEQ      = exif.execute_p.BEQ;

  end

  always_comb begin : Decode_to_Execute
    exif.decode_p = dcif.decode_p;
  end

  always_comb begin : Execute_to_Memory
    mmif.execute_p = exif.execute_p;
  end

  always_comb begin : Memory_to_Writeback
    wbif.memory_p = mmif.memory_p;
  end
//


//Pipeline Flush/Freeze routing
  always_comb begin
    ftif.flush = flush[3];
    dcif.flush = flush[2];
    exif.flush = flush[1];
    mmif.flush = flush[0];
  end

  always_comb begin
    ftif.freeze = freeze[3];
    dcif.freeze = freeze[2];
    exif.freeze = freeze[1];
    mmif.freeze = freeze[0];
  end

  always_comb begin
    ftif.ihit = dpif.ihit;
    dcif.ihit = dpif.ihit;
    exif.ihit = dpif.ihit;
    mmif.ihit = dpif.ihit;

    ftif.dhit = dpif.dhit;
    dcif.dhit = dpif.dhit;
    exif.dhit = dpif.dhit;
    mmif.dhit = dpif.dhit;
  end
//








endmodule
