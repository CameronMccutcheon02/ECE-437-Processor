`include "request_unit_if.vh"
`include "cpu_types_pkg.vh"

module request_unit (
    input CLK, nRST,
    request_unit_if.ru ruif
);

    always_ff @(posedge CLK, negedge nRST) begin: Request_Unit_Logic
        if (~nRST) begin
            ruif.dmemREN <= 1'b0;
            ruif.dmemWEN <= 1'b0;
        end else if (ruif.dhit) begin // deassert dmem access once complete
            ruif.dmemREN <= 1'b0;
            ruif.dmemWEN <= 1'b0;
        end else if (ruif.ihit) begin
            ruif.dmemREN <= ruif.dREN;
            ruif.dmemWEN <= ruif.dWEN;
        end else begin
            ruif.dmemREN <= ruif.dmemREN;
            ruif.dmemWEN <= ruif.dmemWEN;
        end
    end

endmodule