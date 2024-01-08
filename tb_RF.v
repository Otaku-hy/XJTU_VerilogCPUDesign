module RegisterFile_tb;
  reg [4:0] readReg1;
  reg [4:0] readReg2;
  reg [4:0] writeReg;
  reg [31:0] writeData;
  reg writeEnable;
  reg clk;
  wire [31:0] readData1;
  wire [31:0] readData2;

  // Instantiate the RegisterFile module
  RegisterFile rf_inst (
    .readReg1(readReg1),
    .readReg2(readReg2),
    .writeReg(writeReg),
    .writeData(writeData),
    .writeEnable(writeEnable),
    .clk(clk),
    .readData1(readData1),
    .readData2(readData2)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Test stimulus
  initial begin
    // Initialize inputs
    readReg1 = 5'b00000;
    readReg2 = 5'b00010;
    writeReg = 5'b00010;
    writeData = 32'h12345678;
    writeEnable = 1'b0;
    clk = 1'b0;

    #10; // Wait for 10 time units
    $display("Read data from register 1: %h", readData1);
    $display("Read data from register 2: %h", readData2);

    // Write data to register 2
    writeEnable = 1'b1;
    #10; // Wait for 10 time units

    // Stop writing
    writeEnable = 1'b0;
    #10; // Wait for 10 time units

    // Read data from register 2
    readReg1 = 5'b00010;
    #10; // Wait for 10 time units

    // Check the output
    if (readData1 !== writeData) begin
      $display("Test failed: expected %h, got %h", writeData, readData1);
    end else begin
      $display("Test passed");
      $display("Read data from register 1: %h", readData1);
    end

    // End the simulation
    $finish;
  end
endmodule