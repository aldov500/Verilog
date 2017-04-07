/*Modulo Sumador y Restador Sincrono*/

module Sum_Rest (clk, sel, ent1, ent2, sal);
	input wire clk, sel;
	input wire[3:0] ent1;
	input wire[3:0] ent2;
	output reg[4:0] sal;

	always @(posedge clk or negedge clk) begin
		
		if(sel) sal = ent1 + ent2;
		 
		else sal = ent1 - ent2;
		
	end

endmodule
