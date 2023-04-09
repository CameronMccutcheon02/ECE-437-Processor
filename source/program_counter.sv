`include "program_counter_if.vh"
`include "cpu_types_pkg.vh"

module program_counter (
    input CLK, nRST,
    program_counter_if.pc pcif
);

    parameter PC_INIT = 0;

    import cpu_types_pkg::*;

    always_ff @(posedge CLK, negedge nRST) begin: PC_Logic
        if (~nRST)
            pcif.PC <= PC_INIT;
        else begin
            if (pcif.EN)
                pcif.PC <= pcif.next_PC;
            else
                pcif.PC <= pcif.PC;
        end
    end
endmodule