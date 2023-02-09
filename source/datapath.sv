  /*
    Cameron McCutcheon
    mccutchc@purde.edu

    datapath contains register file, control, hazard,
    muxes, and glue logic for processor
  */

// data path interface
`include "datapath_cache_if.vh"
`include "alu_if.vh"
`include "control_unit_if.vh"
`include "register_file_if.vh"
`include "request_unit_if.vh"
`include "program_counter_if.vh"
`include "pipeline_if.vh"

  // alu op, mips op, and instruction type
  `include "cpu_types_pkg.vh"

  module datapath (
    input logic CLK, nRST,
    datapath_cache_if.dp dpif
  );
    // import types
    import cpu_types_pkg::*;

    // //Interface declarations
    // control_unit_if cuif();
    // register_file_if rfif();
    // alu_if aluif(); 



    // pc init
    parameter PC_INIT = 0;

//Local Declarations
  //*******************************************\\
  // interfaces
  alu_if aluif();
  control_unit_if cuif();
  register_file_if rfif();
  program_counter_if pcif();

  pipeline_if fdif();
  pipeline_if deif();
  pipeline_if emif();
  pipeline_if mwif();

  // DUT
  alu ALU(aluif);
  control_unit CU(cuif);
  register_file RF(CLK, nRST, rfif);
  program_counter PC(CLK, nRST, pcif);

  ifid FD(CLK, nRST, fdif);
  idex DE(CLK, nRST, deif);
  exmem EM(CLK, nRST, emif);
  memwb MW(CLK, nRST, mwif);


  // Instruction Signals
  word_t Instruction;
  opcode_t op;
  regbits_t rs;
  regbits_t rt;
  regbits_t rd;
  logic [15:0] imm;
  funct_t func;
  //*******************************************\\
//

// for testing
always_comb begin: init
  fdif.stall = 1'b0;
  fdif.flush = 1'b0;
  deif.stall = 1'b0;
  deif.flush = 1'b0;
  emif.stall = 1'b0;
  emif.flush = 1'b0;
  mwif.stall = 1'b0;
  mwif.flush = 1'b0;
end

//Instruction routing - will need some of these for the pipelining forwarding unit
  //*******************************************\\
  always_comb begin: Instruction_Signals
    Instruction = fdif.imemload;
    op = opcode_t'(Instruction[31:26]);
    rs = Instruction[25:21];
    rt = Instruction[20:16];
    rd = Instruction[15:11];
    imm = Instruction[15:0];
    func = funct_t'(Instruction[5:0]);
  end
  //*******************************************\\
//
 
//Datapath
  //*******************************************\\
  word_t npc;
  word_t ZeroExtImm;
  word_t SignExtImm;
  word_t Imm_Ext;
  word_t BranchAddr;

  always_comb begin: Decode_Signals
    npc = pcif.PC + 32'd4;
    ZeroExtImm = {16'h0000, imm};
    SignExtImm = {{16{imm[15]}}, imm};
    
    if (cuif.ExtOP)
      Imm_Ext = SignExtImm;
    else
      Imm_Ext = ZeroExtImm;
  end 

  always_comb begin: Execute_Signals
    if ((deif.BEQ & aluif.zero) | (deif.BNE & ~aluif.zero))
      BranchAddr = (npc + {deif.Imm_Ext[29:0], 2'b00});
    else
      BranchAddr = npc;
  end
  //*******************************************\\
//

//ALU
  //*******************************************\\
  always_comb begin: ALU_Logic
    aluif.ALUOP = deif.ALUctr;
    aluif.porta = deif.port_a;
    if (~deif.ALUSrc)
      aluif.portb = deif.port_b;
    else 
      aluif.portb = deif.Imm_Ext;
  end
  //*******************************************\\
//

// Control Unit
  //*******************************************\\
  always_comb begin: Control_Unit_Logic
    cuif.opcode = op;
    cuif.func = func;
    cuif.ihit = dpif.ihit;
    cuif.dhit = dpif.dhit;
  end
  //*******************************************\\
//

//Register File
  //*******************************************\\
  always_comb begin: Register_File_Logic
    rfif.WEN = mwif.RegWr;

    rfif.wsel = mwif.RW;
    
    rfif.rsel1 = rs;
    rfif.rsel2 = rt;
    
    case (mwif.MemtoReg)
      2'd0: rfif.wdat = mwif.port_o;
      2'd1: rfif.wdat = mwif.NPC;
      2'd2: rfif.wdat = mwif.dmemload;
      2'd3: rfif.wdat = mwif.LUI;
    endcase
  end
  //*******************************************\\
//

// Program Counter
  //*******************************************\\
  always_comb begin: Program_Counter_Logic
    case (deif.JumpSel)
      2'd0: pcif.next_PC = BranchAddr;
      2'd1: pcif.next_PC = deif.JumpAddr;
      2'd2: pcif.next_PC = deif.port_a;
      default: pcif.next_PC = BranchAddr;
    endcase
    pcif.EN = dpif.ihit & ~dpif.dhit;
  end
  //*******************************************\\
//

//Datapath External Routings
  //*******************************************\\
  always_comb begin: Datapath_Logic
    dpif.imemREN = 1'b1;
    dpif.imemaddr = pcif.PC;
    dpif.dmemREN = emif.dREN;
    dpif.dmemWEN = emif.dWEN;
    dpif.dmemstore = emif.dmemstore;
    dpif.dmemaddr = emif.port_o;
  end
  //*******************************************\\
//

  always_ff @(posedge CLK, negedge nRST) begin: Datapath_Reg_Logic
    if (~nRST)
      dpif.halt <= 1'b0;
    else if (mwif.halt)
      dpif.halt <= mwif.halt;
    else
      dpif.halt <= 1'b0;
  end

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
