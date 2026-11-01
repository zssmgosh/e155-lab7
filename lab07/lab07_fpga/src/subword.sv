module subword(input   logic clk, reset, en,
               input   logic [31:0] a, 
               output  logic [31:0] y);

        logic [0:3][0:3][7:0] aArr, yArr;
        logic [1:0] cnt;
        logic [1:0] r, newr;

        input_to_state input_to_state(a, aArr);
        
        counter #(2, 3) sbcnt(clk, reset, en, cnt);

        always_ff @(posedge clk, posedge reset)
            if(reset) 
                r <= 2'b0;
            else
                if (en) 
                    r <= newr;

        always_comb
            case(cnt)
                2'h0: newr = 2'b00;
                2'h1: newr = 2'b01;
                2'h2: newr = 2'b10;
                2'h3: newr = 2'b11;
                default: newr = 2'b00;
            endcase
			
		logic [7:0] bah, mah;
			
		always_comb
			case(r)
				2'h0: begin bah = aArr[0]; yArr[0] = mah; end
                2'h1: begin bah = aArr[1]; yArr[1] = mah; end
                2'h2: begin bah = aArr[2]; yArr[2] = mah; end
                2'h3: begin bah = aArr[3]; yArr[3] = mah; end
				default: begin bah = aArr[0]; yArr[0] = mah; end
			endcase

        sbox sbox(bah, mah); 
        state_to_output state_to_output(yArr, y);
endmodule