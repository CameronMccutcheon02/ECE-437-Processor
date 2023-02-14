//Cameron McCutcheon

`include "datapath_cache_if.vh"
`include "alu_if.vh"
`include "control_unit_if.vh"
`include "register_file_if.vh"
`include "request_unit_if.vh"
`include "program_counter_if.vh"
`include "pipeline_if.vh"
`include "cpu_types_pkg.vh"
`include "structs.vh"

`include "decode_if.vh"
`include "execute_if.vh"
`include "memory_if.vh"
`include "writeback_if.vh"
`include "fetch_if.vh"

module execute_stage(
    input logic CLK, nRST
    execute_if.EX exif

);

//grab all the structs values
import structs::*;
import cpu_types_pkg::*;

alu_if aluif();

alu ALU(aluif);

execute_t execute;

always_ff @(posedge CLK, negedge nRST) begin: PipelineLatching
    if (~nRST)
        void`(exif.execute_p);
    else if (exif.ihit)
        exif.execute_p <= execute;
    else if (exif.flush)
        void`(exif.execute_p);
    else if (exif.stall)
        exif.execute_p <= exif.execute_p;
    else 
        exif.execute_p <= exif.execute_p;
end

//ALU
  //*******************************************\\
  always_comb begin: ALU_Logic
    aluif.ALUOP = exif.decode_p.ALUctr;
    aluif.porta = exif.decode_p.port_a;
    if (~exif.decode_p.ALUSrc)
      aluif.portb = exif.decode_p.port_b;
    else 
      aluif.portb = exif.decode_p.Imm_Ext;
  end
  //*******************************************\\
//

//Block output signal routings
    //*******************************************\\
    always_comb begin
    //Mem Layer
    execute.dREN = exif.decode_p.dREN;
    execute.dWEN = exif.decode_p.dWEN;
    execute.BEQ = exif.decode_p.BEQ;
    execute.BNE = exif.decode_p.BNE;
    execute.JumpSel = exif.decode_p.JumpSel;
    execute.JumpAddr = exif.decode_p.JumpAddr;
    execute.alu_zero = aluif.zero;

    //WB Layer
    execute.RegWr = exif.decode_p.RegWr;
    execute.MemtoReg = exif.decode_p.MemtoReg;
    execute.halt = exif.decode_p.halt;
    execute.RW = exif.decode_p.RW;
    execute.NPC = exif.decode_p.NPC;
    
    //data signals
    execute.port_o = aluif.oport;
    execute.port_a = exif.decode_p.port_a;
    execute.port_b = exif.decode_p.port_b;
    execute.Imm_Ext = exif.decode_p.Imm_Ext;
    
    end
    //*******************************************\\
//






endmodule