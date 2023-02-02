/*
  Cameron McCutcheon

  ALU test bench
*/

// mapped needs this
`include "cache_control_if.vh"
`include "caches_if.vh"
`include "cpu_ram_if.vh"

import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`ifdef MAPPED
`timescale 1 ns / 1 ns
`endif

`timescale 1 ns / 10 ps

module memory_control_tb;

    parameter PERIOD = 10;

    logic CLK = 0, nRST; //Technically don't need the clock, but we can use it to regularly space out stuff

    // clock
    always #(PERIOD/2) CLK++;

    //declare a caches_if here to be used at input point
    caches_if cif0(); //This is the one which we drive to send inputs to the memory control/ram
    caches_if cif1();
    //Declare CPU interface for ram side
    cpu_ram_if ramif();

    // interface
    cache_control_if #(.CPUS(1)) ccif(cif0, cif1);
    //connect ram_if to memory control_if
    assign ramif.ramaddr = ccif.ramaddr; //inputs for ramif, outputs for ccif
    assign ramif.ramstore = ccif.ramstore;
    assign ramif.ramREN = ccif.ramREN;
    assign ramif.ramWEN = ccif.ramWEN;

    assign ccif.ramstate = ramif.ramstate; //driven by ram
    assign ccif.ramload = ramif.ramload;



    // test program
    test PROG (.CLK(CLK), .nRST(nRST), .cif0(cif0));
    // DUT
    `ifndef MAPPED
    memory_control DUT1(.CLK(CLK), .nRST(nRST), .ccif(ccif));
    ram DUT2(.CLK(CLK), .nRST(nRST), .ramif(ramif));
    `else
    memory_control DUT3(
        .\CLK         (CLK),
        .\nRST        (nRST),
        .\ccif.iREN   (ccif.iREN),
        .\ccif.dREN   (ccif.dREN),
        .\ccif.dWEN   (ccif.dWEN),
        .\ccif.dstore (ccif.dstore),
        .\ccif.iaddr  (ccif.iaddr),
        .\ccif.daddr  (ccif.daddr),
        .\ccif.ramload(ccif.ramload),
        .\ccif.ramstore(ccif.ramstore),

    );
    ram DUT4(sadfsdafsdafsdfa


    );
    `endif


endmodule


program test (
  input logic CLK,
  
  output logic nRST,
  caches_if.caches cif0 //memory cache to controller, we only need one here because the other isn't used in lab 3

);

parameter PERIOD = 10;
string tb_test_case;
integer tb_test_case_num;
logic tb_mismatch, tb_check;

task reset_dut;
  begin
    automatic string temp = tb_test_case;
    tb_test_case = "Reset";
    // Activate the reset
    nRST = 1'b0;

    // Maintain the reset for more than one cycle
    @(posedge CLK);
    @(posedge CLK);

    // Wait until safely away from rising edge of the clock before releasing
    @(negedge CLK);
    nRST = 1'b1;

    // Leave out of reset for a couple cycles before allowing other stimulus
    // Wait for negative clock edges, 
    // since inputs to DUT should normally be applied away from rising clock edges
    @(negedge CLK);
    @(negedge CLK);
    @(posedge CLK);
    tb_test_case = temp;
  end
endtask


task automatic dump_memory();
    string temp = tb_test_case;
    string filename = "memcpu.hex";
    int memfd;


    cif0.daddr = 0;
    cif0.dWEN = 0;
    cif0.dREN = 0;

    memfd = $fopen(filename,"w");
    if (memfd)
      begin $display("Starting memory dump."); tb_test_case = "Mem Dump"; end
    else
      begin $display("Failed to open %s.",filename); $finish; end

    for (int unsigned i = 0; memfd && i < 16384; i++)
    begin
      int chksum = 0;
      bit [7:0][7:0] values;
      string ihex;

      cif0.daddr = i << 2;
      cif0.dREN = 1; 
      repeat (4) @(posedge CLK);

      while(cif0.dwait) @(posedge CLK);//wait for dwait to be pulled low
      @(posedge CLK)

      if (cif0.dload === 0)
        continue;

      values = {8'h04,16'(i),8'h00,cif0.dload};
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),cif0.dload,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
    end //for
    if (memfd)
    begin
      cif0.dREN = 0;
      $fdisplay(memfd,":00000001FF");
      $fclose(memfd);
      $display("Finished memory dump.");
    end
    tb_test_case = temp;
  endtask



task display_test_banner; 
begin
  $display("//***********************************************************************\\");
  $display("Test case %d: ", tb_test_case_num, tb_test_case);
  $display("//***********************************************************************\\");
end
endtask

//***********************************************************************\\
//Test 1- Reset Test
//***********************************************************************\\

initial begin
    tb_test_case = "Reset Case";
    tb_test_case_num = 1;
    display_test_banner();
    //reset_dut();

//***********************************************************************\\
//Test 2- dWEN 
//***********************************************************************\\

  tb_test_case = "dWEN";
    tb_test_case_num = tb_test_case_num +1;
    display_test_banner();
    reset_dut();


    //dump_memory();

    
    for (int unsigned i = 0; i < 20; i++) begin
      cif0.dstore = i+1;
      cif0.dWEN = 1;
      cif0.daddr = i*4;
      //if (cif0.dwait == 0)
        //  continue;
      @(negedge CLK);
      while(ccif.dwait == 1) begin 
        @(negedge CLK);
      end
      @(posedge CLK);
    end

  cif0.dWEN = 0;
  //dump_memory();



//***********************************************************************\\
//Test 3- dREN
//***********************************************************************\\
tb_test_case = "dREN";
    tb_test_case_num = tb_test_case_num +1;
    display_test_banner();
    reset_dut();
    
    for (int unsigned i = 0; i < 20; i++) begin
      cif0.dREN = 1;
      cif0.daddr = i*4;
      @(negedge CLK)
      while(ccif.dwait == 1) begin 
        @(negedge CLK);
      end
      @(posedge CLK);
    end

  cif0.dREN = 0;


//***********************************************************************\\
//Test 4- iREN
//***********************************************************************\\
tb_test_case = "iREN";
    tb_test_case_num = tb_test_case_num +1;
    display_test_banner();
    reset_dut();
    
    for (int unsigned i = 60; i < 63; i++) begin
      cif0.iREN = 1;
      cif0.iaddr = i*4;
      @(negedge CLK)
      while(ccif.iwait == 1) begin 
        @(negedge CLK);
      end
      @(posedge CLK);
    end

  cif0.iREN = 0;

//***********************************************************************\\
//Test 5- iREN + dREN
//***********************************************************************\\
tb_test_case = "iREN + dREN";
    tb_test_case_num = tb_test_case_num +1;
    display_test_banner();
    reset_dut();
    
    for (int unsigned i = 60; i < 63; i++) begin
      cif0.iREN = 1;
      cif0.dREN = 1;
      cif0.iaddr = 4;
      cif0.daddr = i *4;
      @(negedge CLK)
      while(ccif.iwait == 1 && ccif.dwait == 1) begin 
        @(negedge CLK);
      end
      @(posedge CLK);
    end

  cif0.iREN = 0;
  cif0.dREN = 0;


dump_memory();
  

end
endprogram
