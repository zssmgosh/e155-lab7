module subbytes(input  logic clk, reset, en,
                input  logic [127:0] a, 
                output logic [127:0] y);

        logic [0:3][0:3][7:0] aArr, yArr;
        logic [3:0] cnt;
        logic [1:0] newr, newc, r, c;

        input_to_state input_to_state(a, aArr);
        
        counter #(3, 15) sbcnt(clk, reset, en, cnt);

        always_ff @(posedge clk) begin
            if(reset) begin
                r <= 2'b0;
                c <= 2'b0;
            end
            else
                if (en) begin
                    r <= newr;
                    c <= newc;
                end
        end

        always_comb
            case(cnt)
                4'h0: begin newr = 2'b00; newc = 2'b00; end
                4'h1: begin newr = 2'b00; newc = 2'b01; end
                4'h2: begin newr = 2'b00; newc = 2'b10; end
                4'h3: begin newr = 2'b00; newc = 2'b11; end
                4'h4: begin newr = 2'b01; newc = 2'b00; end
                4'h5: begin newr = 2'b01; newc = 2'b01; end
                4'h6: begin newr = 2'b01; newc = 2'b10; end
                4'h7: begin newr = 2'b01; newc = 2'b11; end
                4'h8: begin newr = 2'b10; newc = 2'b00; end
                4'h9: begin newr = 2'b10; newc = 2'b01; end
                4'hA: begin newr = 2'b10; newc = 2'b10; end
                4'hB: begin newr = 2'b10; newc = 2'b11; end
                4'hC: begin newr = 2'b11; newc = 2'b00; end
                4'hD: begin newr = 2'b11; newc = 2'b01; end
                4'hE: begin newr = 2'b11; newc = 2'b10; end
                4'hF: begin newr = 2'b11; newc = 2'b11; end
                default: begin newr = 2'b00; newc = 2'b00; end
            endcase

        logic [7:0] bah, mah;
			
		always_comb
			case({r,c})
				2'h00: begin bah = aArr[0][0]; yArr[0][0] = mah; end
                2'h01: begin bah = aArr[0][1]; yArr[0][1] = mah; end
                2'h02: begin bah = aArr[0][2]; yArr[0][2] = mah; end
                2'h03: begin bah = aArr[0][3]; yArr[0][3] = mah; end
                2'h10: begin bah = aArr[1][0]; yArr[1][0] = mah; end
                2'h11: begin bah = aArr[1][1]; yArr[1][1] = mah; end
                2'h12: begin bah = aArr[1][2]; yArr[1][2] = mah; end
                2'h13: begin bah = aArr[1][3]; yArr[1][3] = mah; end
                2'h20: begin bah = aArr[2][0]; yArr[2][0] = mah; end
                2'h21: begin bah = aArr[2][1]; yArr[2][1] = mah; end
                2'h22: begin bah = aArr[2][2]; yArr[2][2] = mah; end
                2'h23: begin bah = aArr[2][3]; yArr[2][3] = mah; end
                2'h30: begin bah = aArr[3][0]; yArr[3][0] = mah; end
                2'h31: begin bah = aArr[3][1]; yArr[3][1] = mah; end
                2'h32: begin bah = aArr[3][2]; yArr[3][2] = mah; end
                2'h33: begin bah = aArr[3][3]; yArr[3][3] = mah; end
				default: begin bah = aArr[0][0]; yArr[0][0] = mah; end
			endcase

        sbox sbox(bah, mah); 

        state_to_output state_to_output(yArr, y);
endmodule