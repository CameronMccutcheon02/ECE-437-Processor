`include "hazard_unit_if.vh"
`include "custom_types_pkg.vh"

import custom_types_pkg::*;

module hazard_unit (
    hazard_unit_if.hu huif
);

    always_comb begin: Ld_use_Hazard_Logic
        huif.flush = 4'b0;
        huif.freeze = 4'b0;
        if (huif.memread_dc) begin
            if ((huif.Rt_dc == huif.Rs_ft) | (huif.Rt_dc == huif.Rt_ft)) begin
                huif.flush = 4'b0100; // flush decode/execute latch if load dependency
                huif.freeze = 4'b1000; // freeze pc and fetch/decode latch if load dependency
            end
        end
        if ((huif.JumpSel == 2'b0) & ((huif.BEQ & huif.equal) | (huif.BNE & ~huif.equal)))
            huif.flush = 4'b1100; // flush decode/execute latch if branch taken
        if (huif.JumpSel == 2'd1 | huif.JumpSel == 2'd2)
            huif.flush = 4'b1100; // flush decode/exectute latch if jump
    end
endmodule