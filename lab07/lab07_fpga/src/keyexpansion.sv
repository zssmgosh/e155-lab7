module keyexpansion(input logic clk, reset, en,
                    input logic [3:0] round,
                    input  logic [127:0] key,
                    output logic [127:0] w);

    logic [0:3][0:3][7:0] keyArr, tmp, oldWArr, wArr;
    logic [0:3][7:0] rcon;
    logic [0:3][7:0] tmp0, tmp1, tmp2;
	genvar i, a, b, c, d;

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

    input_to_state input_to_state(key, keyArr);

    always_ff @(posedge round[0], negedge round[0], posedge reset)
        if(reset || (round == 0))
            // logic for initial key that round 0 takes from
			for(int k=0;k<4;k=k+1) begin
				for(int j=0;j<4;j=j+1) begin
					oldWArr[k][j][7:0] <= keyArr[j][k][7:0];
				end
			end
        else begin
            if (round < 10)
                oldWArr <= wArr;
            else
                oldWArr <= oldWArr;
            end

    // logic for newly added keys for a round
    for(a=0;a<3;a++) begin
        assign tmp0[a][7:0] = oldWArr[a+1][3][7:0];
    end
    assign tmp0[3][7:0] = wArr[0][3][7:0];

    subword subword(clk, reset, en, tmp0, tmp1);

    assign tmp2 = tmp1 ^ rcon;

    for(b=0;b<4;b++) begin
        assign wArr[b][4][7:0] = wArr[b][0][7:0] ^ tmp2[b][7:0];
    end
	
	for(c=0;c<4;c++) begin
		for(d=0;d<3;d++)begin
			assign wArr[c][d+5][7:0] = wArr[c][d+1][7:0] ^ wArr[c][d+4][7:0];
		end
	end

    state_to_output #(4) state_to_output(wArr, w);
endmodule