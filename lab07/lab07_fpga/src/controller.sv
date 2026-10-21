module controller(input logic clk, reset, 
                  input logic [4:0] count,
                  output logic SBen, SRen, MCen, ARen, KEen, NSen);
    always_ff @(posedge clk, negedge reset)
        if(reset)
            {SBen, SRen, MCen, ARen, KEen, NSen} = 6'b0;
        else begin
            SBen <= (count < 16);
            SRen <= (count == 16);
            MCen <= (count == 17);
            ARen <= (count == 18);
            KEen <= (count < 4);
            NSen <= (count == 19);
        end
endmodule