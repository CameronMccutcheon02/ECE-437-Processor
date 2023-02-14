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

module fetch_stage(
    input logic CLK, nRST
    fetch_if.FT ftif

);

//grab all the structs values
import structs::*;
import cpu_types_pkg::*;

fetch_t fetch;

always_ff @(posedge CLK, negedge nRST) begin: PipelineLatching
    if (~nRST)
        void`(ftif.fetch_p);
    else if (exif.ihit)
        ftif.fetch_p <= fetch;
    else if (ftif.flush)
        void`(ftif.fetch_p);
    else if (ftif.stall)
        ftif.fetch_p <= ftif.fetch_p;
    else 
        ftif.fetch_p <= ftif.fetch_p;
end

//Program Counter //NICK CAN YOU DO THIS PART?

//do note that the control signals are coming from the execute data structure 
//because of the way the latching is done, all the signals should be present
//so just read the structs.vh file to figure out what you need

//use syntax of ftif.execute_p.BNE to access
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

//Block output signal routings
    //*******************************************\\
    always_comb begin
    //registered signals to go into the bus
    fetch.imemload = ftif.imemload;
    fetch.NPC = PC + 4; //NICK you can change this stuff too
    

    //block outputs to program memory
    ftif.imemREN = 1; 
    ftif.imemaddr = PC; //NICK
    end
    //*******************************************\\
//






endmodule