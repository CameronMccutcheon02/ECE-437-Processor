//Cameron McCutcheon

`include "program_counter_if.vh"
`include "fetch_if.vh"

`include "cpu_types_pkg.vh"
`include "custom_types_pkg.vh"

module fetch_stage(
    input logic CLK, nRST
    fetch_if.FT ftif
);

    //grab all the structs values
    import cpu_types_pkg::*;
    import custom_types_pkg::*;

    // initialize structs
    fetch_t fetch;

    // initialize interfaces
    program_counter_if pcif();

    // initialize DUTs
    program_counter PC(CLK, nRST, pcif);

    // declare local variables
    word_t BranchAddr;

    always_ff @(posedge CLK, negedge nRST) begin: PipelineLatching
        if (~nRST)
            void`(ftif.fetch_p);
        else if (ftif.flush)
            void`(ftif.fetch_p);
        else if (ftif.freeze)
            ftif.fetch_p <= ftif.fetch_p;
        else if (ftif.ihit)
            ftif.fetch_p <= fetch;
        else 
            ftif.fetch_p <= ftif.fetch_p;
    end

// Internal fetch logic
  //*******************************************\\
    always_comb begin: Local_Signals_Logic
        if ((ftif.execute_p.BEQ & ftif.execute_p.zero) | (ftif.execute_p.BNE & ~ftif.execute_p.zero)))
            BranchAddr = (ftif.execute_p.NPC + {ftif.execute_p.Imm_Ext[29:0], 2'b00});
        else
            BranchAddr = pcif.PC + 32'd4;
    end

    always_comb begin: Program_Counter_Logic
        case (ftif.execute_p.JumpSel)
            2'd0: pcif.next_PC = BranchAddr;
            2'd1: pcif.next_PC = ftif.execute_p.JumpAddr;
            2'd2: pcif.next_PC = ftif.execute_p.port_a;
            default: pcif.next_PC = BranchAddr;
        endcase
        pcif.EN = ftif.ihit & ~ftif.dhit & ~ftif.freeze;
    end
  //*******************************************\\
//

// Block output signal routings
  //*******************************************\\
    always_comb begin
        // Fetch stage outputs
        fetch.imemload = ftif.imemload;
        fetch.NPC = picf.next_PC;
        
        // Output to datapath-cache interface
        ftif.imemREN = 1'b1; 
        ftif.imemaddr = pcif.PC; //NICK
    end
  //*******************************************\\
//

endmodule