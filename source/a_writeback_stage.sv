//Cameron McCutcheon

`include "cpu_types_pkg.vh"
`include "custom_types_pkg.vh"

`include "a_writeback_if.vh"

module a_writeback_stage(
    a_writeback_if.WB wbif
);

    //grab all the structs values
    import cpu_types_pkg::*;
    import custom_types_pkg::*;

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


    always_comb begin
        wbif.writeback_p.RegWEN = wbif.memory_p.RegWEN;
        wbif.writeback_p.halt = wbif.memory_p.halt;
        wbif.writeback_p.Rw = wbif.memory_p.Rw;
    end
    //*******************************************\\
//


endmodule