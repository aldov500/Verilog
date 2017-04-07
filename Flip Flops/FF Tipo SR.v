/*Flip Flop Tipo SR*/
module FF_SR(s,r,clk,rst, q,qb);
	input wire s,r,clk,rst;
	output reg q,qb;
	reg [1:0]sr;
	
	always@(posedge clk or posedge rst) begin
		sr={s,r};
		if(rst==0)begin
			case (sr)
				2'b01: q = 1'b0;
				2'b10: q = 1'b1;
				2'b11: q = 1'b1;
				default: begin end
				
			endcase
		end
		else begin
			q = 1'b0;
		end
		qb = ~q;
	end

endmodule