module subbytes(input  logic clk, reset, en,
                input  logic [127:0] a, 
                output logic [127:0] y);

        logic [0:3][0:3][7:0] aArr, yArr;
        logic [3:0] cnt;
        logic [1:0] newr, newc, r, c;

        input_to_state input_to_state(a, aArr);
        
        sbox_sync sb1(aArr[0][0][7:0], clk, yArr[0][0][7:0]);
        sbox_sync sb1(aArr[0][1][7:0], clk, yArr[0][1][7:0]);
        sbox_sync sb1(aArr[0][2][7:0], clk, yArr[0][2][7:0]);
        sbox_sync sb1(aArr[0][3][7:0], clk, yArr[0][3][7:0]);

        sbox_sync sb1(aArr[1][0][7:0], clk, yArr[1][0][7:0]);
        sbox_sync sb1(aArr[1][1][7:0], clk, yArr[1][1][7:0]);
        sbox_sync sb1(aArr[1][2][7:0], clk, yArr[1][2][7:0]);
        sbox_sync sb1(aArr[1][3][7:0], clk, yArr[1][3][7:0]);

        sbox_sync sb1(aArr[2][0][7:0], clk, yArr[2][0][7:0]);
        sbox_sync sb1(aArr[2][1][7:0], clk, yArr[2][1][7:0]);
        sbox_sync sb1(aArr[2][2][7:0], clk, yArr[2][2][7:0]);
        sbox_sync sb1(aArr[2][3][7:0], clk, yArr[2][3][7:0]);

        sbox_sync sb1(aArr[3][0][7:0], clk, yArr[3][0][7:0]);
        sbox_sync sb1(aArr[3][1][7:0], clk, yArr[3][1][7:0]);
        sbox_sync sb1(aArr[3][2][7:0], clk, yArr[3][2][7:0]);
        sbox_sync sb1(aArr[3][3][7:0], clk, yArr[3][3][7:0]);

        state_to_output state_to_output(yArr, y);
endmodule