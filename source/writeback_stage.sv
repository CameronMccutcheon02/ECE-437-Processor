//Cameron McCutcheon

`include "cpu_types_pkg.vh"
`include "custom_types_pkg.vh"

`include "writeback_if.vh"

module writeback_stage(
    writeback_if.WB wbif
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
        2'd3: wbif.writeback_p.port_w = wbif.memory_p.LUI;
        endcase 
    end
    //*******************************************\\
//


endmodule