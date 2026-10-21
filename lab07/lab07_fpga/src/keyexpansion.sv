module keyexpansion(input clk, reset, en,
                    input  logic [127:0] key,
                    input  logic [3:0] round,
                    output logic [256:0] w);

    logic [0:3][0:3][7:0] keyArr, tmp;
    logic [0:3][0:7][7:0] wArr;
    logic [0:3][7:0] rcon;

    assign rcon[1:3][7:0] = '0;

    always_comb begin
        case(round)
            4'h0: rcon[0][7:0] = 8'b00000001;
            4'h1: rcon[0][7:0] = 8'b00000010;
            4'h2: rcon[0][7:0] = 8'b00000100;
            4'h3: rcon[0][7:0] = 8'b00001000;
            4'h4: rcon[0][7:0] = 8'b00010000;
            4'h5: rcon[0][7:0] = 8'b00100000;
            4'h6: rcon[0][7:0] = 8'b01000000;
            4'h7: rcon[0][7:0] = 8'b10000000;
            4'h8: rcon[0][7:0] = 8'b00011011;
            4'h9: rcon[0][7:0] = 8'b00110110;
            default:  rcon[0][7:0] = '0;
        endcase
    end

    input_to_state input_to_state(key, keyArr);

    assign wArr[0:3][0][7:0] = keyArr[0][0:3][7:0];
    assign wArr[0:3][1][7:0] = keyArr[1][0:3][7:0];
    assign wArr[0:3][2][7:0] = keyArr[2][0:3][7:0];
    assign wArr[0:3][3][7:0] = keyArr[3][0:3][7:0];

    logic [0:3][7:0] tmp0, tmp1, tmp2;

    assign tmp0[0:2][7:0] = wArr[1:3][3][7:0];
    assign tmp0[3][7:0] = wArr[0][3][7:0];

    subword subword(clk, reset, en, tmp0, tmp1);

    assign tmp2 = tmp1 ^ rcon;
    assign wArr[0:3][4][7:0] = wArr[0:3][0][7:0] ^ tmp2;

    assign wArr[0:3][5][7:0] = wArr[0:3][1][7:0] ^ wArr[0:3][4][7:0];

    assign wArr[0:3][6][7:0] = wArr[0:3][2][7:0] ^ wArr[0:3][5][7:0];

    assign wArr[0:3][7][7:0] = wArr[0:3][3][7:0] ^ wArr[0:3][6][7:0];

    state_to_output #(8) state_to_output(wArr, w);
endmodule