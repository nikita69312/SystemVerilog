`timescale 1ns / 1ps
module UartTX_tb#(
    parameter clk_per_bit = 16, 
    parameter bit_n = 8
);
  logic[bit_n-1:0] data_i;
  logic data_rdy;
  logic clk;
  logic rst;
  logic tx_o;
  logic trc_o;
  
  logic data_rdy_o;
  logic [bit_n-1:0] data_o;

UartTX  UartTX_instance(
  .data_rdy(data_rdy),
  .data_i(data_i),
  .clk(clk),
  .rst(rst),
  .tx_o(tx_o),
  .trc_o(trc_o)
);
UartRX  UartRX_instance(
  .data_rdy_o(data_rdy_o),
  .data_o(data_o),
  .clk(clk),
  .rst(rst),
  .rx_i(tx_o)
);
initial begin
    clk = 1;
    forever #10 clk = ~clk;
end
  
initial begin
data_i = 8'b01000111;
data_rdy = 0;
rst = 1;
#40
rst=0;


data_rdy = 0;
#20;

data_rdy = 1;
#20;  
data_rdy = 0;
#100;
rst=1;
#100
rst=0;
data_rdy = 1;
#20
data_rdy = 0;
#10000
data_i = 8'b10011011;
data_rdy = 1;
#20;
data_rdy = 0;
#10000;
$stop;
#1000;

end
endmodule


