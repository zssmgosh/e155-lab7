`timescale 10ns/1ns

/////////////////////////////////////////////
// state_to_output
//   Copy the 4x4 state array back into a 128-bit value
//   Section 3.4
//   Purely combinational
//
//   The reverse of input_to_state, with the same packing. With both, a
//   module with 128-bit ports like the ones in aes_core can do its work
//   on rows and columns inside.
/////////////////////////////////////////////

module #(parameter COL=4) state_to_output(input  logic [0:3][0:COL-1][7:0] a,
                                          output logic [(32*COL)-1:0]      y);

    genvar i;

    for (i=0; i<COL; i++) begin
        assign y[((COL-1-i)*32+24) +: 8] = a[0][i][7:0];
        assign y[((COL-1-i)*32+16) +: 8] = a[1][i][7:0];
        assign y[((COL-1-i)*32+8)) +: 8] = a[2][i][7:0];
        assign y[((COL-1-i)*32)) +: 8] = a[3][i][7:0];
    end
endmodule