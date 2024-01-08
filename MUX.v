module MUX2To1_4bit(
    input wire [3:0] i_a,
    input wire [3:0] i_b,
    input wire i_s,
    output wire [3:0] o_y
);
    assign o_y = i_s ? i_b : i_a;
endmodule

module MUX2To1_5bit(
    input wire [4:0] i_a,
    input wire [4:0] i_b,
    input wire i_s,
    output wire [4:0] o_y
);
    assign o_y = i_s ? i_b : i_a;
endmodule

module MUX4To1_5bit(
    input wire [4:0] i_a,
    input wire [4:0] i_b,
    input wire [4:0] i_c,
    input wire [4:0] i_d,
    input wire [1:0] i_s,
    output wire [4:0] o_y
);
    assign o_y = (i_s == 2'b00) ? i_a : (i_s == 2'b01) ? i_b : (i_s == 2'b10) ? i_c : i_d;

endmodule  

module MUX2To1_8bit(
    input wire [7:0] i_a,
    input wire [7:0] i_b,
    input wire i_s,
    output wire [7:0] o_y
);
    assign o_y = i_s ? i_b : i_a;
endmodule

module MUX2To1_16bit(
    input wire [15:0] i_a,
    input wire [15:0] i_b,
    input wire i_s,
    output wire [15:0] o_y
);
    assign o_y = i_s ? i_b : i_a;
endmodule

module MUX2To1_32bit(
    input wire [31:0] i_a,
    input wire [31:0] i_b,
    input wire i_s,
    output wire [31:0] o_y
);
    assign o_y = i_s ? i_b : i_a;
endmodule

module MUX4To1_32bit(
    input wire [31:0] i_a,
    input wire [31:0] i_b,
    input wire [31:0] i_c,
    input wire [31:0] i_d,
    input wire [1:0] i_s,
    output wire [31:0] o_y
);
    assign o_y = (i_s == 2'b00) ? i_a : (i_s == 2'b01) ? i_b : (i_s == 2'b10) ? i_c : i_d;

endmodule  

module MUX5To1_32bit(
    input wire [31:0] i_a,
    input wire [31:0] i_b,
    input wire [31:0] i_c,
    input wire [31:0] i_d,
    input wire [31:0] i_e,
    input wire [2:0] i_s,
    output wire [31:0] o_y
);
    assign o_y = (i_s == 3'b000) ? i_a : (i_s == 3'b001) ? i_b : (i_s == 3'b010) ? i_c : (i_s == 3'b011) ? i_d : i_e;

endmodule  

module MUX3To1_32bit(
    input wire [31:0] i_a,
    input wire [31:0] i_b,
    input wire [31:0] i_c,
    input wire [1:0] i_s,
    output wire [31:0] o_y
);
    assign o_y = (i_s == 2'b00) ? i_a : (i_s == 2'b01) ? i_b : i_c;

endmodule  

module MUX3To1_5bit(
    input wire [4:0] i_a,
    input wire [4:0] i_b,
    input wire [4:0] i_c,
    input wire [1:0] i_s,
    output wire [4:0] o_y
);
    assign o_y = (i_s == 2'b00) ? i_a : (i_s == 2'b01) ? i_b : i_c;

endmodule  