//Cameron McCutcheon

`include "alu_if.vh"
`include "execute_if.vh"

`include "cpu_types_pkg.vh"
`include "custom_types_pkg.vh"

module forwarding_unit(
    forwarding_unit_if.fw fwif
);

    //grab all the structs values
    import cpu_types_pkg::*;
    import custom_types_pkg::*;


always_comb begin 
    
    fwif.port_a_control = 2'd0; //default case, use the inputs from the register file
    fwif.port_b_control = 2'd0; 

    //Rs checking
    //execute level checking
    if (fwif.Rs_dc == fwif.Rw_ex && fwif.Rw_ex != 0)
        fwif.port_a_control = 2'd1; //Port A uses output of past output of execute stage
    //Memory Level checking
    else if (fwif.Rs_dc == fwif.Rw_wb && fwif.Rw_wb != 0)
        fwif.port_a_control = 2'd2; //Port A uses output of past output of memory stage


    //Rt Checking
    if (fwif.Rt_dc == fwif.Rw_ex && fwif.Rw_ex != 0)
        fwif.port_b_control = 2'd1; //Port A uses output of past output of execute stage
    //Memory Level checking
    else if (fwif.Rt_dc == fwif.Rw_wb && fwif.Rw_wb != 0)
        fwif.port_b_control = 2'd2; //Port A uses output of past output of memory stage


    fwif.execute_data_out = fwif.execute_data_in;
    fwif.writeback_data_out = fwif.writeback_data_in;
    
end


endmodule