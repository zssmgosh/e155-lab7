/////////////////////////////////////////////
// input_to_state
//   Copy a 128-bit value into the 4x4 state array
//   Section 3.4
//   Purely combinational
//
//   The input uses the same packing as aes_core in aes_starter.sv:
//        [127:120] [95:88] [63:56] [31:24]     S0,0    S0,1    S0,2    S0,3
//        [119:112] [87:80] [55:48] [23:16]     S1,0    S1,1    S1,2    S1,3
//        [111:104] [79:72] [47:40] [15:8]      S2,0    S2,1    S2,2    S2,3
//        [103:96]  [71:64] [39:32] [7:0]       S3,0    S3,1    S3,2    S3,3
//
//   The output is the state array, indexed y[r][c] for row r, column c,
//   just like the grids in FIPS-197.
//
//   The ranges are [0:3], not [3:0], on purpose: y[0][0] is the leftmost
//   byte, so a value written row by row,
//        {8'h32, 8'h88, 8'h31, 8'he0,    // row 0
//         8'h43, 8'h5a, 8'h31, 8'h37,    // row 1
//         ...}
//   fills row 0 first and reads like the grids in the standard.
//
//   Because y is packed, it is also 128 bits wide, so `assign y = a;`
//   compiles. It is not the answer. Work out why in Part A.
/////////////////////////////////////////////

module input_to_state #(parameter COL=4) (input  logic [(COL*32)-1:0]      a,
                                         output logic [0:3][0:COL-1][7:0] y);

    genvar i;

    for (i=0; i<COL; i++) begin
        assign y[0][i][7:0] = a[((COL-1-i)*32+24) +: 8];
        assign y[1][i][7:0] = a[((COL-1-i)*32+16) +: 8];
        assign y[2][i][7:0] = a[((COL-1-i)*32+8) +: 8];
        assign y[3][i][7:0] = a[((COL-1-i)*32) +: 8];
    end
endmodule
