module keyexpansion(input logic clk, reset, en,
                    input logic [3:0] round,
                    input  logic [127:0] key,
                    output logic [127:0] roundKey);
    logic [0:3][0:3] roundKeyArr, keyArr;
    logic [0:3][7:0] rcon;
    logic [0:3][7:0] tmp0, tmp1, tmp2;
	genvar i, a, b;

	for(i=0;i<3;i++) begin
		assign rcon[i+1][7:0] = 8'b0;
	end

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
            default:  rcon[0][7:0] = 8'b00110110;
        endcase
    end

    input_to_state #(4) input_to_state(key, keyArr);

    // rotate word
    assign tmp0[3][7:0] = keyArr[0][3][7:0];
    assign tmp0[0][7:0] = keyArr[1][3][7:0];
    assign tmp0[1][7:0] = keyArr[2][3][7:0];
    assign tmp0[2][7:0] = keyArr[3][3][7:0];
    
    // subword(rotateword)
    subword subword(clk, reset, en, tmp0, tmp1);
    
    // subword(rotateword)^rcon
    assign tmp2 = tmp1 ^ rcon;

    assign roundKeyArr[0][0][7:0] = keyArr[0][0][7:0] ^ tmp2[0][7:0];
    assign roundKeyArr[1][0][7:0] = keyArr[1][0][7:0] ^ tmp2[1][7:0];
    assign roundKeyArr[2][0][7:0] = keyArr[2][0][7:0] ^ tmp2[2][7:0];
    assign roundKeyArr[3][0][7:0] = keyArr[3][0][7:0] ^ tmp2[3][7:0];

    assign roundKeyArr[0][1][7:0] = keyArr[0][1][7:0] ^ roundKeyArr[0][0][7:0];
    assign roundKeyArr[1][1][7:0] = keyArr[1][1][7:0] ^ roundKeyArr[1][0][7:0];
    assign roundKeyArr[2][1][7:0] = keyArr[2][1][7:0] ^ roundKeyArr[2][0][7:0];
    assign roundKeyArr[3][1][7:0] = keyArr[3][1][7:0] ^ roundKeyArr[3][0][7:0];

    assign roundKeyArr[0][2][7:0] = keyArr[0][2][7:0] ^ roundKeyArr[0][1][7:0];
    assign roundKeyArr[1][2][7:0] = keyArr[1][2][7:0] ^ roundKeyArr[1][1][7:0];
    assign roundKeyArr[2][2][7:0] = keyArr[2][2][7:0] ^ roundKeyArr[2][1][7:0];
    assign roundKeyArr[3][2][7:0] = keyArr[3][2][7:0] ^ roundKeyArr[3][1][7:0];

    assign roundKeyArr[0][3][7:0] = keyArr[0][3][7:0] ^ roundKeyArr[0][2][7:0];
    assign roundKeyArr[1][3][7:0] = keyArr[1][3][7:0] ^ roundKeyArr[1][2][7:0];
    assign roundKeyArr[2][3][7:0] = keyArr[2][3][7:0] ^ roundKeyArr[2][2][7:0];
    assign roundKeyArr[3][3][7:0] = keyArr[3][3][7:0] ^ roundKeyArr[3][2][7:0];

    state_to_output #(4) state_to_output(roundKeyArr, roundKey);
endmodule