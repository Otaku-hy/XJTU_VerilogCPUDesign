module SingleCycleCPU_tb;
  reg clk;
  // Instantiate the singleCycleCPU module
  SingleCycleCPU cpu_inst (
    .clk(clk)
  );

  // Clock generation
  always #100 clk = ~clk;


  // Test stimulus
  initial begin
    // Initialize inputs

    /* 
        AC030040 sw $3, 64($0)
        8C240002 lw $4, 2($1)
        00a63820 add $7, $5, $6
        1509FFFF bne $8, $9, -1
        1109FFFF beq $8, $9, -1
        08000002 j 2
    */

    clk <= 1'b0;

    $readmemh("./TestData/lw_RF.txt",cpu_inst.regFile.registers);
    $readmemh("./TestData/lw_Mem.txt",cpu_inst.imem.memory);
    $readmemh("./TestData/lw_Mem.txt",cpu_inst.dmem.memory);

    #6000
    $finish;
  end
endmodule