module subbytes(input  logic clk, reset, en,
                input  logic [127:0] a, 
                output logic [127:0] y);

        logic [0:3][0:3][7:0] aArr, yArr;
        logic [3:0] cnt;
        logic [1:0] r, c;

        input_to_state input_to_state(a, aArr);
        
        counter #(3, 15) sbcnt(clk, reset, en, cnt);

        always_comb
            case(cnt)
                4'h0: begin r = 2'b00; c = 2'b00; end
                4'h1: begin r = 2'b00; c = 2'b01; end
                4'h2: begin r = 2'b00; c = 2'b10; end
                4'h3: begin r = 2'b00; c = 2'b11; end
                4'h4: begin r = 2'b01; c = 2'b00; end
                4'h5: begin r = 2'b01; c = 2'b01; end
                4'h6: begin r = 2'b01; c = 2'b10; end
                4'h7: begin r = 2'b01; c = 2'b11; end
                4'h8: begin r = 2'b10; c = 2'b00; end
                4'h9: begin r = 2'b10; c = 2'b01; end
                4'hA: begin r = 2'b10; c = 2'b10; end
                4'hB: begin r = 2'b10; c = 2'b11; end
                4'hC: begin r = 2'b11; c = 2'b00; end
                4'hD: begin r = 2'b11; c = 2'b01; end
                4'hE: begin r = 2'b11; c = 2'b10; end
                4'hF: begin r = 2'b11; c = 2'b11; end
                default: begin r = 2'b00; c = 2'b00; end
            endcase

        sbox sbox(aArr[r][c][7:0], yArr[r][c][7:0]); 

        state_to_output state_to_output(yArr, y);
endmodule