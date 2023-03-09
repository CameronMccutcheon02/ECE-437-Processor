//Cameron McCutcheon

// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// cpu types
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module icache (
    input logic CLK, nRST,
    datapath_cache_if.cache dcif,
    caches_if cif
);






endmodule
