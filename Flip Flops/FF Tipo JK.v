/*Flip Flop Tipo JK*/
module FF_JK(j,k,clk,rst, q,qb);
	input wire j,k,clk,rst;
	output reg q,qb;
	reg [1:0]jk;
	
	always@(posedge clk or posedge rst) begin
		jk={j,k};
		if(rst==0) begin
			case (jk)
				2'b01: q = 1'b0;
				2'b10: q = 1'b1;
				2'b11: q = ~q;
				default: begin end
			endcase
		end
		else
			q = 1'b0;
 			qb =~q;
		end
endmodule
