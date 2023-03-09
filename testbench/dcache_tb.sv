/*
  Cameron McCutcheon

  Dcache test bench
*/

`include "datapath_cache_if.vh"

import cpu_types_pkg::*;

// mapped timing needs this. 1ns is too fast
`ifdef MAPPED
`timescale 1 ns / 1 ns
`endif


module dcache_tb;
    parameter PERIOD = 10;

    logic CLK = 0, nRST; //Technically don't need the clock, but we can use it to regularly space out stuff

    // clock
    always #(PERIOD/2) CLK++;

    datapath_cache_if dcif();
    caches_if cif();
    
    dcache DUT(.CLK(CLK), .nRST(nRST), .dcif(dcif), .cif(cif));

    test PROG(.CLK(CLK), .nRST(nRST), .dcif(dcif), .cif(cif));


endmodule



program test (
  input logic CLK,
  
  output logic nRST,
  datapath_cache_if.dcache dcif, //memory cache to controller, we only need one here because the other isn't used in lab 3
  caches_if.dcache cif

);

parameter PERIOD = 10;
string tb_test_case;
integer tb_test_case_num;
logic tb_mismatch, tb_check;

localparam ASCT = 2; //sets associativity constant
localparam BLKSZ = 2; //sets number of data words per block
localparam TGSZ = 26; //sets tag size
localparam CCSZ = 8; //Sets number of cache rows

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

task set_to_idle;
  begin
    dcif.halt = 0;
    dcif.dmemREN = 0;
    dcif.dmemWEN = 0;
    dcif.dmemstore = 0;
    dcif.dmemaddr = 0;

    cif.dwait = 0;
    cif.dload = 0;

    @(posedge CLK);
  end
endtask


task display_test_banner; 
begin
  $display("//***********************************************************************\\");
  $display("Test case %d: ", tb_test_case_num, tb_test_case);
  $display("//***********************************************************************\\");
end
endtask

