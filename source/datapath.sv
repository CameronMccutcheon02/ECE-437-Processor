  /*
    Cameron McCutcheon
    mccutchc@purde.edu

    datapath contains register file, control, hazard,
    muxes, and glue logic for processor
  */

  // data path interface
  `include "datapath_cache_if.vh"
  `include "control_unit_if.vh"
  `include "request_unit_if.vh"
  `include "alu_if.vh"
  `include "register_file_if.vh"
  import cpu_types_pkg::*;

  // alu op, mips op, and instruction type
  `include "cpu_types_pkg.vh"

  module datapath (
    input logic CLK, nRST,
    datapath_cache_if.dp dpif
  );
    // import types
    import cpu_types_pkg::*;

    //Interface declarations
    control_unit_if cuif();
    register_file_if rfif();
    alu_if aluif(); 
    request_unit_if ruif();



    // pc init
    parameter PC_INIT = 0;

  //PC Declarations
  word_t PC, PC_nxt;

  //Declare some routing logic arrays
  word_t ExtData;



  //Declare all modules
  control_unit CU (.cuif(cuif));
  register_file RF(.CLK(CLK), .nRST(nRST), .rfif(rfif));
  alu LU(.aluif(aluif));
  request_unit RU(.CLK(CLK), .nRST(nRST),.ruif(ruif));
  extender EX(.in_data(ruif.imem[15:0]), .ExtType(cuif.ExtType), .out_data(ExtData));


//CU
  //*******************************************\\
  //Signal Routings for Control Unit
  always_comb begin
    cuif.instr_op = ruif.instr_op;
    cuif.funct_op = ruif.funct_op;
    cuif.stall = ruif.stall;
  end
  //*******************************************\\
//


//RF
  //*******************************************\\
  //Signal Routings for Register File
  //Inputs
  always_comb begin
    rfif.wsel   = (cuif.JAL) ? 5'd31 : //if JAL use $31
                  (cuif.RegDst) ? ruif.imem[15:11] : ruif.imem[20:16];
    
    rfif.rsel1  = ruif.imem[25:21];
    rfif.rsel2  = ruif.imem[20:16];

    rfif.WEN    = cuif.RegWrite && (ruif.ihit || ruif.dhit);

    rfif.wdat   = (cuif.MemToReg == 2'b00) ? ruif.dmem : //If we are doing a load, use dmem to store to 
                  (cuif.MemToReg == 2'b10) ? (PC + 4) : //If we are doing a JAL, use PC + 4
                  (cuif.MemToReg == 2'b01) ? aluif.port_o : 0; //Normal Operation, use ALU output or do 0 if bad
  end
  //*******************************************\\
//


//ALU
  //*******************************************\\
  //Signal Routings for ALU 
  always_comb begin
    aluif.alu_op = cuif.alu_op;
    aluif.port_a = rfif.rdat1;
    aluif.port_b = (cuif.ALUSRC) ? ExtData : rfif.rdat2; //ExtData when ALUSRC is 1 
  end
  //*******************************************\\
//


//RU
  //*******************************************\\
  //Signal Routings for Request Unit 
  //External from datapath
  always_comb begin
    ruif.imemload = dpif.imemload; //Grab imemload from outside datapath
    ruif.dmemload = dpif.dmemload; //Grab dmem
    ruif.ihit     = dpif.ihit;
    ruif.dhit     = dpif.dhit;

    //Internal to Datapath
    ruif.MemRead  = cuif.MemRead;
    ruif.MemWrite = cuif.MemWrite;
    ruif.pc       = PC;
    ruif.port_o   = aluif.port_o;
    ruif.port_b   = rfif.rdat2;
  end
  //*******************************************\\
//


//PC
  //*******************************************\\
  //PC Signal Control and Routing
  always_ff @(posedge CLK, negedge nRST) begin
    if(!nRST) begin
      PC <= PC_INIT;
    end
    else begin
      PC <= PC_nxt;
    end
  end
  always_comb begin
    if (ruif.ihit) begin
      case(cuif.Jump)
        2'b00:  PC_nxt = (aluif.zero && cuif.Branch && cuif.instr_op == BEQ) 
                          || (!aluif.zero && cuif.Branch && cuif.instr_op == BNE) 
                              ? PC + 4 + (ExtData << 2) : PC + 4;

        2'b01:  PC_nxt = {PC[31:28], (ruif.imem[25:0] << 2)};

        2'b10:  PC_nxt = rfif.rdat1;

        default: PC_nxt = PC + 4;

      endcase
    end
    else PC_nxt = PC;
  end
  //*******************************************\\
//

//External Port Routing for DPIF
  //*******************************************\\
  //External Port Routing
  always_comb begin
    dpif.imemREN  = ruif.imemREN;
    dpif.dmemWEN  = ruif.dmemWEN;
    dpif.dmemREN  = ruif.dmemREN;
    dpif.datomic  = ruif.datomic;
    dpif.halt     = cuif.halt;

    //Data/Address routing
    dpif.imemaddr = ruif.imemaddr;
    dpif.dmemaddr = ruif.dmemaddr;
    dpif.dmemstore= ruif.dmemstore;
  end
  //*******************************************\\
//
  


  endmodule
