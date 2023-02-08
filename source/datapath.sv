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
    // request_unit_if ruif();



    // pc init
    parameter PC_INIT = 0;

//Local Declarations
  //*******************************************\\
  // interfaces
  alu_if aluif();
  control_unit_if cuif();
  register_file_if rfif();
  request_unit_if ruif();
  program_counter_if pcif();

  pipeline_stage stages();


  // DUT
  alu ALU(aluif);
  control_unit CU(cuif);
  register_file RF(CLK, nRST, rfif);
  request_unit RU(CLK, nRST, ruif);
  program_counter PC(CLK, nRST, pcif);

  // Instruction Signals
  word_t Instruction;
  opcode_t op;
  regbits_t rs;
  regbits_t rt;
  regbits_t rd;
  logic [4:0] shamt;
  logic [15:0] imm;
  funct_t func;
  //*******************************************\\
//

// initial begin
//   stages.in_data[0] = 0;
//   //stages.in_data[6] = 32'd69;

// end


//Instruction routing - will need some of these for the pipelining forwarding unit
  //*******************************************\\
  always_comb begin: Instruction_Signals
    Instruction = dpif.imemload;
    op = opcode_t'(Instruction[31:26]);
    rs = Instruction[25:21];
    rt = Instruction[20:16];
    rd = Instruction[15:11];
    imm = Instruction[15:0];
    shamt = Instruction[10:6];
    func = funct_t'(Instruction[5:0]);
  end
  //*******************************************\\
//

  
//Datapath
  //*******************************************\\
  word_t npc;
  word_t ZeroExtImm;
  word_t SignExtImm;
  word_t JumpAddr;
  word_t JRAddr;
  word_t BranchAddr;

  always_comb begin: Datapath_Signals
    npc = pcif.PC + 32'd4;
    ZeroExtImm = {16'h0000, imm};
    SignExtImm = {{16{imm[15]}}, imm};
    JumpAddr = {npc[31:28], Instruction[25:0], 2'b00};
    JRAddr = rfif.rdat1;
    if ((cuif.BEQ & aluif.zero) | (cuif.BNE & ~aluif.zero))
      BranchAddr = (npc + {ZeroExtImm[29:0], 2'b00});
    else
      BranchAddr = npc;
  end 
  //*******************************************\\
//


//ALU
  //*******************************************\\
  always_comb begin: ALU_Logic
    aluif.ALUOP = cuif.ALUctr;
    aluif.porta = rfif.rdat1;
    if (~cuif.ALUSrc)
      aluif.portb = rfif.rdat2; //Cam's notes- we can definitely do the routing of the sign extender a little better- take a look at it when we get to the pipelining
    else if (cuif.ExtOP)
      aluif.portb = SignExtImm;
    else
      aluif.portb = ZeroExtImm;
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
    rfif.WEN = cuif.RegWr & (dpif.ihit | dpif.dhit);

    if (cuif.jal)
      rfif.wsel = 5'd31;
    else if (cuif.RegDst)
      rfif.wsel = rd;
    else
      rfif.wsel = rt;
    
    rfif.rsel1 = rs;
    rfif.rsel2 = rt;
    
    case (cuif.MemtoReg)
      2'd0: rfif.wdat = aluif.oport;
      2'd1: rfif.wdat = npc;
      2'd2: rfif.wdat = dpif.dmemload;
      2'd3: rfif.wdat = {imm, 16'b0};
    endcase
  end
  //*******************************************\\
//


//Request Unit
  //*******************************************\\
  always_comb begin: Request_Unit_Logic
    ruif.ihit = dpif.ihit;
    ruif.dhit = dpif.dhit;
    ruif.iREN = cuif.iREN;
    ruif.dREN = cuif.dREN;
    ruif.dWEN = cuif.dWEN;
  end
  //*******************************************\\
//


// Program Counter
  //*******************************************\\
  always_comb begin: Program_Counter_Logic
    case (cuif.JumpSel)
      2'd0: pcif.next_PC = BranchAddr;
      2'd1: pcif.next_PC = JumpAddr;
      2'd2: pcif.next_PC = JRAddr;
      default: pcif.next_PC = BranchAddr;
    endcase
    pcif.EN = dpif.ihit;
  end
  //*******************************************\\
//


//Datapath External Routings
  //*******************************************\\
  always_comb begin: Datapath_Logic
    dpif.imemREN = cuif.iREN;
    dpif.imemaddr = pcif.PC;
    dpif.dmemREN = ruif.dmemREN;
    dpif.dmemWEN = ruif.dmemWEN;
    dpif.dmemstore = rfif.rdat2;
    dpif.dmemaddr = aluif.oport;
  end
  //*******************************************\\
//

  always_ff @(posedge CLK, negedge nRST) begin: Datapath_Reg_Logic
    if (~nRST)
      dpif.halt <= 1'b0;
    else
      dpif.halt <= cuif.halt;
  end

endmodule
