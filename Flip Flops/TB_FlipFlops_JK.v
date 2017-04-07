/*Test Bench FF Tipo JK*/
module TB_FF_JK(tb_j, tb_k, tb_clk, tb_rst, tb_q, tb_qb);
	output reg tb_j, tb_k, tb_clk, tb_rst;
	input wire tb_q, tb_qb;
	reg [7:0]secuencia;
	integer i;


	/*Instancia*/
	FF_JK instancia(
		.j  ( tb_j),
		.k  (  tb_k),
		.clk(tb_clk),
		.rst(tb_rst),
		.q  (  tb_q),
		.qb ( tb_qb)
	);

	initial begin
		secuencia = 8'b00001111;
		tb_clk = 0;
		tb_rst = 1;
		#5;
		tb_rst = 0;
		
		for (i = 0; i < 8; i=i+1) begin
			tb_j =  secuencia[i];
			tb_k = !secuencia[i];
			#10;
			$display("J:[%b]|K:[%b]|Q:[%b]|Qb:[%b]",tb_j,tb_k,tb_q,tb_qb);

		end

		for (i = 0; i < 8; i=i+1) begin
			tb_j = 1;
			tb_k = 1;
			#10;
			$display("J:[%b]|K:[%b]|Q:[%b]|Qb:[%b]",tb_j,tb_k,tb_q,tb_qb);

		end
	end

	

	always #5 tb_clk = !tb_clk;

endmodule // TB_FF_JK
