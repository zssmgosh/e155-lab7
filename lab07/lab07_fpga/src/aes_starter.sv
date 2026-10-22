/////////////////////////////////////////////
// aes
//   Top level module with SPI interface and SPI core
/////////////////////////////////////////////

module aes(input  logic clk,
           input  logic sck, 
           input  logic sdi,
           output logic sdo,
           input  logic load,
           output logic done);
                    
    logic [127:0] key, plaintext, cyphertext;
            
    aes_spi spi(sck, sdi, sdo, done, key, plaintext, cyphertext);   
    aes_core core(clk, load, key, plaintext, done, cyphertext);
endmodule

/////////////////////////////////////////////
// aes_spi
//   SPI interface.  Shifts in key and plaintext
//   Captures ciphertext when done, then shifts it out
//   Tricky cases to properly change sdo on negedge clk
/////////////////////////////////////////////

module aes_spi(input  logic sck, 
               input  logic sdi,
               output logic sdo,
               input  logic done,
               output logic [127:0] key, plaintext,
               input  logic [127:0] cyphertext);

    logic         sdodelayed, wasdone;
    logic [127:0] cyphertextcaptured;
               
    // assert load
    // apply 256 sclks to shift in key and plaintext, starting with plaintext[127]
    // then deassert load, wait until done
    // then apply 128 sclks to shift out cyphertext, starting with cyphertext[127]
    // SPI mode is equivalent to cpol = 0, cpha = 0 since data is sampled on first edge and the first
    // edge is a rising edge (clock going from low in the idle state to high).
    always_ff @(posedge sck)
        if (!wasdone)  {cyphertextcaptured, plaintext, key} = {cyphertext, plaintext[126:0], key, sdi};
        else           {cyphertextcaptured, plaintext, key} = {cyphertextcaptured[126:0], plaintext, key, sdi}; 
    
    // sdo should change on the negative edge of sck
    always_ff @(negedge sck) begin
        wasdone = done;
        sdodelayed = cyphertextcaptured[126];
    end
    
    // when done is first asserted, shift out msb before clock edge
    assign sdo = (done & !wasdone) ? cyphertext[127] : sdodelayed;
endmodule

/////////////////////////////////////////////
// aes_core
//   top level AES encryption module
//   when load is asserted, takes the current key and plaintext
//   generates cyphertext and asserts done when complete 11 cycles later
// 
//   See FIPS-197 with Nk = 4, Nb = 4, Nr = 10
//
//   The key and message are 128-bit values packed into an array of 16 bytes as
//   shown below
//        [127:120] [95:88] [63:56] [31:24]     S0,0    S0,1    S0,2    S0,3
//        [119:112] [87:80] [55:48] [23:16]     S1,0    S1,1    S1,2    S1,3
//        [111:104] [79:72] [47:40] [15:8]      S2,0    S2,1    S2,2    S2,3
//        [103:96]  [71:64] [39:32] [7:0]       S3,0    S3,1    S3,2    S3,3
//
//   Equivalently, the values are packed into four words as given
//        [127:96]  [95:64] [63:32] [31:0]      w[0]    w[1]    w[2]    w[3]
/////////////////////////////////////////////

module aes_core(input  logic         clk, 
                input  logic         load,
                input  logic [127:0] key, 
                input  logic [127:0] plaintext, 
                output logic         done, 
                output logic [127:0] cyphertext);

    logic [4:0] cycleCnt;
    logic [3:0] roundCnt;
    logic SBen, SRen, MCen, ARen, KEen, NSen;
    logic [127:0] state, nextState, SBout, SRin, SRout, MCin, MCout, MCres, ARin;
    logic [255:0] expKey;

    counter #(5, 20) cycleCnter(.clk, .reset(load), .enable(1), .counter(cycleCnt));
    counter #(4, 10) roundCnter(.clk, .reset(load), .enable(cycleCnt == 19), .counter(roundCnt));

    controller controller(.clk, .reset(load), .count(cycleCnt), .SBen, .SRen, .MCen, .ARen, .KEen, .NSen);
    
    keyexpansion temp(.clk, .reset(load), .en(KEen), .key, .round(roundCnt), .w(expKey));

    subbytes SB(.clk, .reset(load), .en(SBen), .a(state), .y(SBout));
    shiftrows SR(.a(SRin), .y(SRout));
    mixcolumns MC(.a(MCin), .y(MCout));
    addroundkeys AR(.a(ARin), .word(), .y(nextState));

    always_ff @(posedge clk)
        if(load)
            state <= plaintext;
        else
            if(NSen)
                state <= nextState;

    assign MCres = (roundCnt == 9) ? MCin : MCout;
    flopren #(128) SBSRflop(.clk, .reset(load), .en(SRen), .d(SBout), .q(SRin));
    flopren #(128) SRMCflop(.clk, .reset(load), .en(MCen), .d(SRout), .q(MCin));
    flopren #(128) MCARflop(.clk, .reset(load), .en(ARen), .d(MCres), .q(ARin));
    
endmodule