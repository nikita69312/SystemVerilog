module UartTX #(
    parameter clk_per_bit = 16, 
    parameter bit_n = 8
) (
    input  logic             data_rdy,
    input  logic [bit_n-1:0] data_i,
    input  logic             clk,
    input  logic             rst,          
    output logic             tx_o ,
    output logic             trc_o 


);


logic [3:0] number_bit ;
logic [clk_per_bit-1:0] counter_bit;
logic [bit_n-1:0] data_tx;


typedef enum {IDLE, START, DATA, STOP} state_t;
state_t state;
  


  always @(posedge clk) begin

    if(rst)begin

      number_bit   = 0;
      counter_bit  = 0;
      tx_o         = 1;
      trc_o        = 1; 
      state <= IDLE;
      data_tx = 0 ;

    end 

  else begin

      if (counter_bit == (clk_per_bit - 1) )begin
              counter_bit <= 0;
              number_bit  <= number_bit + 1'b1;
         end else  begin
            counter_bit <= counter_bit + 1'b1;
         end
      case(state)
        IDLE:
        if(data_rdy)begin
           counter_bit <= 0;
           data_tx <= data_i;
           state<=START;
          end
      else begin
          trc_o <= 1;
          tx_o <= 1;
        end
        START:begin
            if(counter_bit == (clk_per_bit - 1))begin
                number_bit <= 0;
                state <= DATA ;
              end
                tx_o <= 1'b0;
                trc_o <= 1'b0;
        end
        DATA: begin
            if(number_bit==(bit_n-1) && counter_bit == (clk_per_bit - 1))
              state <= STOP;

          else
            tx_o <= data_tx[number_bit];
            end
        STOP: if (counter_bit == (clk_per_bit - 1)) begin
                  state <=IDLE;
              end
              else begin
                tx_o <= 1'b1; 
              end
      endcase
      end
      
  end

endmodule