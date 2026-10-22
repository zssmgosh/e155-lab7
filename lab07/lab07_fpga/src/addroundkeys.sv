module addroundkeys(input  logic [127:0] a,
                    input  logic [0:3][7:0] word,
                    output logic [127:0] y);

    logic [0:3][0:3][7:0] aArr, yArr;

    input_to_state input_to_state(a, aArr);

    genvar i, j;

    for (i=0;i<4;i++) begin
        for(j=0;j<4;j++) begin
            assign yArr[i][j][7:0] = aArr[i][j][7:0] ^ word[j][7:0];
        end
    end
    
    state_to_output state_to_output(y, yArr);

endmodule