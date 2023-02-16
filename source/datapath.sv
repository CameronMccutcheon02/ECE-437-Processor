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
`include "hazard_unit_if.vh"

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
	writeback_if wbif();

  hazard_unit_if huif();

	// DUT
	fetch_stage FT(CLK, nRST, ftif);
	decode_stage DC(CLK, nRST, dcif);
	execute_stage EX(CLK, nRST, exif);
	memory_stage MM(CLK, nRST, mmif);
	writeback_stage WB(wbif);

  hazard_unit HU(huif);

  //Local Variables
  logic [3:0] flush, freeze;

  //*******************************************\\
//

//Datapath-Cache Routings
  //*******************************************\\
	always_comb begin: Datapath_Logic
		// instruction memory
		dpif.imemREN = ftif.imemREN;
		dpif.imemaddr = ftif.imemaddr;
		ftif.imemload = dpif.imemload;

		// data memory
		dpif.dmemREN = mmif.dmemREN;
		dpif.dmemWEN = mmif.dmemWEN;
		dpif.dmemstore = mmif.dmemstore;
		dpif.dmemaddr = mmif.dmemaddr;
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

// Hazard unit
  always_comb begin: hazard_unit
    huif.memread_dc = dcif.decode_p.dREN;
    huif.memread_ex = exif.execute_p.dREN;
    //Rt's
    huif.Rt_ft = ftif.fetch_p.imemload[20:16];
    huif.Rt_dc = dcif.decode_p.Rt;
    huif.Rt_ex = exif.execute_p.Rt;

    //Rd's
    huif.Rd_dc = dcif.decode_p.Rd;
    huif.Rd_ex = exif.execute_p.Rd;

    //Rs's
    huif.Rs_ft = ftif.fetch_p.imemload[25:21];
    
    huif.JumpSel = dcif.JumpSel;
    huif.BranchTaken = dcif.BranchTaken;
    flush = huif.flush;
    freeze = huif.freeze;
  end

//

// Forwarding Unit



//

//Pipeline Data passages
  always_comb begin : fetch_to_decode
    dcif.fetch_p = ftif.fetch_p;
    dcif.writeback_p = wbif.writeback_p;
  end

  always_comb begin : in_fetch
    //ftif.execute_p = exif.execute_p;
    ftif.BranchTaken = dcif.BranchTaken;
    ftif.BranchAddr = dcif.BranchAddr;
    ftif.JumpSel = dcif.JumpSel;
    ftif.JumpAddr = dcif.JumpAddr;
    ftif.port_a = dcif.porta;
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
