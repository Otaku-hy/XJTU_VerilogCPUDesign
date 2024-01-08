module SingleCycleCPU(
    input wire clk
);
    ///*** fetch wire ***///
    wire [31:0] instruction;
    wire [31:0] currentInstructionAddress;
    wire [31:0] nextInstructionAddress;
    wire [31:0] tmpNextInstructionAddress;

    ///*** decode wire ***///
    wire [1:0] regDst;
    wire [1:0] jump;
    wire regWrite; 
    wire hiloWrite;
    wire [5:0] branch;

    wire [1:0] writeToReg;
    wire [1:0] aluOP;
    wire memRead;
    wire memWrite;
    wire [1:0] aluSrcB;
    wire aluSrcA;

    wire [4:0] regDstMuxOut;
    wire [31:0] regWrData;
    wire [31:0] regRdData1;
    wire [31:0] regRdData2;

    wire [31:0] jumpAddress;
    wire [31:0] extendedImmediate,extendedImmediate2;

    ///*** execute wire ***///
    wire [4:0] aluCtrl;
    wire [31:0] aluSrcDataA,aluSrcDataB;

    wire [3:0] psw;
    wire [31:0] aluResult;
    wire [31:0] branchAddress;

    ///*** memory access wire ***///
    wire [31:0] memReadData;
    wire [31:0] tmpNextBranchInstructionAddress;

    ///*** fetch instruction ***///
    PC pc(nextInstructionAddress, 1'b1, clk, currentInstructionAddress);
    wire [3:0] pcAddpsw_useless;
    wire [31:0] pcAddtest_tmp_useless;
    wire [31:0] pcAddhightest_tmp_useless;
    wire [31:0] pcAddlowtest_tmp_useless;
    ALU pcAdd(currentInstructionAddress, 32'h00000004, 5'b00000, tmpNextInstructionAddress,pcAddhightest_tmp_useless,pcAddlowtest_tmp_useless,pcAddpsw_useless,pcAddtest_tmp_useless);
    InstructionMemory imem(currentInstructionAddress, instruction);

    ///*** decode instruction ***///
    wire [31:0] highresult;
    wire [31:0] lowresult;
    MCU mcu(instruction[31:26],instruction[20:16],instruction[5:0],clk,regDst,jump,regWrite,hiloWrite,branch,writeToReg,aluOP,memRead,memWrite,aluSrcA,aluSrcB);
    MUX3To1_5bit regDstMux(instruction[20:16],instruction[15:11],5'b11111,regDst,regDstMuxOut);
    RegisterFile regFile(instruction[25:21],instruction[20:16],regDstMuxOut,regWrData,highresult,lowresult,regWrite,hiloWrite,clk,regRdData1,regRdData2);
    assign jumpAddress = {tmpNextInstructionAddress[31:28],instruction[25:0],2'b00};
    SigExt16To32bit sigExt16To32(instruction[15:0],extendedImmediate);
    SigExt5To32bit sigExt5To32(instruction[10:6],extendedImmediate2);

    ///*** execute instruction ***///
    ALUCU aluCU(instruction[5:0],aluOP,aluCtrl);
    MUX3To1_32bit aluSrcBMux(regRdData2,extendedImmediate,32'h00000000,aluSrcB,aluSrcDataB);
    MUX2To1_32bit aluSrcAMux(regRdData1,extendedImmediate2,aluSrcA,aluSrcDataA);
    wire [31:0] aluAddtest_tmp_useless;
    ALU alu(aluSrcDataA,aluSrcDataB,aluCtrl,aluResult,highresult,lowresult,psw,aluAddtest_tmp_useless);
    wire [3:0] branchALUpsw_useless;
    wire [31:0] branchALUtest_tmp_useless;
    wire [31:0] branchALUhightest_tmp_useless;
    wire [31:0] branchALUlowtest_tmp_useless;
    ALU branchALU(tmpNextInstructionAddress,(extendedImmediate << 2),5'b00000,branchAddress,branchALUhightest_tmp_useless,branchALUlowtest_tmp_useless,branchALUpsw_useless,branchALUtest_tmp_useless);

    ///*** memory access ***///
    DataMemory dmem(aluResult,regRdData2,memWrite,memRead,memReadData);
    MUX4To1_32bit writeToRegMux(aluResult,memReadData,tmpNextInstructionAddress,tmpNextInstructionAddress,writeToReg,regWrData);
    wire branchpc;
    SingleBranch branchornot(branch,psw,branchpc);
    MUX2To1_32bit branchMux(tmpNextInstructionAddress,branchAddress,branchpc,tmpNextBranchInstructionAddress);
    MUX3To1_32bit jumpMux(tmpNextBranchInstructionAddress,jumpAddress,regRdData1,jump,nextInstructionAddress);

endmodule
