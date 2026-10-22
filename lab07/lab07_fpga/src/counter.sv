// Huanhuan Huang huahuang@hmc.edu 9/12/2026
// build a configurable counter to flash an led at a specific frequency

module counter #(parameter N=23, MAX_COUNT=10000000)(
        input logic clk, reset, enable,
		output logic [N:0] counter
    );
	
    always_ff @(posedge clk, posedge reset)
		if (reset)
			begin
				counter <= 0;
			end
		else 
			if (enable)
				if (counter > MAX_COUNT)
					begin
						counter <= 0;
					end
				else
					begin
						counter <= counter + 1;
					end
endmodule