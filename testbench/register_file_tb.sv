/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "register_file_if.vh"

// mapped timing needs this. 1ns is too fast
`ifdef MAPPED
`timescale 1 ns / 1 ns
`endif

`timescale 1 ns / 10 ps

module register_file_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  register_file_if rfif ();
  // test program
  test PROG (.CLK(CLK), .nRST(nRST), .tbif(rfif));
  // DUT
`ifndef MAPPED
  register_file DUT(CLK, nRST, rfif);
`else
  register_file DUT(
    .\rfif.rdat2 (rfif.rdat2),
    .\rfif.rdat1 (rfif.rdat1),
    .\rfif.wdat (rfif.wdat),
    .\rfif.rsel2 (rfif.rsel2),
    .\rfif.rsel1 (rfif.rsel1),
    .\rfif.wsel (rfif.wsel),
    .\rfif.WEN (rfif.WEN),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif


endmodule


program test (
  input logic CLK,
  
  output logic nRST,
  register_file_if.tb tbif

);

parameter PERIOD = 10;
string tb_test_case;
integer tb_test_case_num;
logic tb_mismatch, tb_check;
task reset_dut;
  begin
    // Activate the reset
    tbif.WEN = 0;
    tbif.wsel =0;
    tbif.rsel1 = 0;
    tbif.rsel2 = 0;
    tbif.wdat = 0;
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
  end
endtask

task check_outputs;
  input real expected_r1, expected_r2;
begin
  #(0.1);
  tb_mismatch = 0;
  tb_check = 1;
  if(expected_r1 == rfif.rdat1) begin // Check passed
    $info("Correct 'r1' output %s during %s test case", tb_test_case, tb_test_case_num);
  end
  else begin // Check failed
    tb_mismatch = 1;
    $error("Incorrect 'r1' output %s during %s test case", tb_test_case, tb_test_case_num);
  end

  if(expected_r2 == rfif.rdat2) begin // Check passed
    $info("Correct 'r2' output %s during %s test case", tb_test_case, tb_test_case_num);
  end
  else begin // Check failed
    tb_mismatch = 1;
    $error("Incorrect 'r2' output %s during %s test case", tb_test_case, tb_test_case_num);
  end
  #(0.1);
  tb_check = 0;
end
endtask


task read_write_reg;
  input logic WEN;
  input integer write_reg_num;
  input real write_data;
  input integer read_reg_num_1, read_reg_num_2;
  input real expected_r1, expected_r2;
begin
  @(negedge CLK);
  //Write Section
  tbif.wdat = write_data;
  tbif.WEN = WEN;
  tbif.wsel = write_reg_num;

  tbif.rsel1 = read_reg_num_1;
  tbif.rsel2 = read_reg_num_2;

  @(posedge CLK);
  #(PERIOD*0.1);
  check_outputs(expected_r1, expected_r2);

end

endtask


//int data[int];

//***********************************************************************\\
//Test 1- Reset Test
//***********************************************************************\\

initial begin
  tb_test_case = "Reset Case";
  tb_test_case_num = 1;
reset_dut();

//Check that all the outputs are correct


  for (integer i = 0; i < 32; i++) begin
    read_write_reg(0,0,0,i,i,0,0);

  end
//***********************************************************************\\
//Test 2- Standard Test
//***********************************************************************\\
tb_test_case = "Standard Test Case";
tb_test_case_num = tb_test_case_num + 1;
reset_dut();
  
//Check that all the outputs are correct
//Lets set all the registers to have values from 0 to 31
  for (integer i = 1; i < 32; i++) begin
    read_write_reg(1,i,i,i-1,0,i-1,0);

  end


//***********************************************************************\\
//Test 3- Write Large Values test
//***********************************************************************\\
tb_test_case = "Large Values";
tb_test_case_num = tb_test_case_num + 1;
reset_dut();
//Check that all the outputs are correct
//Lets set all the registers to have values from 0 to 31
  for (integer i = 1; i < 32; i++) begin
    read_write_reg( .WEN(1),
                    .write_reg_num(i),
                    .write_data(2147483647), //INT max positive value
                    .read_reg_num_1(i-1),
                    .read_reg_num_2(0),
                    .expected_r1(2147483647),
                    .expected_r2(0)
                    );

  end


//***********************************************************************\\
//Test 4- Write to 0
//***********************************************************************\\
tb_test_case = "Write to 0";
tb_test_case_num = tb_test_case_num + 1;
reset_dut();
//Check that all the outputs are correct
//Lets set all the registers to have values from 0 to 31
read_write_reg( .WEN(1),
                    .write_reg_num(0),
                    .write_data(69),
                    .read_reg_num_1(10),
                    .read_reg_num_2(10),
                    .expected_r1(0),
                    .expected_r2(0)
                    ); //Attempt to Write to 0

read_write_reg( .WEN(1), //Read from 0
                    .write_reg_num(0),
                    .write_data(0),
                    .read_reg_num_1(0),
                    .read_reg_num_2(0),
                    .expected_r1(0), //Both read from 0 should be 0
                    .expected_r2(0)
                    );

//***********************************************************************\\
//Test 5- Async Reset Test
//***********************************************************************\\
tb_test_case = "Async Reset";
tb_test_case_num = tb_test_case_num + 1;
@(negedge CLK)
reset_dut();

end
endprogram
