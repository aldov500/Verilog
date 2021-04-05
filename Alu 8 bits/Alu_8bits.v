
module ALU8Bits (inA, inB, sel, clk, reset, result, zero, carry, overF);
	input wire[7:0] inA, inB;
	input wire[2:0] sel;
	input clk, reset;
	
	output reg[7:0] result;
	output reg zero, carry, overF;



	always @(posedge clk or posedge reset) begin
		if(reset) begin
			result = 0;
			zero = 0;
			carry = 0;
			overF = 0;
		end
		else begin
			case (sel)
				4'b0001:	// AND
					result = (inA & inB);
				4'b0010:	// OR
					result = (inA | inB);
				4'b0011:	// XOR
					result = (inA ^ inB);
				4'b0100:	// NAND
					result = !(inA & inB);
				4'b0101:	// NOR
					result = !(inA | inB);
				4'b0111:	// XNOR
					result = !(inA ^ inB);
				
				4'b1000:	// ADD
					result = (inA + inB);
				4'b1001:	// DIF
					result = (inA | inB);
				4'b1011:	// DIV
					result = (inA ^ inB);
				4'b1100:	// PROD
					result = !(inA & inB);
				




				default : result = 0;
			endcase

		end
	end
	


endmodule // ALU8Bits