module DataMemory_tb;
  reg [31:0] address;
  reg [31:0] writeData;
  reg writeEnable;
  reg readEnable;
  wire [31:0] readData;

  // Instantiate the DataMemory module
  DataMemory dm_inst (
    .address(address),
    .writeData(writeData),
    .writeEnable(writeEnable),
    .readEnable(readEnable),
    .readData(readData)
  );

  // Test stimulus
  initial begin
    // Initialize inputs
    address = 32'h00000000;
    writeData = 32'h12345678;
    writeEnable = 1'b0;
    readEnable = 1'b1;
    #10; // Wait for 10 time units
    $display("Read data from memory: %h", readData);
    #10; // Wait for 10 time units
    writeEnable = 1'b1;
    readEnable  = 1'b0;
    #10; // Wait for 10 time units
    readEnable = 1'b1;
    writeEnable = 1'b0;
    #10; // Wait for 10 time units
    $display("Read data from memory: %h", readData);

    // End the simulation
    $finish;
  end
endmodule