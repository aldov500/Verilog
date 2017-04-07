/*Flip Flop Tipo T*/
module FF_T(t,clk,rst, q,qb);
	input wire t,clk,rst;
	output reg q,qb;
	reg temp = 0;

	always@(posedge clk or posedge rst)begin
		if(rst == 0) begin
			if(t   == 1) temp = ~ temp;
			else temp=temp;

		end

		q  =  temp;
		qb = ~temp;

	end

endmodule

