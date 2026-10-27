module keyexpansion(input logic clk, reset, en,
                    input logic [3:0] round,
                    input  logic [127:0] key,
                    output logic [127:0] w);

    logic [0:3][0:3][7:0] keyArr, tmp, oldWArr, wArr;
    logic [0:3][7:0] rcon;
    logic [0:3][7:0] tmp0, tmp1, tmp2;
	genvar i,j;

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
            default:  rcon[0][7:0] = '0;
        endcase
    end

    input_to_state input_to_state(key, keyArr);

    always_ff @(posedge round)
        if(reset || (round == 0))
            // logic for initial key that round 0 takes from
            for(i=0;i<4;i++) begin
                for(j=0;j<4;j++) begin
                    oldWArr[i][j][7:0] <= keyArr[j][i][7:0];
                end
            end
        else
            oldWArr <= wArr;

    // logic for newly added keys for a round
    for(i=0;i<3;i++) begin
        assign tmp0[i][7:0] = wArr[i+1][3][7:0];
    end
    assign tmp0[3][7:0] = wArr[0][3][7:0];

    subword subword(clk, reset, en, tmp0, tmp1);

    assign tmp2 = tmp1 ^ rcon;

    for(i=0;i<4;i++) begin
        assign wArr[i][4][7:0] = wArr[i][0][7:0] ^ tmp2[i][7:0];
    end

    for(i=0;i<4;i++) begin
        for(j=0;j<3;j++) begin
            assign wArr[i][j+5][7:0] = wArr[i][j+1][7:0] ^ wArr[i][j+4][7:0];
        end
    end

    state_to_output #(4) state_to_output(wArr, w);
endmodule