module subword(input   logic clk,
               input   logic [0:3][7:0] a, 
               output  logic [0:3][7:0] y);
        sbox_sync sb1(a[0], clk, y[0]);
        sbox_sync sb2(a[1], clk, y[1]);
        sbox_sync sb3(a[2], clk, y[2]);
        sbox_sync sb4(a[3], clk, y[3]);
endmodule