module InstructionMemory(
    input wire [31:0] address,
    output wire [31:0] instruction
);
    reg [31:0] memory [0:1023];

    // initial begin
    //     memory[0] = 32'h00011020;
    //     memory[1] = 32'h00000000;
    //     memory[2] = 32'h00000000;
    //     memory[3] = 32'h00000000;
    //     memory[4] = 32'h00000000;
    //     memory[5] = 32'h00000000;
    //     memory[6] = 32'h00000000;
    //     memory[7] = 32'h00000000;
    //     memory[8] = 32'h00000000;
    //     memory[9] = 32'h00000000;
    //     memory[10] = 32'h00000000;
    //     memory[11] = 32'h00000000;
    //     memory[12] = 32'h00000000;
    //     memory[13] = 32'h00000000;
    //     memory[14] = 32'h00000000;
    //     memory[15] = 32'h00000000;
    //     memory[16] = 32'h00000000;
    //     memory[17] = 32'h00000000;
    //     memory[18] = 32'h00000000;
    // end

    assign instruction = memory[address[11:2]];

endmodule

module DataMemory(
    input wire [31:0] address,
    input wire [31:0] writeData,
    input wire writeEnable,
    input wire readEnable,
    output wire [31:0] readData
);
    reg [31:0] memory [0:1023];
    reg [31:0] readReg;

    integer i;

    // initial begin
    //     for (i = 0; i < 1024; i = i + 1) begin
    //         memory[i] <= 32'h00000010;
    //     end
    // end

    assign readData = readReg;

    always @* begin
        if(readEnable) begin
            readReg = memory[address[11:2]];
        end

        if (writeEnable) begin
            memory[address[11:2]] <= writeData;
        end
    end
    
endmodule