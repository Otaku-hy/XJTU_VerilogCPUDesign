module tb_PC;
  reg clk;
  wire [31:0] instruction;
  wire [31:0] nextInstructionAddress;
  wire [31:0] currentInstructionAddress;

  wire [3:0] psw;
  wire [31:0] test_tmp;

  // Instantiate the PC module
    PC pc_inst (nextInstructionAddress, clk, currentInstructionAddress);
    ALU dut (currentInstructionAddress, 32'h00000004, 4'b0000, nextInstructionAddress, psw, test_tmp);
    InstructionMemory imem (currentInstructionAddress, instruction);

  // Clock generation
  always #10 clk = ~clk;

    integer i;

  // Reset generation
  // Test stimulus
  initial begin
    clk <= 1'b0;
    #5;

    for(i = 0;i<15;i=i+1) begin
        $display("Current Times: %d", i);
        $display("Current Instruction Address: %b", currentInstructionAddress);
        $display("Next Instruction Address: %b", nextInstructionAddress);
        $display("Instruction: %b", instruction);
        #20;
    end
    // Load instructions into instruction memory
    // ...

    // Start execution
    // ...

    // Monitor the PC output
    // ...

    // Add more test cases as needed
    // ...
  end
endmodule
