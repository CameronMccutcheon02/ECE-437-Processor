`include "hazard_unit_if.vh"

module hazard_unit (
    hazard_unit_if.hu huif
);
    always_comb begin: Ld_use_Hazard_Logic
        huif.freeze = 2'b0;
        huif.flush = 1'b0;
        if (huif.memread_de) begin
            if ((huif.Rt_de == huif.Rs_fd) | (huif.Rt_de == huif.Rt_fd)) begin
                huif.freeze = 1'b1;
                huif.flush = 1'b1;
            end
        end
    end

    always_comb begin: Branch_Hazard_Logic
        
    end
endmodule