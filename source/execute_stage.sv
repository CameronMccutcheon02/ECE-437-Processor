//Cameron McCutcheon

`include "alu_if.vh"
`include "execute_if.vh"

`include "cpu_types_pkg.vh"
`include "custom_types_pkg.vh"

module execute_stage(
    input logic CLK, nRST,
    execute_if.EX exif
);

    //grab all the structs values
    import cpu_types_pkg::*;
    import custom_types_pkg::*;

    // initialize structs
    execute_t execute;

    // initialize interfaces
    alu_if aluif();

    // initialize DUTs
    alu ALU(aluif);

    always_ff @(posedge CLK, negedge nRST) begin: PipelineLatching
        if (~nRST)
            exif.execute_p <= '0;
        else if (exif.flush | exif.dhit)
            exif.execute_p <= '0;
        else if (exif.freeze)
            exif.execute_p <= exif.execute_p;
        else if (exif.ihit)
            exif.execute_p <= execute;
        else 
            exif.execute_p <= exif.execute_p;
    end

//ALU
  //*******************************************\\
    always_comb begin: ALU_Logic
        aluif.ALUOP = exif.decode_p.ALUctr;
        aluif.porta = (exif.port_a_forwarding_control == 2'd0) ? exif.decode_p.port_a :
                        (exif.port_a_forwarding_control == 2'd1) ? exif.FW_execute_data : 
                        (exif.port_a_forwarding_control == 2'd2) ? exif.FW_writeback_data : exif.decode_p.port_a;



        if (~exif.decode_p.ALUSrc)
            aluif.portb = (exif.port_b_forwarding_control == 2'd0) ? exif.decode_p.port_b :
                            (exif.port_b_forwarding_control == 2'd1) ? exif.FW_execute_data : 
                            (exif.port_b_forwarding_control == 2'd2) ? exif.FW_writeback_data : exif.decode_p.port_b;
        else 
            aluif.portb = exif.decode_p.Imm_Ext; //always give priority to sign extended over forwarding unit
    end
  //*******************************************\\
//

//Block output signal routings
  //*******************************************\\
    always_comb begin
        //Hazard unit/Forwarding unit stuffs
		// execute.Rt = exif.decode_p.Rt;
		// execute.Rd = exif.decode_p.Rd;

        //Mem Layer
        execute.dREN = exif.decode_p.dREN;
        execute.dWEN = exif.decode_p.dWEN;
        execute.BEQ = exif.decode_p.BEQ;
        execute.BNE = exif.decode_p.BNE;
        execute.JumpSel = exif.decode_p.JumpSel;
        execute.JumpAddr = exif.decode_p.JumpAddr;
        execute.zero = aluif.zero;

        //WB Layer
        execute.Rw = exif.decode_p.Rw;
        execute.RegWEN = exif.decode_p.RegWEN;
        execute.MemtoReg = exif.decode_p.MemtoReg;
        execute.halt = exif.decode_p.halt;
        execute.NPC = exif.decode_p.NPC;
        
        //data signals
        execute.port_o = aluif.oport;
        execute.port_a = (exif.port_a_forwarding_control == 2'd0) ? exif.decode_p.port_a :
                            (exif.port_a_forwarding_control == 2'd1) ? exif.FW_execute_data : 
                            (exif.port_a_forwarding_control == 2'd2) ? exif.FW_writeback_data : exif.decode_p.port_a;

        execute.port_b =    (exif.port_b_forwarding_control == 2'd0) ? exif.decode_p.port_b :
                            (exif.port_b_forwarding_control == 2'd1) ? exif.FW_execute_data : 
                            (exif.port_b_forwarding_control == 2'd2) ? exif.FW_writeback_data : exif.decode_p.port_b;
        execute.Imm_Ext = exif.decode_p.Imm_Ext;
    end
  //*******************************************\\
//

endmodule