module test_bench(
  output reg[1:0]a,
  output reg clk,
  output reg reset,
  input wire out
);

mealy test_mealy(
  .a(a),
  .clk(clk),
  .reset(reset),
  .out(out)
);

always 
begin 
clk = 0; 
#10; 
clk = 1; 
#10; 
end 

initial begin
  reset=1;
  a=00;
  #10;
  reset=0;
  a=10;
  #10;
  a=01;
  #20;
  a=00;
  #20;
  a=01;
  #20;
  a=00;
  #20;
  a=01;
  #20;
  a=00;
  #20;
  a=01;
  #20;
  a=00;
  #20;
  a=01;
  #20;
  a=00;
  #20;
  reset=1;
  a=00;
  #10;
  reset=0;
  a=10;
  #10;
  a=01;
  #20;
  a=00;
  #20;
  a=01;
  #20;
  a=00;
  #20;
  a=01;
  #20;
  a=00;
  #20;
  a=01;
  #20;
  a=00;
  #20;
  a=01;
  #20;
  a=00;
  #20;
    
end
  
endmodule

