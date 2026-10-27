module subword(input   logic clk, reset, en,
               input   logic [31:0] a, 
               output  logic [31:0] y);

        logic [0:3][0:3][7:0] aArr, yArr;
        logic [1:0] cnt;
        logic [1:0] r, newr;

        input_to_state input_to_state(a, aArr);
        
        counter #(2, 3) sbcnt(clk, reset, en, cnt);

        always_ff @(posedge clk)
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
                default: r = 2'b00;
            endcase

        sbox sbox(aArr[r][7:0], yArr[r][7:0]); 

        state_to_output state_to_output(yArr, y);
endmodule