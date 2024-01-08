module Accumulator4bit(
        input [3:0] i_va,
        input [3:0] i_vb,
        input i_c0,
        output [3:0] o_v,
        output o_c4
);
    wire [3:0] g, p, c;
    assign g = i_va & i_vb;
    assign p = i_va ^ i_vb;

    assign c[0] = g[0] | (p[0] & i_c0);
    assign c[1] = g[1] | (p[1] & c[0]);
    assign c[2] = g[2] | (p[2] & c[1]);
    assign c[3] = g[3] | (p[3] & c[2]);

    assign o_v[0] = p[0] ^ i_c0;
    assign o_v[1] = p[1] ^ c[0];
    assign o_v[2] = p[2] ^ c[1];
    assign o_v[3] = p[3] ^ c[2];

    // Carry out
    assign o_c4 = c[3];
endmodule

module Accumulator32bit(
    input [31:0] i_va,
    input [31:0] i_vb,
    input i_c0,
    output [31:0] o_v,
    output o_c32
);
    wire [7:0] c;

    Accumulator4bit a0(i_va[3:0],i_vb[3:0],i_c0,o_v[3:0],c[0]);
    Accumulator4bit a1(i_va[7:4],i_vb[7:4],c[0],o_v[7:4],c[1]);
    Accumulator4bit a2(i_va[11:8],i_vb[11:8],c[1],o_v[11:8],c[2]);
    Accumulator4bit a3(i_va[15:12],i_vb[15:12],c[2],o_v[15:12],c[3]);
    Accumulator4bit a4(i_va[19:16],i_vb[19:16],c[3],o_v[19:16],c[4]);
    Accumulator4bit a5(i_va[23:20],i_vb[23:20],c[4],o_v[23:20],c[5]);
    Accumulator4bit a6(i_va[27:24],i_vb[27:24],c[5],o_v[27:24],c[6]);
    Accumulator4bit a7(i_va[31:28],i_vb[31:28],c[6],o_v[31:28],c[7]);

    assign o_c32 = c[7];


endmodule