module core_fsm(input logic clk, load,
                input logic [127:0] plaintext, key, expKey, AROut, MCres,
                output logic [127:0] oldKey, roundIn, cyphertext, ARin, ARKey,
				input logic [3:0] roundCnt, 
				output logic done);
	logic [127:0] roundOut;
	
    typedef enum logic [3:0] {START=4'b0001, WAIT=4'b0010, STOP=4'b0100, FIRST=4'b1000} statetype;
	statetype state, nextState;

    always_ff @(posedge clk) begin
        if(load) begin
            roundIn <= AROut;
            oldKey <= key;
			state <= FIRST;
		end
        else begin
			state <= nextState;
            if(nextState==START) begin
                roundIn <= roundOut;
                oldKey <= expKey;
			end
		end
	end
	
	always_comb begin
		case(state)
			START: nextState = WAIT;
			WAIT: if (roundCnt < 10) nextState = START; else nextState = STOP; // one cycle latency for subbytes and keyexpansion
			STOP: nextState = STOP;
			FIRST: nextState = WAIT;
			default: nextState = STOP;
		endcase
	end

	assign cyphertext = (state == WAIT) ? AROut: roundIn;
	assign ARin = (state == FIRST) ? plaintext : MCres;
	assign ARKey = (state == FIRST) ? key : expKey;
	assign done = (state == STOP);
	assign roundOut = (state == STOP) ? roundIn : AROut;
endmodule