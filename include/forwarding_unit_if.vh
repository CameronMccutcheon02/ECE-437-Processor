`ifndef FORWARD_UNIT_IF_VH
`define FORWARD_UNIT_IF_VH

`include "forwarding_unit.vh"

interface forwarding_unit_if;
    import cpu_types_pkg::*;


    //decode pipeline struct in (for RS and Rt)
    decode_t decode_p;
    
    word_t Rs_ft; //Rs's
    word_t Rt_dc, Rt_ex, Rt_ft; //Rt's
    word_t Rd_dc, Rd_ex; //Rd's

    logic BEQ, BNE, zero;
    logic [1:0] JumpSel;
    logic BranchTaken;

    modport fw (
        input memread_dc, memread_ex, BranchTaken, JumpSel,
        input Rs_ft, //Rs's
        input Rt_dc, Rt_ex, Rt_ft, //Rt's
        input Rd_dc, Rd_ex, //Rd's
        output flush, freeze
    );

    modport tb (
        input flush, freeze,
        output memread_dc, memread_ex, Rt_dc, Rs_ft, Rt_ft, Rt_ex, BranchTaken, JumpSel
    );

endinterface
`endif