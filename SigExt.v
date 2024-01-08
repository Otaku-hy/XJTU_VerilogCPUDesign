module SigExt16To32bit(
    input wire [15:0] i_a,
    output wire [31:0] o_y
);
    assign o_y = {{16{i_a[15]}}, i_a};
endmodule

module SigExt5To32bit(
    input wire [4:0] i_a,
    output wire [31:0] o_y
);
    assign o_y = {{27{i_a[4]}}, i_a};
endmodule