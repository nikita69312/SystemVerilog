module UartRX#(
    parameter clk_per_bit = 16, 
    parameter bit_n = 8
) (
    output logic             data_rdy_o, 
    output logic [bit_n-1:0] data_o, 
    input  logic             clk,
    input  logic             rst,
    input  logic             rx_i          
    
);
logic [bit_n-1:0] data;
logic [3:0] number_bit ;
logic [clk_per_bit-1:0] counter_bit;

typedef enum {IDLE, START, DATA, STOP} state_t;
state_t state;

always_ff @(posedge clk)begin
    if(rst)begin

      data_rdy_o   = 0;
      data_o  = 0;
      state <= IDLE;
      data = 0 ;
      number_bit   = 0;
      counter_bit  = 0;
    end
    else begin
        if (counter_bit == (clk_per_bit - 1) )begin
              counter_bit <= 1;
              number_bit  <= number_bit + 1'b1;
         end else begin
              counter_bit <= counter_bit + 1'b1;
         end
    case(state)
        IDLE:
        if(!rx_i)begin
          counter_bit <= 0;
          state<=START;
          end       
      else begin
          data_rdy_o<= 0;
          data_o <= data;
        end
        START:begin
            if(counter_bit == (clk_per_bit - 1))begin
                number_bit <= 0;
                state <= DATA ;
              end
        end
        DATA: begin
            if(number_bit==(bit_n-1) && counter_bit == (clk_per_bit - 1) )begin
                  state <= STOP;
            end
          else 
            data[number_bit] <= rx_i;
            end
        STOP: if (counter_bit == (clk_per_bit - 1)) begin
                data_rdy_o <= 1;
                state<=IDLE;
              end

      endcase
    end
end
endmodule 
