module ALU_Testbench;

  // Parameters
  parameter CLK_PERIOD = 10; // Clock period in time units

  // Signals
  reg [31:0] operandA;
  reg [31:0] operandB;
  reg [3:0] opcode;
  wire [31:0] result;
  wire [3:0] psw;
  wire [31:0] test_tmp;

  // Instantiate the ALU module
  ALU dut (
    .operandA(operandA),
    .operandB(operandB),
    .opcode(opcode),
    .result(result),
    .psw(psw),
    .test_tmp(test_tmp)
  );

  // Accumulator32bit myadd(
  //   .i_va(operandA),
  //   .i_vb(operandB),
  //   .i_c0(1'b0),
  //   .o_v(result),
  //   .o_c32(carry)
  // );

  // Clock generation
  reg clk;
  always #((CLK_PERIOD)/2) clk = ~clk;

  // Test stimulus
  initial begin
    // Initialize inputs
    operandA = 32'b01101011;
    operandB = 32'b00000101;
    opcode = 4'b0000; // Addition

    // Apply inputs and display results
    #25;
    $display("Addition:");
    $display("Operand A: %b", operandA);
    $display("Operand B: %b", operandB);
    $display("Opcode: %b", opcode);
    $display("Expected Result: %b", operandA + operandB);
    $display("Actual Result: %b", result);
    $display("PSW: %b", psw);

    // Change inputs for subtraction
    opcode = 4'b0001; // Subtraction
    operandA = 32'b01101011;
    operandB = 32'b00000101;

    // Apply inputs and display results
    #25;
    $display("Subtraction:");
    $display("Operand A: %b", operandA);
    $display("Operand B: %b", operandB);
    $display("Opcode: %b", opcode);
    $display("Expected Result: %b", operandA - operandB);
    $display("Actual Result: %b", result);
    $display("PSW: %b", psw);

    opcode = 4'b1000; // Subtraction
    operandA = 32'h01101011;
    operandB = 32'b00000101;
    #5;
    $display("Subtraction:");
    $display("Operand A: %b", operandA);
    $display("Operand B: %b", operandB);
    $display("Opcode: %b", opcode);
    $display("Expected Result: %b", ~operandA);
    $display("Actual Result: %b", result);
    $display("PSW: %b", psw);


    // Add more test cases as needed

    // End simulation
    #25;
    $finish;
  end

  // Clock driver
  always #((CLK_PERIOD)/2) clk = ~clk;

endmodule