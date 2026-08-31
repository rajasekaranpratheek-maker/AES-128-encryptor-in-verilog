`timescale 1ns / 1ps
module shift_row(
    input  wire [127:0] state_in,
    output reg  [127:0] state_out
);
  reg [7:0]b[0:15];
integer i;
    always @(*) begin
      for(i=0;i<16;i=i+1) begin
        b[i]=state_in[127-i*8-:8];
      end
      state_out={b[0],  b[5],  b[10], b[15],
            b[4],  b[9],  b[14], b[3],
            b[8],  b[13], b[2],  b[7],
            b[12], b[1],  b[6],  b[11]
        };
    end

endmodule
