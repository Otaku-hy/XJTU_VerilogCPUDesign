// sign overflow carry zero
module ALU (
  input wire [31:0] operandA,
  input wire [31:0] operandB,
  input wire [4:0] aluCtrl,
  output wire [31:0] result,
  // below are added
  output wire [31:0] highresult,
  output wire [31:0] lowresult,
  // above are added
  output wire [3:0] psw,
  output wire [31:0] test_tmp
);
    reg [31:0] resultReg,pswReg;
    // below are added
    reg [31:0] highresultReg, lowresultReg;
    // above are added
    wire [31:0] resultAdd,resultSub,resultdivuhi,resultdivulo;
    wire carryAdd, carrySub;

    Accumulator32bit add(operandA,operandB,1'b0,resultAdd,carryAdd);
    Accumulator32bit sub(operandA,~operandB + 1,1'b0,resultSub,carrySub);
    signed_divider divu(operandA, operandB,resultdivulo,resultdivuhi);

    assign result = resultReg;
    // below are added
    assign highresult = highresultReg;
    assign lowresult = lowresultReg;
    // above are added
    assign psw = pswReg;

    always @* begin
    case (aluCtrl)
        5'b00000: begin
            // Perform addition using the instantiated module
           resultReg = resultAdd;
           pswReg[1] = carryAdd;
           pswReg[2] = (resultReg[31] != operandA[31] && resultReg[31] != operandB[31]); // Check if sign overflow
           pswReg[3] = resultReg[31]; // Check if result is negative 
        end
        5'b00001: begin
            // Perform subtraction using the instantiated module
           resultReg = resultSub;
           pswReg[1] = operandA < operandB;
           pswReg[2] = (~resultReg[31] && operandA[31] && ~operandB[31] || resultReg[31] && ~operandA[31] && operandB[31]); // Check if sign overflow
           pswReg[3] = resultReg[31]; // Check if result is negative
        end
        5'b00010: begin
             // Perform sar
           resultReg = operandB >> operandA;
        end
        5'b00011: begin
             // Perform shr
           resultReg = $signed(operandB) >>> operandA;
        end
        5'b00100: begin
             // Perform sal
           resultReg = operandB << operandA;
        end
        5'b00101: begin
            // Perform bitwise AND
           resultReg = operandA & operandB;
        end
        5'b00110: begin
            // Perform bitwise OR
           resultReg = operandA | operandB;
        end
        5'b00111: begin
            // Perform bitwise XOR
           resultReg = operandA ^ operandB;
        end
        5'b01000: begin
            // Perform sltu
          resultReg = operandA < operandB ? 32'b1 : 32'b0;
        end
        5'b01001: begin
            // Perform mul
           resultReg = operandA * operandB;
           {highresultReg, lowresultReg} = $signed(operandA) * $signed(operandB);
        end
        5'b01010: begin
            // Perform div
          resultReg = resultdivulo;
          lowresultReg = resultdivulo;
          highresultReg = resultdivuhi;
        end
        5'b01011: begin
            // Perform slt
           resultReg = {31'h00000000,resultSub[31]};
           pswReg[3] = resultSub[31];
        end
        5'b01100: begin
            // addu
           resultReg = resultAdd;
           pswReg[1] = carryAdd;
        end
        5'b01101: begin
            // Perform divu
           resultReg = operandA / operandB;
           // added: 
           lowresultReg = operandA / operandB;
           highresultReg = operandA % operandB;
        end
        5'b01110: begin
            // Perform multu
           resultReg = operandA * operandB;
           {highresultReg, lowresultReg} = operandA * operandB;
        end
        5'b01111: begin
            // Perform nor
           resultReg = ~(operandA | operandB);
        end
        5'b10001: begin
            // Perform subu
           resultReg = resultSub;
           pswReg[1] = operandA < operandB;
        end
    endcase
    pswReg[0] = (resultReg == 32'b0); // Check if result is zero
   end

endmodule