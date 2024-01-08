module RegisterFile (
  input wire [4:0] readReg1, // Read register 1 address
  input wire [4:0] readReg2, // Read register 2 address
  input wire [4:0] writeReg, // Write register address
  input wire [31:0] writeData, // Data to write
  // below are added
  input wire [31:0] highresult,
  input wire [31:0] lowresult,
  // above are added
  input wire writeEnable, // Write enable signal
  input wire hilowrite,
  input wire clk, // Clock signal
  output wire [31:0] readData1, // Data from read register 1
  output wire [31:0] readData2 // Data from read register 2
);
  reg [31:0] registers [31:0]; // 32 32-bit registers
  reg [31:0] HI;
  reg [31:0] LO;
  integer i;

  // initial begin
  //   // Initialize all registers to 0
  //   for (i = 0; i < 32; i = i + 1) begin
  //     registers[i] = 32'h00000001;
  //   end
  // end

  assign readData1 = registers[readReg1];
  assign readData2 = registers[readReg2];

  always @(posedge clk) begin
    // Write data to the register if writeEnable is high
    if (writeEnable) begin
      registers[writeReg] <= writeData;
    end

    if (hilowrite) begin
      HI <= highresult;
      LO <= lowresult;
    end
  end
endmodule

module PC(
  input wire [31:0] nextInstructionAddress,
  input wire pcWrite,
  input wire clk,
  output wire [31:0] currentInstructionAddress
);
  reg [31:0] programCounter;

  initial begin
    programCounter <= 32'h00000000;
  end

  always @(posedge clk) begin
    if (pcWrite) begin
      #0.1
      programCounter <= nextInstructionAddress;
    end
  end

  assign currentInstructionAddress = programCounter;

endmodule

module InstructionRegister(
  input wire [31:0] nextInstruction,
  input wire irWrite,
  input wire clk,
  output wire [31:0] currentInstruction
);
  reg [31:0] instructionRegister;

  initial begin
    instructionRegister <= 32'h00000000;
  end

  always @(posedge clk) begin
    if (irWrite) begin
      instructionRegister <= nextInstruction;
    end
  end

  assign currentInstruction = instructionRegister;

endmodule


module StateRegister(
  input wire [3:0] nextInstructionAddress,
  input wire clk,
  output wire [3:0] currentInstructionAddress
);
  reg [3:0] currentStateRegister;

  assign currentInstructionAddress = currentStateRegister;

  initial begin
    currentStateRegister <= 32'h00000000;
  end

  always @(posedge clk) begin
    currentStateRegister <= nextInstructionAddress;
  end
endmodule

module TemporaryRegister_32bit(
  input wire [31:0] nextData,
  input wire clk,
  output wire [31:0] currentData
);
  reg [31:0] temporaryRegister;

  initial begin
    temporaryRegister <= 32'h00000000;
  end

  always @(posedge clk) begin
    temporaryRegister <= nextData;
  end

  assign currentData = temporaryRegister;
  
endmodule