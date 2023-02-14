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


module memory_stage(
    input logic CLK, nRST
    memory_if.MEM mmif

);

//grab all the structs values
import structs::*;
import cpu_types_pkg::*;


memory_t memory;

always_ff @(posedge CLK, negedge nRST) begin: PipelineLatching
    if (~nRST)
        void`(mmif.memory_p);
    else if (mmif.ihit | mmif.dhit)
        mmif.memory_p <= memory;
    else if (mmif.flush)
        void`(mmif.memory_p);
    else if (mmif.stall)
        mmif.memory_p <= mmif.memory_p;
    else 
        mmif.memory_p <= mmif.memory_p;
end

//To data Memory
    //*******************************************\\
    always_comb begin
        mmif.dmemaddr = mmif.execute_p.port_o;
        mmif.dmemstore = mmif.execute_p.port_b;
        mmif.dmemREN = mmif.execute_p.dREN;
        mmif.dmemWEN = mmif.execute_p.dWEN;
    end
    //*******************************************\\
//


//Block output signal routings
    //*******************************************\\
    always_comb begin

    //WB Layer
    memory.RegWr = mmif.execute_p.RegWr;
    memory.MemtoReg = mmif.execute_p.MemtoReg;
    memory.halt = mmif.execute_p.halt;
    memory.RW = mmif.execute_p.RW;
    memory.NPC = mmif.execute_p.NPC;
    
    //data signals
    memory.port_o = mmif.execute_p.oport;
    memory.dmemload = mmif.dmemload;
    memory.Imm_Ext = mmif.execute_p.Imm_Ext;
    
    end
    //*******************************************\\
//






endmodule