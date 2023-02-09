`include "register_file_if.vh"
`include "cpu_types_pkg.vh"

module register_file (
    input logic CLK,
    input logic nRST,
    register_file_if.rf rfif    
);

    import cpu_types_pkg::*;

    word_t registers [31:0];

    always_ff @(negedge CLK, negedge nRST) begin: Reg_Write_Logic
        // initialize regs to 0s
        if (~nRST)
            registers <= '{default:'0};
        // only write data to a reg if its not reg0
        else if (rfif.WEN)
            if (rfif.wsel != 5'b0)
                registers[rfif.wsel] <= rfif.wdat;
    end

    always_comb begin: Reg_Read_Logic
        // read selected regs
        rfif.rdat1 = registers[rfif.rsel1];
        rfif.rdat2 = registers[rfif.rsel2];
    end

endmodule