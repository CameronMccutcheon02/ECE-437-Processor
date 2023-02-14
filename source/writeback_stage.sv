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


module writeback_stage(
    input logic CLK, nRST
    writeback_if.WB wbif

);

//grab all the structs values
import structs::*;
import cpu_types_pkg::*;

//To data Memory
    //*******************************************\\
    always_comb begin
        case (wbif.memory_p.MemtoReg)
        2'd0: wbif.writeback_p.port_w = wbif.memory_p.port_o;
        2'd1: wbif.writeback_p.port_w = wbif.memory_p.NPC;
        2'd2: wbif.writeback_p.port_w = wbif.memory_p.dmemload;
        2'd3: wbif.writeback_p.port_w = wbif.memory_p.Imm_Ext;
        endcase 
    end
    //*******************************************\\
//


endmodule