module subbytes(input  logic clk,
                input  logic [127:0] a, 
                output logic [127:0] y);

        logic [0:3][0:3][7:0] aArr, yArr;
        input_to_state input_to_state(a, aArr);
        
        sbox_sync sb1(aArr[0][0][7:0], clk, yArr[0][0][7:0]);
        sbox_sync sb2(aArr[0][1][7:0], clk, yArr[0][1][7:0]);
        sbox_sync sb3(aArr[0][2][7:0], clk, yArr[0][2][7:0]);
        sbox_sync sb4(aArr[0][3][7:0], clk, yArr[0][3][7:0]);

        sbox_sync sb5(aArr[1][0][7:0], clk, yArr[1][0][7:0]);
        sbox_sync sb6(aArr[1][1][7:0], clk, yArr[1][1][7:0]);
        sbox_sync sb7(aArr[1][2][7:0], clk, yArr[1][2][7:0]);
        sbox_sync sb8(aArr[1][3][7:0], clk, yArr[1][3][7:0]);

        sbox_sync sb9(aArr[2][0][7:0], clk, yArr[2][0][7:0]);
        sbox_sync sb10(aArr[2][1][7:0], clk, yArr[2][1][7:0]);
        sbox_sync sb11(aArr[2][2][7:0], clk, yArr[2][2][7:0]);
        sbox_sync sb12(aArr[2][3][7:0], clk, yArr[2][3][7:0]);

        sbox_sync sb13(aArr[3][0][7:0], clk, yArr[3][0][7:0]);
        sbox_sync sb14(aArr[3][1][7:0], clk, yArr[3][1][7:0]);
        sbox_sync sb15(aArr[3][2][7:0], clk, yArr[3][2][7:0]);
        sbox_sync sb16(aArr[3][3][7:0], clk, yArr[3][3][7:0]);

        state_to_output state_to_output(yArr, y);
endmodule