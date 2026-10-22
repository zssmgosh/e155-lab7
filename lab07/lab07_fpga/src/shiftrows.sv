`timescale 10ns/1ns

/////////////////////////////////////////////
// shiftrows
//   Cyclically shift row r of the state left by r bytes
//   Section 5.1.2, Figure 8
//   Purely combinational
//
//   Uses the same packing as aes_core in aes_starter.sv:
//        [127:120] [95:88] [63:56] [31:24]     S0,0    S0,1    S0,2    S0,3
//        [119:112] [87:80] [55:48] [23:16]     S1,0    S1,1    S1,2    S1,3
//        [111:104] [79:72] [47:40] [15:8]      S2,0    S2,1    S2,2    S2,3
//        [103:96]  [71:64] [39:32] [7:0]       S3,0    S3,1    S3,2    S3,3
//
//   Note that each 32-bit word is a *column* of the state, not a row.
//
//   How you do it is up to you. Either:
//     - move bytes around in the 128-bit vector directly, or
//     - turn a into a state array with your input_to_state from
//       Exercise 1, shift each row of the array, and turn the result back
//       into 128 bits with your state_to_output. Paste your two modules into
//       input_to_state.sv and state_to_output.sv in this project first.
//   The testbench only sees the 128-bit ports, so it checks both the same way.
/////////////////////////////////////////////

module shiftrows(input  logic [127:0] a,
                 output logic [127:0] y);

    logic [0:3][0:3][7:0] aArr, yArr;

    input_to_state input_to_state(a, aArr);
	
    assign yArr[0][0][7:0] = aArr[0][0][7:0];
	assign yArr[0][1][7:0] = aArr[0][1][7:0];
	assign yArr[0][2][7:0] = aArr[0][2][7:0];
	assign yArr[0][3][7:0] = aArr[0][3][7:0];
	
    assign yArr[1][0][7:0] = aArr[1][1][7:0];
	assign yArr[1][1][7:0] = aArr[1][2][7:0];
	assign yArr[1][2][7:0] = aArr[1][3][7:0];
    assign yArr[1][3][7:0] = aArr[1][0][7:0];
	
    assign yArr[2][0][7:0] = aArr[2][2][7:0];
	assign yArr[2][1][7:0] = aArr[2][3][7:0];
	assign yArr[2][2][7:0] = aArr[2][0][7:0];
    assign yArr[2][3][7:0] = aArr[2][1][7:0];
	
    assign yArr[3][0][7:0] = aArr[3][3][7:0];
    assign yArr[3][1][7:0]= aArr[3][0][7:0];
	assign yArr[3][2][7:0]= aArr[3][1][7:0];
	assign yArr[3][3][7:0]= aArr[3][2][7:0];

    state_to_output state_to_output(yArr, y);

endmodule
