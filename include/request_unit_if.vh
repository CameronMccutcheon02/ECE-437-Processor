`ifndef REQUEST_UNIT_IF_VH
`define REQUEST_UNIT_IF_VH

`include "cpu_types_pkg.vh"

interface request_unit_if;
    import cpu_types_pkg::*;

    logic iREN, dREN, dWEN, ihit, dhit;
    logic imemREN, dmemREN, dmemWEN;
    modport ru (
        input iREN, dREN, dWEN, ihit, dhit,
        output imemREN, dmemREN, dmemWEN
    );
    
    modport tb (
        input imemREN, dmemREN, dmemWEN,
        output iREN, dREN, dWEN, ihit, dhit
    );

endinterface

`endif