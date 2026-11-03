module controller(input logic clk, reset, 
                  input logic [2:0] count,
                  output logic SBen, SRen, MCen, ARen, KEen, NSen);
    always_ff @(posedge clk, negedge reset)
        if(~reset)
            {SBen, SRen, MCen, ARen, KEen, NSen} <= 6'b0;
        else begin
            SBen <= (count == 1);
            SRen <= (count == 2);
            MCen <= (count == 3);
            ARen <= (count == 4);
            KEen <= (count == 1);
            NSen <= (count == 5);
        end
endmodule