module MultipleCycleCPU_tb;
    reg clk;
    
    MultipleCycleCPU cpu_inst (
        .clk(clk)
    );

    always #100 clk = ~clk;

    /***
        in memory, we assume 0~39bytes are instructions, 40~79bytes are data
        AC030040 sw $3, 64($1)
        8C240002 lw $4, 2($1)
        00a63820 add $7, $5, $6
        1109FFFF beq $8, $9, -1
        08000002 j 2
    ***/

    initial begin
        clk <= 1'b0;

        $readmemh("./TestData/lw_RF.txt",cpu_inst.regFile.registers);
        $readmemh("./TestData/lw_Mem.txt",cpu_inst.dmem.memory);
        #10000
        $finish;
    end

endmodule