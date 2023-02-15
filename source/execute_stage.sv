//Cameron McCutcheon

`include "alu_if.vh"
`include "execute_if.vh"

`include "cpu_types_pkg.vh"
`include "custom_types_pkg.vh"

module execute_stage(
    input logic CLK, nRST
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
            void`(exif.execute_p);
        else if (exif.flush)
            void`(exif.execute_p);
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
        aluif.porta = exif.decode_p.port_a;
        if (~exif.decode_p.ALUSrc)
            aluif.portb = exif.decode_p.port_b;
        else 
            aluif.portb = exif.decode_p.Imm_Ext;
    end
  //*******************************************\\
//

//Block output signal routings
  //*******************************************\\
    always_comb begin
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
        execute.port_a = exif.decode_p.port_a;
        execute.port_b = exif.decode_p.port_b;
        execute.Imm_Ext = exif.decode_p.Imm_Ext;
    end
  //*******************************************\\
//

endmodule