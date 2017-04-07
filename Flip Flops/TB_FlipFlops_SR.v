/*Test Bench FF Tipo SR*/
module TB_FF_SR(tb_s, tb_r, tb_clk, tb_rst, tb_q, tb_qb);
	output reg tb_s, tb_r, tb_clk, tb_rst;
	input wire tb_q, tb_qb;
	reg [7:0]secuencia;
	integer i;


	/*Instancia*/
	FF_SR instancia(
		.s  ( tb_s),
		.r  (  tb_r),
		.clk(tb_clk),
		.rst(tb_rst),
		.q  (  tb_q),
		.qb ( tb_qb)
	);

	initial begin
		secuencia = 8'b00110101;
		tb_clk = 0;
		tb_rst = 1;
		#5;
		tb_rst = 0;
		
		for (i = 0; i < 8; i=i+1) begin
			tb_s =  secuencia[i];
			tb_r = !secuencia[i];
			#10;
			$display("S:[%b]|R:[%b]|Q:[%b]|Qb:[%b]",tb_s,tb_r,tb_q,tb_qb);

		end

		for (i = 0; i < 8; i=i+1) begin
			tb_s = 1;
			tb_r = 1;
			#10;
			$display("S:[%b]|R:[%b]|Q:[%b]|Qb:[%b]",tb_s,tb_r,tb_q,tb_qb);

		end
	end

	

	always #5 tb_clk = !tb_clk;

endmodule // TB_FF_JK
