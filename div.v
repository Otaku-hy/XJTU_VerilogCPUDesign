module signed_divider (
  input signed [31:0] numerator,
  input signed [31:0] denominator,
  output signed [31:0] quotient,
  output signed [31:0] remainder
);
  integer i;
  reg signed [31:0] a;
  reg signed [31:0] b;
  reg signed [31:0] q;
  reg signed [31:0] r;

  always @* begin
    a = numerator;
    b = denominator;
    q = 0;
    r = 0;

    if (a < 0) a = -a; // 取被除数的绝对值
    if (b < 0) b = -b; // 取除数的绝对值

    for(i=0;i<64;i=i+1) begin
      if (a >= b) begin
        a = a - b;
        q = q + 1;
      end
    end

    r = a;

    // 确定商和余数的符号
    if (numerator < 0) q = -q;
    if (numerator < 0 && denominator > 0) r = -r;
  end

  assign quotient = q;
  assign remainder = r;

endmodule
