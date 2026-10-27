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
                default: begin r = 2'b00; newc = 2'b00; end
            endcase

        sbox sbox(aArr[r][c][7:0], yArr[r][c][7:0]); 

        state_to_output state_to_output(yArr, y);
endmodule