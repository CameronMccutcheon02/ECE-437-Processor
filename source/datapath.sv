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

	// DUT
	fetch_stage FT(CLK, nRST, ftif);
	decode_stage DC(CLK, nRST, dcif);
	execute_stage EX(CLK, nRST, exif);
	memory_stage MM(CLK, nRST, mmif);
	writeback_stage WB(wbif);

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

//Hazard unit

//Forwarding Unit

//Pipeline Data passages
  always_comb begin : fetch_to_decode
    dcif.fetch_p = ftif.fetch_p;
    dcif.writeback_p = wbif.writeback_p;
  end

  always_comb begin : in_fetch
    ftif.execute_p = exif.execute_p;
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
    flush = 4'd0;
    ftif.flush = flush[0];
    dcif.flush = flush[1];
    exif.flush = flush[2];
    mmif.flush = flush[3];
  end

  always_comb begin
    freeze = 4'd0;
    ftif.freeze = freeze[0];
    dcif.freeze = freeze[1];
    exif.freeze = freeze[2];
    mmif.freeze = freeze[3];
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
