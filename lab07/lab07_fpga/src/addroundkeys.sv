module addroundkeys(input  logic [127:0] a,
                    input  logic [0:3][7:0] word,
                    output logic [127:0] y);

    logic [0:3][0:3][7:0] aArr, yArr;

    input_to_state input_to_state(a, aArr);

    assign yArr[0:3][0][7:0]) = aArr[0:3][0][7:0] ^ word;
    assign yArr[0:3][1][7:0]) = aArr[0:3][1][7:0] ^ word;
    assign yArr[0:3][2][7:0]) = aArr[0:3][2][7:0] ^ word;
    assign yArr[0:3][3][7:0]) = aArr[0:3][3][7:0] ^ word;

    state_to_output state_to_output(y, yArr);

endmodule