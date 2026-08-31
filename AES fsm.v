`timescale 1ns / 1ps
module aes_fsm (
    input  wire         clk,
    input  wire         rst,
    input  wire         start,

    input  wire [127:0] data_in,
    input  wire [127:0] key,

    output reg  [127:0] ciphertext,
    output reg          done
);

    localparam IDLE    = 3'd0;
    localparam INITIAL_KEY = 3'd1;
    localparam ROUND   = 3'd2;
    localparam FINAL   = 3'd3;
    localparam DONE    = 3'd4;

    reg [2:0] fsm_state;
    reg [3:0] round;
    reg [127:0] state;
    reg [127:0] round_key;
    wire [1407:0] round_keys;
    wire [127:0] mix_columns_out;
    wire [127:0] sub_bytes_out;
    wire [127:0] shift_rows_out;

  
    key_expansion key_exp (
        .key(key),
        .round_keys(round_keys)
    );


    always @(*) begin
       if(round<=4'd10)
        round_key = round_keys[1407 - round*128 -: 128];
       else
        round_key = 128'd0; 
    end


    sub_byte sb (
        .state_in(state),
        .state_out(sub_bytes_out)
    );


  
    shift_row sr (
        .state_in(sub_bytes_out),
        .state_out(shift_rows_out)
    );

  

  
    mix_column mc (
        .state_in(shift_rows_out),
        .state_out(mix_columns_out)
    );

  
  always @(*) begin
    if (!rst) begin
             round      <= 0;
            state      <= 128'b0;
            ciphertext <= 128'b0;
            done       <= 1'b0;
        end
        else begin
            case (fsm_state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        round <= 0;
                     end
                end

                INITIAL_KEY: begin
                    state <= data_in ^ round_keys[1407:1280];
                    round <= 1;
                 end

                ROUND: begin
                    if (round < 10) begin
                        state <= mix_columns_out ^ round_key;
                        round <= round + 1;
                    end
                  else round<=10;
                end

                FINAL: begin
                    state <= shift_rows_out ^ round_key;
                    ciphertext <= shift_rows_out ^ round_key;
                 end

                DONE:done <= 1'b1;
            endcase
        end
    end
  
  
    always @(posedge clk or negedge rst) begin
      if(!rst) fsm_state<=IDLE;
      else begin
        case(fsm_state) 
           IDLE:begin 
           if(start)
             fsm_state<=INITIAL_KEY;
           end
    INITIAL_KEY:  fsm_state<=ROUND;
          
          ROUND:begin 
            if(round==10)  fsm_state<=FINAL;
          end
          
          FINAL:  fsm_state<=DONE;
          
        default: fsm_state<=IDLE;
        endcase
      end
    end
  endmodule
