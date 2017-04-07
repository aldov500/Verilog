module contador(clk, reset, act, out);
	input wire clk, reset, act;
	output reg [7:0]out;

	always @(posedge clk or negedge reset) begin
		if(reset) 
			out <= 8'b0;
		
		else if(act) 
			out <= out + 1 ;
		
	end

endmodule

module contador2(clk, reset, act, out,updown);
	input wire clk, reset, act, updown	;
	output reg [7:0]out;

	always @(posedge clk or negedge reset) begin
		if(reset) 
			out <= 8'b0;
		
		else if(act)begin

			if(updown)
				out <= out + 1 ;
			
			else if(out>0)
				out <= out - 1 ;

		end else out <= 0;
			
	end
	

endmodule

