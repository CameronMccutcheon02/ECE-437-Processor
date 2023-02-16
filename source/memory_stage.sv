//Cameron McCutcheon

`include "memory_if.vh"

`include "cpu_types_pkg.vh"
`include "custom_types_pkg.vh"

module memory_stage(
    input logic CLK, nRST,
    memory_if.MEM mmif
);

    //grab all the structs values
    import cpu_types_pkg::*;
    import custom_types_pkg::*;

    // initialize structs
    memory_t memory;

    always_ff @(posedge CLK, negedge nRST) begin: PipelineLatching
        if (~nRST)
            mmif.memory_p <= '0;
        else if (mmif.flush)
            mmif.memory_p <= '0;
        else if (mmif.freeze)
            mmif.memory_p <= mmif.memory_p;
        else if (mmif.ihit | mmif.dhit)
            mmif.memory_p <= memory;
        else 
            mmif.memory_p <= mmif.memory_p;
    end

//To data Memory
  //*******************************************\\
    always_comb begin
        mmif.dmemREN = mmif.execute_p.dREN;
        mmif.dmemWEN = mmif.execute_p.dWEN;
        mmif.dmemstore = mmif.execute_p.port_b;
        mmif.dmemaddr = mmif.execute_p.port_o;
    end
  //*******************************************\\
//

//Block output signal routings
  //*******************************************\\
    always_comb begin
        //WB Layer
        memory.Rw = mmif.execute_p.Rw;
        memory.RegWEN = mmif.execute_p.RegWEN;
        memory.MemtoReg = mmif.execute_p.MemtoReg;
        memory.halt = mmif.execute_p.halt;
        memory.NPC = mmif.execute_p.NPC;
        
        //data signals
        memory.port_o = mmif.execute_p.port_o;
        memory.dmemload = mmif.dmemload;
        memory.Imm_Ext = mmif.execute_p.Imm_Ext;
    end
  //*******************************************\\
//

endmodule