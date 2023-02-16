//Cameron McCutcheon

`include "control_unit_if.vh"
`include "register_file_if.vh"
`include "decode_if.vh"

`include "cpu_types_pkg.vh"
`include "custom_types_pkg.vh"

module decode_stage(
    input logic CLK, nRST,
    decode_if.DC dcif
);

	//grab all the structs values
	import cpu_types_pkg::*;
	import custom_types_pkg::*;

	// initialize structs
	decode_t decode;

	// initialize interfaces
	control_unit_if cuif();
	register_file_if rfif();

	// initialize DUTs
	control_unit CU(cuif);
	register_file RF(CLK, nRST, rfif);

	// declare local variables
	word_t Instruction;
	opcode_t op;
	regbits_t rs;
	regbits_t rt;
	regbits_t rd;
	logic [15:0] imm;
	funct_t func;
	word_t Imm_Ext;

	always_ff @(posedge CLK, negedge nRST) begin: PipelineLatching
		if (~nRST)
			dcif.decode_p <= '0;
		else if (dcif.flush)
			dcif.decode_p <= '0;
		else if (dcif.freeze)
			dcif.decode_p <= dcif.decode_p;
		else if (dcif.ihit)
			dcif.decode_p <= decode;
		else 
			dcif.decode_p <= dcif.decode_p;
	end


//Instruction routing - grab instruction routing from the input stage
  //*******************************************\\
	always_comb begin: Instruction_Signals
		Instruction = dcif.fetch_p.imemload;
		op = opcode_t'(Instruction[31:26]);
		rs = Instruction[25:21];
		rt = Instruction[20:16];
		rd = Instruction[15:11];
		imm = Instruction[15:0];
		func = funct_t'(Instruction[5:0]);
	end
  //*******************************************\\
//

// Control Unit
  //*******************************************\\
    //input routings
	always_comb begin: Control_Unit_Logic
		cuif.opcode = op;
		cuif.func = func;
		cuif.ihit = dcif.ihit;
		cuif.dhit = dcif.dhit;
	end
  //*******************************************\\
//

//Register File
  //*******************************************\\
	always_comb begin: Register_File_Logic
		rfif.WEN = dcif.writeback_p.RegWEN;

		rfif.wsel = dcif.writeback_p.Rw;

		rfif.rsel1 = rs;
		rfif.rsel2 = rt;

		rfif.wdat = dcif.writeback_p.port_w;
	end
  //*******************************************\\
//

//Block output signal routings
    //*******************************************\\
    always_comb begin
		//Hazard unit/Forwarding unit stuffs
		decode.Rt = rt;
		decode.Rd = rd;

		//Execute Layer
		decode.ALUctr = cuif.ALUctr;
		decode.ALUSrc = cuif.ALUSrc;
		
		//Mem Layer
		decode.dREN = cuif.dREN;
		decode.dWEN = cuif.dWEN;
		//decode.BEQ = cuif.BEQ;
		//decode.BNE = cuif.BNE;
		//decode.JumpSel = cuif.JumpSel;
		//decode.JumpAddr = {dcif.fetch_p.NPC[31:28], Instruction[25:0], 2'b00};

		//WB Layer
		decode.Rw = (cuif.jal) ? 5'd31 : (cuif.RegDst) ? rd : rt;
		decode.RegWEN = cuif.RegWEN;
		decode.MemtoReg = cuif.MemtoReg;
		decode.halt = cuif.halt;
		decode.NPC = dcif.fetch_p.NPC;
		
		//data signals
		decode.port_a = rfif.rdat1;
		decode.port_b = rfif.rdat2;
		if (cuif.ExtOP == 2'd1)
			Imm_Ext = {{16{imm[15]}}, imm};
		else if (cuif.ExtOP == 2'd0)
			Imm_Ext = {16'h0000, imm};
		else 
			Imm_Ext = {imm, 16'h0000};
		decode.Imm_Ext = Imm_Ext;

		// combinational outputs for hazard unit
		dcif.porta = rfif.rdat1;
		dcif.JumpSel = cuif.JumpSel;
		dcif.JumpAddr = {dcif.fetch_p.NPC[31:28], Instruction[25:0], 2'b00};
		dcif.BranchTaken = 1'b0;
		if (cuif.BEQ & (rfif.rdat1 == rfif.rdat2) | cuif.BNE & (rfif.rdat1 != rfif.rdat2))
			dcif.BranchTaken = 1'b1;
		dcif.BranchAddr = dcif.fetch_p.NPC + {Imm_Ext[29:0], 2'b00};
	end
    //*******************************************\\
//

endmodule