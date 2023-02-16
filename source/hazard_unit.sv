`include "hazard_unit_if.vh"

module hazard_unit (
    hazard_unit_if.hu huif
);
    always_comb begin: Ld_use_Hazard_Logic
        huif.flush = 2'b00;
        huif.freeze = 1'b0;
        if (huif.memread_dc) begin
            if ((huif.Rt_dc == huif.Rs_ft) | (huif.Rt_dc == huif.Rt_ft)) begin
                huif.flush = 2'b10; // flush only the decode/execute latch
                huif.freeze = 1'b1; // stall pc and fetch/decode latch
            end
        end
    end

    always_comb begin: Branch_Hazard_Logic
        
    end
endmodule