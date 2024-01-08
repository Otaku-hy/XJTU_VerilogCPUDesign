module MultiBranch(
    input wire [5:0] branch,
    input wire [3:0] psw,
    output wire branchpc
);
    assign branchpc = (branch[5] & psw[0]) | (branch[4] & ~psw[0]) | (branch[3] & ~(psw[3] ^ psw[2])) | (branch[2] & (psw[3] ^ psw[2])) |
                      (branch[1] & ~(psw[3] ^ psw[2]) & ~psw[0]) | (branch[0] & ((psw[3] ^ psw[2]) | psw[0]));
endmodule