`timescale 1ns / 1ps
module mix_column(
    input  wire [127:0] state_in,
    output wire [127:0] state_out
);

    function automatic [7:0] xtime(input [7:0] a);
        begin
            if (a[7]) 
                xtime = (a << 1) ^ 8'h1b;
            else      
                xtime = a << 1;
        end
    endfunction

  
    function automatic [7:0] mul3(input [7:0] a);
        begin
            mul3 = xtime(a) ^ a;
        end
    endfunction


    wire [7:0] b0  = state_in[127:120];
    wire [7:0] b1  = state_in[119:112];
    wire [7:0] b2  = state_in[111:104];
    wire [7:0] b3  = state_in[103:96];
    
    wire [7:0] b4  = state_in[95:88];
    wire [7:0] b5  = state_in[87:80];
    wire [7:0] b6  = state_in[79:72];
    wire [7:0] b7  = state_in[71:64];
    
    wire [7:0] b8  = state_in[63:56];
    wire [7:0] b9  = state_in[55:48];
    wire [7:0] b10 = state_in[47:40];
    wire [7:0] b11 = state_in[39:32];
    
    wire [7:0] b12 = state_in[31:24];
    wire [7:0] b13 = state_in[23:16];
    wire [7:0] b14 = state_in[15:8];
    wire [7:0] b15 = state_in[7:0];

    wire [7:0] r0  = xtime(b0) ^ mul3(b1) ^ b2       ^ b3;
    wire [7:0] r1  = b0       ^ xtime(b1) ^ mul3(b2) ^ b3;
    wire [7:0] r2  = b0       ^ b1       ^ xtime(b2) ^ mul3(b3);
    wire [7:0] r3  = mul3(b0) ^ b1       ^ b2       ^ xtime(b3);

    wire [7:0] r4  = xtime(b4) ^ mul3(b5) ^ b6       ^ b7;
    wire [7:0] r5  = b4       ^ xtime(b5) ^ mul3(b6) ^ b7;
    wire [7:0] r6  = b4       ^ b5       ^ xtime(b6) ^ mul3(b7);
    wire [7:0] r7  = mul3(b4) ^ b5       ^ b6       ^ xtime(b7);

    wire [7:0] r8  = xtime(b8) ^ mul3(b9) ^ b10      ^ b11;
    wire [7:0] r9  = b8       ^ xtime(b9) ^ mul3(b10) ^ b11;
    wire [7:0] r10 = b8       ^ b9       ^ xtime(b10) ^ mul3(b11);
    wire [7:0] r11 = mul3(b8) ^ b9       ^ b10      ^ xtime(b11);

    wire [7:0] r12 = xtime(b12) ^ mul3(b13) ^ b14      ^ b15;
    wire [7:0] r13 = b12       ^ xtime(b13) ^ mul3(b14) ^ b15;
    wire [7:0] r14 = b12       ^ b13       ^ xtime(b14) ^ mul3(b15);
    wire [7:0] r15 = mul3(b12) ^ b13       ^ b14      ^ xtime(b15);

  
    assign state_out = { r0,  r1,  r2,  r3,  
                         r4,  r5,  r6,  r7,  
                         r8,  r9,  r10, r11, 
                         r12, r13, r14, r15 };

endmodule
