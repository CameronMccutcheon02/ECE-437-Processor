/*
  Cameron McCutcheon

  control unit decode block
*/
`include "cpu_types_pkg.vh"
`include "request_unit_if.vh"
import cpu_types_pkg::*;

module request_unit(
    input logic CLK, nRST,
    request_unit_if.RU ruif

);

logic dmemREN, dmemWEN, stall;

always_ff @(posedge CLK, negedge nRST) begin
  if(!nRST) begin
    ruif.dmemREN <= 0;
    ruif.dmemWEN <= 0;
    //ruif.stall <= 0;

  end
  else if (ruif.dhit) begin
    ruif.dmemREN  <= 0;
    ruif.dmemWEN  <= 0;
    //ruif.stall    <= stall;
  end
  else if (ruif.ihit) begin
    ruif.dmemREN <= ruif.MemRead;
    ruif.dmemWEN <= ruif.MemWrite;
  end
  else begin
    ruif.dmemREN <= ruif.dmemREN;
    ruif.dmemWEN <= ruif.dmemWEN;
  end
end

always_comb begin
    ruif.imemREN = 1;

    ruif.dmemaddr   = ruif.port_o;
    ruif.dmemstore  = ruif.port_b;
    ruif.imemaddr   = ruif.pc;

    //ruif.imemREN    = ~(ruif.dmemREN || ruif.dmemWEN); //Definitely gonna need to change this

    //ruif.stall      = (ruif.imemREN && ruif.ihit) || 
                        //((ruif.dmemREN || ruif.dmemWEN) && ruif.dhit);


    ruif.instr_op   = opcode_t'(ruif.imemload[31:26]);
    ruif.funct_op   = funct_t'(ruif.imemload[5:0]);
    ruif.imem       = ruif.imemload;
    ruif.dmem       = ruif.dmemload;
end

endmodule