module tb_ALU8Bits (tb_inA, tb_inB, tb_sel, tb_clk, tb_reset, tb_result, tb_zero, tb_carry, tb_overF);
	output reg[7:0] tb_inA, tb_inB;
	output reg[2:0] tb_sel;
	output reg tb_clk, tb_reset;

	input wire[7:0] tb_result;
	input wire tb_zero, tb_carry, tb_overF;

	ALU8Bits instancia (
		.inA(tb_inA), .inB(tb_inB),
		.sel(tb_sel), .clk(tb_clk), .reset(tb_reset),
		.result(tb_result), .zero(tb_zero), .carry(tb_carry), .overF(tb_overF)
		);

	initial begin
		$monitor("Entradas: A[%00000000b], B[%00000000b], Sel[%00b] Resultados: Out[%00000000b], Zero[%b], Carry[%b], OverFlow[%b]",tb_inA, tb_inB, tb_sel, tb_result, tb_zero, tb_carry, tb_overF );
		tb_clk = 0;
		tb_reset = 1;
		tb_sel = 1;
		tb_inA = 8'b00110011;
		tb_inB = 8'b10100111;
		#10;
		tb_reset = 0;
		#1000;


	end

	always #5 tb_clk = !tb_clk;

endmodule
