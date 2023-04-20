`include "hazard_unit_if.vh"
`include "custom_types_pkg.vh"

import custom_types_pkg::*;

module hazard_unit (
    hazard_unit_if.hu huif
);

    always_comb begin: Ld_use_Hazard_Logic
        huif.flush = 4'b0;
        huif.freeze = 4'b0;
        // if (huif.memread_ex) begin // remove for forwarding
        //     if ((huif.Rt_ex == huif.Rs_ft) | (huif.Rt_ex == huif.Rt_ft)) begin // rt in mem == rs or rt in fetch 
        //         huif.flush = 4'b0100; // flush decode/execute latch if load dependency
        //         huif.freeze = 4'b1000; // freeze pc and fetch/decode latch if load dependency
        //     end
        // end
        if (huif.JumpSel == 2'b0 & huif.branch_mispredict)
            huif.flush = 4'b1110; // flush fetch/decode latch if branch taken
        else if (huif.JumpSel == 2'd1 | huif.JumpSel == 2'd2)
            huif.flush = 4'b1110; // flush fetch/decode latch if jump

        else if (huif.memread_ex || huif.memwrite_ex) begin
            huif.freeze = 4'b1111; //if we are actively reading or writing
            //we freeze our stages until the dhit signal pulls these two back to low
        end

        else if (huif.memread_dc | (huif.memwrite_dc & huif.mematomic_dc)) begin //read-use case
            if ((huif.Rt_dc == huif.Rs_ft) | (huif.Rt_dc == huif.Rt_ft)) begin
                huif.flush = 4'b0100; // flush decode/execute latch if load dependency
                huif.freeze = 4'b1000; // freeze pc and fetch/decode latch if load dependency
            end
        end

        else if(huif.halt) begin
            huif.flush = 4'b1100; // flush decode/execute latch if load dependency
            huif.freeze = 4'b1111; // freeze pc and fetch
        end

        // // remove for forwarding
        // if ((huif.Rs_ft == huif.Rd_dc & huif.Rd_dc != 0) |
        //     (huif.Rs_ft == huif.Rt_dc & huif.Rt_dc != 0) |
        //     (huif.Rt_ft == huif.Rd_dc & huif.Rd_dc != 0) |
        //     (huif.Rt_ft == huif.Rt_dc & huif.Rt_dc != 0) |

        //     (huif.Rs_ft == huif.Rd_ex & huif.Rd_ex != 0) |
        //     (huif.Rs_ft == huif.Rt_ex & huif.Rt_ex != 0)|
        //     (huif.Rt_ft == huif.Rd_ex & huif.Rd_ex != 0) |
        //     (huif.Rt_ft == huif.Rt_ex & huif.Rt_ex != 0)
        //     )begin
        //             huif.freeze = 4'b1000;
        //             huif.flush = 4'b0100;
        //     end
    end
endmodule