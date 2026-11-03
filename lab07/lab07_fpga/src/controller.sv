module controller(input logic clk, reset, 
                  input logic [2:0] count,
                  output logic SBen, SRen, MCen, ARen, KEen, NSen);
    always_ff @(posedge clk, negedge reset)
        if(~reset)
            {SBen, SRen, MCen, ARen, KEen, NSen} <= 6'b0;
        else begin
            SBen <= (count == 0);
            SRen <= (count == 1);
            MCen <= (count == 2);
            ARen <= (count == 3);
            KEen <= (count == 0);
            NSen <= (count == 4);
        end
endmodule