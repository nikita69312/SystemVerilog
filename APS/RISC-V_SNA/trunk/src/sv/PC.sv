module PC(
    input logic clk,
    input logic rst,
    input logic [31:0]ADD,
    output logic [31:0]addr
);
always_ff @(posedge clk)begin
  if(rst)begin
    addr<=0;
  end
  else begin
      addr<=ADD;
      end
end
endmodule