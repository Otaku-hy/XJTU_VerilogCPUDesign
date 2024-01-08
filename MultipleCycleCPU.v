///***  since multiple cycle cpu does not have redundant modules, the code style will not be similar as single cycle style which seperates into small stages. Instead, the code will be seperated according to different functions.***///
   
module MultipleCycleCPU(
    input wire clk
);

    ///*** wires ***///

    //control wires
    wire IorD;
    wire irWrite;
    wire pcWrite;
    wire pcWriteCond;
    wire [1:0] regDst;
    wire regWrite;
    wire [1:0] aluSrcA;
    wire [1:0] pcSrc;
    wire [2:0] aluSrcB;
    wire memToReg;
    wire [1:0] aluOP;
    wire memRead;
    wire memWrite;
    wire [3:0] nextState;
    wire [3:0] currentState;
    wire [5:0] branch;
    wire branchpc;

    wire [4:0] aluCtrl;
    //data wires
    wire [31:0] nextInstructionAddress;
    wire [31:0] currentInstructionAddress;
    wire [31:0] memAccessAddress;

    wire [31:0] aluTmpResult;
    wire [31:0] aluResult;

    wire [31:0] memTmpReadData;
    wire [31:0] memReadData;

    wire [31:0] tmpRegRdDataA;
    wire [31:0] regRdDataA;
    wire [31:0] tmpRegRdDataB;
    wire [31:0] regRdDataB;

    wire [31:0] instruction;

    wire [3:0] psw;
    wire [31:0] aluSrcDataA;
    wire [31:0] aluSrcDataB;

    wire [31:0] regWrData;
    wire [4:0] regWrDst;
    wire hilowrite;

    wire [31:0] extendedImmediate;
    wire [31:0] extendedImmediate2;

    ///*** cu ***///
    MCUMutipleCycle mcu(instruction[31:26],instruction[20:16],instruction[5:0],currentState,clk,IorD,irWrite,pcWrite,branch,regDst,regWrite,hilowrite,aluSrcA,pcSrc,aluSrcB,memToReg,aluOP,memRead,memWrite,nextState);
    ALUCU aluCU(instruction[5:0],aluOP,aluCtrl);

    ///*** memory ***///
    DataMemory dmem(memAccessAddress, regRdDataB, memWrite, memRead, memTmpReadData);

    ///*** alu ***///
    wire [31:0] aluAddtest_tmp_useless;
    wire [31:0] highresult;
    wire [31:0] lowresult;
    ALU alu(aluSrcDataA,aluSrcDataB,aluCtrl,aluTmpResult,highresult,lowresult,psw,aluAddtest_tmp_useless);

    ///*** register files ***///
    RegisterFile regFile(instruction[25:21],instruction[20:16],regWrDst,regWrData,highresult,lowresult,regWrite,hilowrite,clk,tmpRegRdDataA,tmpRegRdDataB);

    ///*** extension ***///
    SigExt16To32bit sigExt16To32(instruction[15:0],extendedImmediate);
    SigExt5To32bit sigExt5To32(instruction[10:6],extendedImmediate2);

    ///*** register ***///
    MultiBranch branchornot(branch, psw, branchpc);
    PC pc(nextInstructionAddress, (pcWrite || branchpc), clk, currentInstructionAddress);
    StateRegister stateRegister(nextState, clk, currentState);
    InstructionRegister ir(memTmpReadData, irWrite, clk, instruction);
    TemporaryRegister_32bit mdr(memTmpReadData, clk, memReadData);
    TemporaryRegister_32bit aluOut(aluTmpResult, clk, aluResult);
    TemporaryRegister_32bit rdDataARegister(tmpRegRdDataA, clk, regRdDataA);
    TemporaryRegister_32bit rdDataBRegister(tmpRegRdDataB, clk, regRdDataB);

    ///*** mux ***///
    MUX2To1_32bit memAddrMux(currentInstructionAddress, aluResult, IorD, memAccessAddress);
    MUX2To1_32bit regWrDataMux(aluResult, memReadData, memToReg, regWrData);
    MUX3To1_5bit regDstMux(instruction[20:16],instruction[15:11],5'b11111,regDst,regWrDst);
    MUX3To1_32bit aluSrcAMux(currentInstructionAddress,regRdDataA,extendedImmediate2,aluSrcA,aluSrcDataA);
    MUX5To1_32bit aluSrcBMux(regRdDataB,32'h00000004, extendedImmediate, (extendedImmediate<<2), 32'h00000000, aluSrcB, aluSrcDataB);
    MUX4To1_32bit pcSrcMux(aluTmpResult, aluResult, {currentInstructionAddress[31:28],instruction[25:0],2'b00}, regRdDataA, pcSrc, nextInstructionAddress);

endmodule