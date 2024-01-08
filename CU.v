/*
| nums | aluctrl | operate |
| ---- | ------- | ------- |
|   1  |  00000  |  add    |
|   2  |  00001  |  sub    |
|  3.4 |  00010  |  srl(v) |
|  5.6 |  00011  |  sra(v) |
|  7.8 |  00100  |  sll(v) |
|   9  |  00101  |  and    |
|  10  |  00110  |  or     |
|  11  |  00111  |  xor    |
|  12  |  01000  |  sltu   |
|  13  |  01001  |  mult   |
|  14  |  01010  |  div    |
|  15  |  01011  |  slt    |
|  16  |  01100  |  addu   |
|  17  |  01101  |  divu   |
|  18  |  01110  |  multu  |
|  19  |  01111  |  nor    |
|  20  |  10001  |  subu   |
*/

module ALUCU(
    input wire [5:0] func,
    input wire [1:0] aluOP,
    output wire [4:0] aluCtrl
);
    reg [4:0] aluCtrlReg;
    assign aluCtrl = aluCtrlReg;
    
    always @* begin
        if(aluOP == 2'b00) begin
            aluCtrlReg = 5'b00000;
        end
        else if (aluOP == 2'b01) begin
            aluCtrlReg = 5'b00001;
        end
        else begin
            case (func)
                6'b100000: begin    //add   1
                    aluCtrlReg = 5'b00000;
                end
                6'b100001: begin    //addu  2
                    aluCtrlReg = 5'b01100;
                end
                6'b100010: begin    //sub   3
                    aluCtrlReg = 5'b00001;
                end
                6'b100100: begin    //and   4
                    aluCtrlReg = 5'b00101;
                end
                6'b100101: begin    //or    5
                    aluCtrlReg = 5'b00110;
                end
                6'b100110: begin    //xor   6
                    aluCtrlReg = 5'b00111;
                end
                6'b100111: begin    //nor   7
                    aluCtrlReg = 5'b01111;
                end
                6'b101010: begin    //slt   8
                    aluCtrlReg = 5'b01011;
                end
                6'b101011: begin    //sltu  9
                    aluCtrlReg = 5'b01000;
                end
                6'b011010: begin    //div   10
                    aluCtrlReg = 5'b01010;
                end
                6'b011011: begin    //divu  11
                    aluCtrlReg = 5'b01101;
                end
                6'b011000: begin    //mult  12
                    aluCtrlReg = 5'b01001;
                end
                6'b011001: begin    //multu 13
                    aluCtrlReg = 5'b01110;
                end
                6'b000100: begin    //sllv  14
                    aluCtrlReg = 5'b00100;
                end
                6'b000110: begin    //srlv  15
                    aluCtrlReg = 5'b00010;
                end
                6'b000111: begin    //srav  16
                    aluCtrlReg = 5'b00011;
                end
                6'b000000: begin    //sll   17
                    aluCtrlReg = 5'b00100;
                end
                6'b000010: begin    //srl   18
                    aluCtrlReg = 5'b00010;
                end
                6'b000011: begin    //sra   19
                    aluCtrlReg = 5'b00011;
                end
                6'b100011: begin    //subu  20
                    aluCtrlReg = 5'b10001;
                end
            endcase
        end
    end

endmodule

/// CU function table is in file `CU_function_table.xlsx`
module MCU(
    input wire [5:0] opCode,
    input wire [4:0] bCode,
    input wire [5:0] funct,
    input wire clk,
    output wire [1:0] regDst,
    output wire [1:0] jump,
    output wire regWrite, 
    output wire hiloWrite,
    output wire [5:0] branch, // added
    output wire [1:0] writeToReg,
    output wire [1:0] aluOP,
    output wire memRead,
    output wire memWrite,
    output wire aluSrcA,
    output wire [1:0] aluSrcB
);
    wire typeR = ~opCode[5] & ~opCode[4] & ~opCode[3] & ~opCode[2] & ~opCode[1] & ~opCode[0];
    wire lw = opCode[5] & ~opCode[4] & ~opCode[3] & ~opCode[2] & opCode[1] & opCode[0];
    wire sw = opCode[5] & ~opCode[4] & opCode[3] & ~opCode[2] & opCode[1] & opCode[0];
    wire beq = ~opCode[5] & ~opCode[4] & ~opCode[3] & opCode[2] & ~opCode[1] & ~opCode[0];
    // bne wire added
    wire bne = ~opCode[5] & ~opCode[4] & ~opCode[3] & opCode[2] & ~opCode[1] & opCode[0];
    wire j = ~opCode[5] & ~opCode[4] & ~opCode[3] & ~opCode[2] & opCode[1] & ~opCode[0];

    //bgez or bltz
    wire bgezorlte = ~opCode[5] & ~opCode[4] & ~opCode[3] & ~opCode[2] & ~opCode[1] & opCode[0];
    wire bgtz = ~opCode[5] & ~opCode[4] & ~opCode[3] & opCode[2] & opCode[1] & opCode[0];
    wire blez = ~opCode[5] & ~opCode[4] & ~opCode[3] & opCode[2] & opCode[1] & ~opCode[0];
    wire typeRdm = typeR & ~funct[5] & funct[4] & funct[3];
    wire typeRshamt = typeR & ~funct[5] & ~funct[4] & ~funct[3] & ~funct[2];
    wire jr = typeR & ~funct[5] & ~funct[4] & funct[3] & ~funct[2] & ~funct[1] & ~funct[0];
    wire jal = ~opCode[5] & ~opCode[4] & ~opCode[3] & ~opCode[2] & opCode[1] & opCode[0];

    assign regDst[0] = typeR & ~typeRdm;
    assign regDst[1] = jal;
    assign aluSrcB[1] = bgtz | blez | bgezorlte;
    assign aluSrcB[0] = lw | sw;
    assign aluSrcA = typeRshamt;
    assign writeToReg[0] = lw;
    assign writeToReg[1] = jal;
    assign regWrite = (typeR | lw | jal) & ~typeRdm & ~jr;
    assign hiloWrite = typeRdm;

    assign memRead = lw;
    assign memWrite = sw;
    assign branch[5] = beq; // beq
    assign branch[4] = bne; // bne
    assign branch[3] = bgezorlte & bCode[0];  // bgez
    assign branch[2] = bgezorlte & ~bCode[0]; // blte
    assign branch[1] = bgtz; // bgtz
    assign branch[0] = blez; // blez

    assign jump[0] = j | jal;
    assign jump[1] = jr;
    assign aluOP[1] = typeR;
    assign aluOP[0] = beq | bne | blez | bgezorlte | bgtz; // bne added

endmodule

module MCUMutipleCycle
(
    input wire [5:0] opCode,
    input wire [4:0] bCode,
    input wire [5:0] func,
    input wire [3:0] currentState,
    input wire clk,
    output wire IorD,
    output wire irWrite,
    output wire pcWrite,
    output wire [5:0] branch,
    output wire [1:0] regDst,
    output wire regWrite,
    output wire hilowrite,
    output wire [1:0] aluSrcA,
    output wire [1:0] pcSrc,
    output wire [2:0] aluSrcB, 
    output wire memToReg,
    output wire [1:0] aluOP,
    output wire memRead,
    output wire memWrite,
    output wire [3:0] nextState 
);

    ///*** set up temporal logic ***///
    wire [25:0] tmpLogic;
    assign tmpLogic[0] = ~currentState[3] && ~currentState[2] && ~currentState[1] && ~currentState[0]; //0000
    assign tmpLogic[1] = ~currentState[3] && ~currentState[2] && ~currentState[1] &&  currentState[0]; //0001
    assign tmpLogic[2] = ~currentState[3] && ~currentState[2] &&  currentState[1] && ~currentState[0]; //0010
    assign tmpLogic[3] = ~currentState[3] && ~currentState[2] &&  currentState[1] &&  currentState[0]; //0011
    assign tmpLogic[4] = ~currentState[3] &&  currentState[2] && ~currentState[1] && ~currentState[0]; //0100
    assign tmpLogic[5] = ~currentState[3] &&  currentState[2] && ~currentState[1] &&  currentState[0]; //0101
    assign tmpLogic[6] = ~currentState[3] &&  currentState[2] &&  currentState[1] && ~currentState[0]; //0110
    assign tmpLogic[7] = ~currentState[3] &&  currentState[2] &&  currentState[1] &&  currentState[0]; //0111  
    assign tmpLogic[8] =  currentState[3] && ~currentState[2] && ~currentState[1] && ~currentState[0]; //1000
    assign tmpLogic[9] =  currentState[3] && ~currentState[2] && ~currentState[1] &&  currentState[0]; //1001
    // added
    assign tmpLogic[10] = currentState[3] && ~currentState[2] &&  currentState[1] && ~currentState[0]; //1010
    assign tmpLogic[11] = currentState[3] && ~currentState[2] &&  currentState[1] &&  currentState[0]; //1011
    assign tmpLogic[12] = currentState[3] &&  currentState[2] && ~currentState[1] && ~currentState[0]; //1100
    assign tmpLogic[13] = currentState[3] &&  currentState[2] && ~currentState[1] &&  currentState[0]; //1101
    assign tmpLogic[14] = currentState[3] &&  currentState[2] &&  currentState[1] && ~currentState[0]; //1110

    assign tmpLogic[15] = ~opCode[5] && ~opCode[4] && ~opCode[3] && ~opCode[2] &&  opCode[1] && ~opCode[0] && ~currentState[3] && ~currentState[2] && ~currentState[1] &&  currentState[0]; //000010 0001 -> j 0001
    
    assign tmpLogic[16] = ~opCode[5] && ~opCode[4] && ~opCode[3] &&  opCode[2] && ~opCode[1] && ~opCode[0] && ~currentState[3] && ~currentState[2] && ~currentState[1] &&  currentState[0] ||
                          ~opCode[5] && ~opCode[4] && ~opCode[3] &&  opCode[2] && ~opCode[1] &&  opCode[0] && ~currentState[3] && ~currentState[2] && ~currentState[1] &&  currentState[0] ||
                          ~opCode[5] && ~opCode[4] && ~opCode[3] && ~opCode[2] && ~opCode[1] &&  opCode[0] && ~currentState[3] && ~currentState[2] && ~currentState[1] &&  currentState[0] ||
                          ~opCode[5] && ~opCode[4] && ~opCode[3] &&  opCode[2] &&  opCode[1] &&  opCode[0] && ~currentState[3] && ~currentState[2] && ~currentState[1] &&  currentState[0] ||
                          ~opCode[5] && ~opCode[4] && ~opCode[3] &&  opCode[2] &&  opCode[1] && ~opCode[0] && ~currentState[3] && ~currentState[2] && ~currentState[1] &&  currentState[0] ||
                          ~opCode[5] && ~opCode[4] && ~opCode[3] && ~opCode[2] && ~opCode[1] &&  opCode[0] && ~currentState[3] && ~currentState[2] && ~currentState[1] &&  currentState[0]; //000100 0001 -> b 0001
    
    
    
    assign tmpLogic[17] = ~opCode[5] && ~opCode[4] && ~opCode[3] && ~opCode[2] && ~opCode[1] && ~opCode[0] && ~currentState[3] && ~currentState[2] && ~currentState[1] &&  currentState[0] &&  func[5] && ~func[4] || 
                          ~opCode[5] && ~opCode[4] && ~opCode[3] && ~opCode[2] && ~opCode[1] && ~opCode[0] && ~currentState[3] && ~currentState[2] && ~currentState[1] &&  currentState[0] &&  ~func[5] && ~func[4] && ~func[3] && func[2]; //000000 0001 10xxxx -> R_type 0001
    assign tmpLogic[18] =  opCode[5] && ~opCode[4] && ~opCode[3] && ~opCode[2] &&  opCode[1] &&  opCode[0] && ~currentState[3] && ~currentState[2] &&  currentState[1] && ~currentState[0]; //100011 0010 ->lw 0010
    assign tmpLogic[19] =  opCode[5] && ~opCode[4] &&  opCode[3] && ~opCode[2] &&  opCode[1] &&  opCode[0] && ~currentState[3] && ~currentState[2] && ~currentState[1] &&  currentState[0]; //101011 0001 ->sw 0001
    assign tmpLogic[20] =  opCode[5] && ~opCode[4] && ~opCode[3] && ~opCode[2] &&  opCode[1] &&  opCode[0] && ~currentState[3] && ~currentState[2] && ~currentState[1] &&  currentState[0]; //100011 0001 ->lw 0001
    assign tmpLogic[21] =  opCode[5] && ~opCode[4] &&  opCode[3] && ~opCode[2] &&  opCode[1] &&  opCode[0] && ~currentState[3] && ~currentState[2] &&  currentState[1] && ~currentState[0]; //101011 0010 ->sw 0010
    assign tmpLogic[22] = ~opCode[5] && ~opCode[4] && ~opCode[3] && ~opCode[2] && ~opCode[1] && ~opCode[0] && ~currentState[3] && ~currentState[2] && ~currentState[1] &&  currentState[0] && ~func[5] &&  func[4]; //000000 0001 01xxxx -> Rdm 0001
    assign tmpLogic[23] = ~opCode[5] && ~opCode[4] && ~opCode[3] && ~opCode[2] && ~opCode[1] && ~opCode[0] && ~currentState[3] && ~currentState[2] && ~currentState[1] &&  currentState[0] && ~func[5] && ~func[4] && ~func[3] && ~func[2]; //000000 0001 000xxx -> Rshamt 0001
    assign tmpLogic[24] = ~opCode[5] && ~opCode[4] && ~opCode[3] && ~opCode[2] && ~opCode[1] && ~opCode[0] && ~currentState[3] && ~currentState[2] && ~currentState[1] &&  currentState[0] && ~func[5] && ~func[4] &&  func[3]; //000000 0001 0010xx -> jr 0001
    assign tmpLogic[25] = ~opCode[5] && ~opCode[4] && ~opCode[3] && ~opCode[2] &&  opCode[1] &&  opCode[0] && ~currentState[3] && ~currentState[2] && ~currentState[1] &&  currentState[0]; //000011 0001 -> jal 0001

    
    /// *** set up output logic *** ///
    assign pcWrite = tmpLogic[0] || tmpLogic[9] || tmpLogic[13] || tmpLogic[14];
    // assign pcWriteCond = tmpLogic[8];
    // beq
    assign branch[5] = ~opCode[5] & ~opCode[4] & ~opCode[3] &  opCode[2] & ~opCode[1] & ~opCode[0] & tmpLogic[8];
    // bne
    assign branch[4] = ~opCode[5] & ~opCode[4] & ~opCode[3] &  opCode[2] & ~opCode[1] &  opCode[0] & tmpLogic[8];
    // bgez
    assign branch[3] = ~opCode[5] & ~opCode[4] & ~opCode[3] & ~opCode[2] & ~opCode[1] &  opCode[0] & tmpLogic[8] & bCode[0];
    // bgtz
    assign branch[2] = ~opCode[5] & ~opCode[4] & ~opCode[3] &  opCode[2] &  opCode[1] &  opCode[0] & tmpLogic[8];
    // blez
    assign branch[1] = ~opCode[5] & ~opCode[4] & ~opCode[3] &  opCode[2] &  opCode[1] & ~opCode[0] & tmpLogic[8];
    // bltz
    assign branch[0] = ~opCode[5] & ~opCode[4] & ~opCode[3] & ~opCode[2] & ~opCode[1] &  opCode[0] & tmpLogic[8] & ~bCode[0];

    assign IorD = tmpLogic[3] || tmpLogic[5];
    assign memRead = tmpLogic[0] || tmpLogic[3];
    assign memWrite = tmpLogic[5];
    assign irWrite = tmpLogic[0];
    assign memToReg = tmpLogic[4];
    assign pcSrc[1] = tmpLogic[9] || tmpLogic[13] || tmpLogic[14];
    assign pcSrc[0] = tmpLogic[8] || tmpLogic[13];
    assign aluOP[1] = tmpLogic[6] || tmpLogic[10] || tmpLogic[11];
    assign aluOP[0] = tmpLogic[8];
    assign aluSrcB[2] = branch[2] || branch[3] || branch[4] || branch[5];
    assign aluSrcB[1] = tmpLogic[1] || tmpLogic[2];
    assign aluSrcB[0] = tmpLogic[0] || tmpLogic[1];
    assign aluSrcA[0] = tmpLogic[2] || tmpLogic[6] || tmpLogic[8] || tmpLogic[10] || tmpLogic[12];
    assign aluSrcA[1] = tmpLogic[11];
    assign regWrite = tmpLogic[4] || tmpLogic[7] || tmpLogic[14];
    assign regDst[0] = tmpLogic[7];
    assign regDst[1] = tmpLogic[14];
    assign hilowrite = tmpLogic[12];

    assign nextState[3] = tmpLogic[10] || tmpLogic[15] || tmpLogic[16] || tmpLogic[22] || tmpLogic[23] || tmpLogic[24] || tmpLogic[25];
    assign nextState[2] = tmpLogic[3]  || tmpLogic[6]  || tmpLogic[10] || tmpLogic[11] || tmpLogic[17] || tmpLogic[21] || tmpLogic[24] || tmpLogic[25];
    assign nextState[1] = tmpLogic[6]  || tmpLogic[11] || tmpLogic[17] || tmpLogic[18] || tmpLogic[19] || tmpLogic[20] || tmpLogic[22] || tmpLogic[23] || tmpLogic[25];
    assign nextState[0] = tmpLogic[0]  || tmpLogic[6]  || tmpLogic[11] || tmpLogic[15] || tmpLogic[18] || tmpLogic[21] || tmpLogic[23] || tmpLogic[24];

endmodule
    