task read_transaction (
  input logic [25:0] datapath_tag,
  input logic [2:0] datapath_index,
  input logic datapath_block_offset,
  input word_t mem_data [1:0],
  input word_t exp_data
  );//data coming from memory if we get a miss
  begin
    @(posedge CLK);
    dcif.dmemREN = 1;
    dcif.dmemaddr = {datapath_tag, datapath_index, datapath_block_offset, 2'b00};
    @(posedge CLK); //transition to write or read state

    if(~dcif.dhit) begin//if we miss, load blocks from memory
      case(cif.dREN)
        1: begin for (int i = 0; i < 2; i++) begin
            cif.dwait = 1;
            cif.dload = mem_data[i];
            repeat(10)
              @(posedge CLK);
            cif.dwait = 0;
            @(posedge CLK);
          end
        end
        0: begin for (int i = 4; i > 0; i--) begin
            cif.dwait = 1;
            if (i <= 2) cif.dload = mem_data[2-i];
            repeat(10)
              @(posedge CLK);
            cif.dwait = 0;
            @(posedge CLK);
          end
        end
      endcase
      @(posedge CLK); //Let the state machine go back to IDLE so that we can read
    end
  
  check_outputs("test", exp_data);
  @(posedge CLK); //Once read is finished, set the REN low again
  dcif.dmemREN = 0;
  set_to_idle();
  end
endtask

task write_transaction (
  input logic [25:0] datapath_tag,
  input logic [2:0] datapath_index,
  input logic datapath_block_offset,
  input word_t mem_data [1:0],
  input word_t send_data,
  input word_t exp_data
  );//data coming from memory if we get a miss
  begin
    @(posedge CLK);
    dcif.dmemWEN = 1;
    dcif.dmemaddr = {datapath_tag, datapath_index, datapath_block_offset, 2'b00};
    dcif.dmemstore = send_data;
    @(posedge CLK); //transition to write or read state

    if(~dcif.dhit) begin//if we miss, load blocks from memory first
      case(cif.dREN)
        1: begin for (int i = 0; i < 2; i++) begin
            cif.dwait = 1;
            cif.dload = mem_data[i];
            repeat(10)
              @(posedge CLK);
            cif.dwait = 0;
            @(posedge CLK);
          end
        end
        0: begin for (int i = 4; i > 0; i--) begin
            cif.dwait = 1;
            if (i <= 2) cif.dload = mem_data[2-i];
            repeat(10)
              @(posedge CLK);
            cif.dwait = 0;
            @(posedge CLK);
          end
        end
      endcase
      @(posedge CLK); //Let the state machine go back to IDLE so that we can write
    end

  
  @(posedge CLK); //value in cache should now be updated
  //check_outputs("test", exp_data);

  end
endtask


task check_outputs;
  input string test_case;
  input word_t exp_data;
begin
  assert (exp_data == dcif.dmemload)
    $display("PASSED: %s", test_case);
  else $display("FAILED: %s", test_case);
end
endtask
//*******************************************************************\\
//ACTUAL TEST CASES BELOW HERE
//*******************************************************************\\
word_t mem_data [1:0];
word_t send_data;
logic [TGSZ-1:0] datapath_tag;
initial begin

  // ************************************************************************
  // Test Case 0: Simple Read and fill of cache
  // ************************************************************************
  tb_test_case = "Test Case 1";
  set_to_idle();
  reset_dut();
  @(posedge CLK);
  mem_data[0] = 42; 
  mem_data[1] = 69;
  datapath_tag = 69;
  read_transaction(.datapath_tag(datapath_tag), .datapath_index(0), .datapath_block_offset(0), .mem_data(mem_data), .exp_data(mem_data[0]));
  @(posedge CLK);
  @(posedge CLK);

  // ************************************************************************
  // Test Case 1: Simple Read followed by write
  // ************************************************************************
  tb_test_case = "Test Case 2";
  set_to_idle();
  reset_dut();
  @(posedge CLK);
  mem_data[0] = 42; 
  mem_data[1] = 69;
  datapath_tag = 69;
  send_data = 17;
  read_transaction(.datapath_tag(datapath_tag), .datapath_index(0), .datapath_block_offset(0), .mem_data(mem_data), .exp_data(mem_data[0]));
  set_to_idle();

  write_transaction(.datapath_tag(datapath_tag), .datapath_index(0), .datapath_block_offset(0), 
  .mem_data(mem_data), .exp_data(mem_data[0]),
  .send_data(send_data));
  set_to_idle();

  read_transaction(.datapath_tag(datapath_tag), .datapath_index(0), .datapath_block_offset(0), .mem_data(mem_data), .exp_data(send_data));
  //Data should be in the cache here,



  // ************************************************************************
  // Test Case 3: LRU Priority and Eviction Test
  // ************************************************************************
  tb_test_case = "Test Case 3";
  set_to_idle();
  reset_dut();
  @(posedge CLK);
  mem_data[0] = 42; 
  mem_data[1] = 69;
  datapath_tag = 69;
  read_transaction(.datapath_tag(datapath_tag), .datapath_index(0), .datapath_block_offset(0), .mem_data(mem_data), .exp_data(mem_data[0]));
  @(posedge CLK);
  @(posedge CLK);
  mem_data[0] = 29; 
  mem_data[1] = 30;
  datapath_tag = 12;
  read_transaction(.datapath_tag(datapath_tag), .datapath_index(0), .datapath_block_offset(0), .mem_data(mem_data), .exp_data(mem_data[0]));
  @(posedge CLK);
  @(posedge CLK);
  mem_data[0] = 20; 
  mem_data[1] = 21;
  datapath_tag = 19;
  read_transaction(.datapath_tag(datapath_tag), .datapath_index(0), .datapath_block_offset(0), .mem_data(mem_data), .exp_data(mem_data[0]));


  // ************************************************************************
  // Test Case 4: Eviction Writeback Test
  // ************************************************************************
  tb_test_case = "Test Case 4";
  set_to_idle();
  reset_dut();
  @(posedge CLK);
  //Read into the first memory
  mem_data[0] = 42; 
  mem_data[1] = 69;
  datapath_tag = 69;
  read_transaction(.datapath_tag(datapath_tag), .datapath_index(0), .datapath_block_offset(0), .mem_data(mem_data), .exp_data(mem_data[0]));

  //Read into the second memory
  @(posedge CLK);
  @(posedge CLK);
  mem_data[0] = 29; 
  mem_data[1] = 30;
  datapath_tag = 12;
  read_transaction(.datapath_tag(datapath_tag), .datapath_index(0), .datapath_block_offset(0), .mem_data(mem_data), .exp_data(mem_data[0]));

  //Write to second Memory (dirty should now be high)
  write_transaction(.datapath_tag(datapath_tag), .datapath_index(0), .datapath_block_offset(0), 
  .mem_data(mem_data), .exp_data(mem_data[0]),
  .send_data(send_data));
  set_to_idle();

  //first mem will be LRU, so read from first memory to make sure 2nd will be evicted
  //Read into the first memory
  mem_data[0] = 42; 
  mem_data[1] = 69;
  datapath_tag = 69;
  read_transaction(.datapath_tag(datapath_tag), .datapath_index(0), .datapath_block_offset(0), .mem_data(mem_data), .exp_data(mem_data[0]));


  @(posedge CLK);
  @(posedge CLK);
  mem_data[0] = 20; 
  mem_data[1] = 21;
  datapath_tag = 19;
  read_transaction(.datapath_tag(datapath_tag), .datapath_index(0), .datapath_block_offset(0), .mem_data(mem_data), .exp_data(mem_data[0]));

  $finish();  
    
end
endprogram