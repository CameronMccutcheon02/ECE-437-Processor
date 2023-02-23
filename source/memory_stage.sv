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

    word_t next_dmemload;


    always_ff @(posedge CLK, negedge nRST) begin: PipelineLatching
        if (~nRST)
            mmif.memory_p <= '0;
        else if (mmif.flush)
            mmif.memory_p <= '0;
        else if (mmif.freeze)
            mmif.memory_p <= mmif.memory_p;
        else if (mmif.ihit)
            mmif.memory_p <= memory;
        else 
            mmif.memory_p <= mmif.memory_p;
    end

    always_ff @(posedge CLK, negedge nRST) begin: dmemloadLatching
        if (~nRST)
            memory.dmemload <= '0;
        else if (mmif.dhit)
            memory.dmemload <= next_dmemload;
        else
            memory.dmemload <= memory.dmemload;
    end

//To data Memory
  //*******************************************\\
    always_comb begin
        mmif.dmemREN = mmif.execute_p.dREN;
        mmif.dmemWEN = (mmif.execute_p.halt) ? 0 : mmif.execute_p.dWEN;
        mmif.dmemstore = mmif.execute_p.port_b;
        mmif.dmemaddr = mmif.execute_p.port_o;
    end
  //*******************************************\\
//

//Block output signal routings
  //*******************************************\\
    always_comb begin
        //Hazard unit/Forwarding unit stuffs
		// memory.Rt = mmif.execute_p.Rt;
		// memory.Rd = mmif.execute_p.Rd;

        //WB Layer
        memory.Rw   = mmif.execute_p.Rw;
        memory.RegWEN   = mmif.execute_p.RegWEN;
        memory.MemtoReg     = mmif.execute_p.MemtoReg;
        memory.halt     = mmif.execute_p.halt;
        memory.NPC  = mmif.execute_p.NPC;
        
        //data signals
        memory.port_o   = mmif.execute_p.port_o;
        next_dmemload   = mmif.dmemload;
        memory.Imm_Ext  = mmif.execute_p.Imm_Ext;

        //branch evaluation output routing
        mmif.BranchAddr     =   mmif.execute_p.BranchAddr;
        mmif.JumpSel    = mmif.execute_p.JumpSel;
        mmif.JumpAddr   = {mmif.execute_p.NPC[31:28], mmif.execute_p.Instruction[25:0], 2'b00};
        mmif.port_a     = mmif.execute_p.port_a;
        mmif.BranchTaken    = 1'b0;
        if ((mmif.execute_p.BEQ & mmif.execute_p.zero) | (mmif.execute_p.BNE & ~mmif.execute_p.zero))
            mmif.BranchTaken    = 1'b1;
        mmif.branch_mispredict  = (mmif.execute_p.branch_taken != mmif.BranchTaken) && (mmif.execute_p.BEQ | mmif.execute_p.BNE);
        if (mmif.execute_p.branch_taken && 
            mmif.BranchAddr != mmif.execute_p.pred_branch_addr && 
            (mmif.execute_p.BEQ | mmif.execute_p.BNE))
            mmif.branch_mispredict = 1'b1; //if the branch address we predict does not match, flag the mispredict
        mmif.PC     = mmif.execute_p.PC;


            

        //Forwarding Unit signal
        case (mmif.execute_p.MemtoReg)
            2'd0: mmif.forwarding_unit_data = mmif.execute_p.port_o;
            2'd1: mmif.forwarding_unit_data = mmif.execute_p.NPC;
            2'd2: mmif.forwarding_unit_data = 32'd0;
            2'd3: mmif.forwarding_unit_data = mmif.execute_p.Imm_Ext;
        endcase 
    end
  //*******************************************\\
//

endmodule