//Cameron McCutcheon

`include "alu_if.vh"
`include "execute_if.vh"

`include "cpu_types_pkg.vh"
`include "custom_types_pkg.vh"

module forwarding_unit(
    input logic CLK, nRST,
    forwarding_unit_if.fw fwif
);

    //grab all the structs values
    import cpu_types_pkg::*;
    import custom_types_pkg::*;


always_comb begin : Memory_Stage_Hazards
    

end


always_comb begin : Writeback_Stage_Hazards
    

end


endmodule