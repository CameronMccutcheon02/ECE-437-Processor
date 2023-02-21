//Cameron McCutcheon

`include "program_counter_if.vh"
`include "fetch_if.vh"

`include "cpu_types_pkg.vh"
`include "custom_types_pkg.vh"

module fetch_stage(
    input logic CLK, nRST,
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
            ftif.fetch_p <= '0;
        else if (ftif.flush)
            ftif.fetch_p <= '0;
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
        if (ftif.BranchTaken)
            BranchAddr = ftif.BranchAddr;
        else
            BranchAddr = pcif.PC + 32'd4;
    end

    always_comb begin: Program_Counter_Logic
        case (ftif.JumpSel)
            2'd0: pcif.next_PC = BranchAddr;
            2'd1: pcif.next_PC = ftif.JumpAddr;
            2'd2: pcif.next_PC = ftif.port_a;
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
        fetch.NPC = pcif.next_PC;
        fetch.PC = pcif.PC; //Cam- for branch predictor table
        
        // Output to datapath-cache interface
        ftif.imemREN = 1'b1; 
        ftif.imemaddr = pcif.PC; //NICK
    end
  //*******************************************\\
//

//Branch Predictor Stuff

//

endmodule