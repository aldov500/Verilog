/*Test Bench FF Tipo T*/
module TB_FF_T(tb_t, tb_clk, tb_rst, tb_q, tb_qb);
	output reg tb_t, tb_clk, tb_rst;
	input wire tb_q, tb_qb;
	reg [16:0]secuencia;
	integer i;


	/*Instancia*/
	FF_T instancia(
		.t  (tb_t),
		.clk(tb_clk),
		.rst(tb_rst),
		.q  (tb_q),
		.qb (tb_qb)
	);

	initial begin
		secuencia = 16'b0101001110011111;
		tb_clk = 0;
		tb_rst = 1;
		#5;
		tb_rst = 0;
		
		for (i = 0; i < 15; i=i+1) begin
			tb_t = secuencia[i];
			#10;
			$display("T:[%b]|Q:[%b]|Qb:[%b]",tb_t,tb_q,tb_qb);

		end
	end

	

	always #5 tb_clk = !tb_clk;

endmodule // TB_FF_D
