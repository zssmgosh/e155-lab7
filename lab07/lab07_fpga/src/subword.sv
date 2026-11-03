module subword(input   logic clk,
               input   logic [31:0] a, 
               output  logic [31:0] y);
		logic [0:3][7:0] aArr, yArr;
        input_to_state #(1) input_to_state(a, aArr);
        sbox_sync sb1(aArr[0], clk, yArr[0]);
        sbox_sync sb2(aArr[1], clk, yArr[1]);
        sbox_sync sb3(aArr[2], clk, yArr[2]);
        sbox_sync sb4(aArr[3], clk, yArr[3]);
        state_to_output #(1) state_to_output(yArr, y);
endmodule