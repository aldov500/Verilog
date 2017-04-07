/*Flip Flop Tipo D*/
module FF_D(d,clk,rst,q,qb);
	input wire d,clk,rst;
	output reg q,qb;
	reg temp=0;

	always@(posedge clk or posedge rst)begin
	if (rst==0)begin 
		temp = d;
	end
	else begin 
		temp =  temp;
	end
		q    =  temp;
		qb   = ~temp;

	end

endmodule
