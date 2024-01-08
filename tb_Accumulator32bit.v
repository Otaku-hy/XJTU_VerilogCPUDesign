module tb_32bit_Acuumulator;
    reg [31:0] v1;
    reg [31:0] v2;
    reg c0;
    wire [31:0] sum;
    wire carry;

    Accumulator32bit a(
        .i_va(v1),
        .i_vb(v2),
        .i_c0(c0),
        .o_v(sum),
        .o_c32(carry)
    );

    initial begin
        $monitor("v1=%h, v2=%h, c0=%b, sum=%h, carry=%b", v1, v2, c0, sum, carry);
        v1 = 32'h00000000;
        v2 = 32'h00000000;
        c0 = 1'b0;
        #10;
        v1 = 32'h00000001;
        v2 = 32'h00000001;
        c0 = 1'b0;
        #10;
        v1 = 32'h00000001;
        v2 = 32'h00000001;
        c0 = 1'b1;
        #10;
        v1 = 32'h00000001;
        v2 = 32'h00000001;
        c0 = 1'b1;
        #10;
        v1 = 32'h00000001;
        v2 = 32'h00000001;
        c0 = 1'b1;
        #10;
        v1 = 32'h00000001;
        v2 = 32'h00000001;
        c0 = 1'b1;
        #10;
        v1 = 32'h00000001;
        v2 = 32'h00000001;
        c0 = 1'b1;
        #10;
        v1 = 32'h00000001;
        v2 = 32'h00000001;
        c0 = 1'b1;
        #10;
        v1 = 32'h00000005;
        v2 = 32'h00000006;
        c0 = 1'b1;
        #10;
    end
    

endmodule