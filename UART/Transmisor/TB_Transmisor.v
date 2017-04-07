/*Test Bench Transmisor UART*/
module TB_UART_TX(tb_clk, tb_clr, tb_ready, tb_tx_data, tb_txD, tb_tdre);
	output reg tb_clk, tb_clr, tb_ready; 
	output reg [7:0]tb_tx_data;
	input wire tb_txD, tb_tdre;

	UART_TX Instancia(
		.clk(tb_clk),
		.clr(tb_clr),
		.ready(tb_ready),
		.tx_data(tb_tx_data),
		.txD(tb_txD),
		.tdre(tb_tdre)
	);

	initial begin
		$monitor("Salida de TX: %b Estado: %d Transmision: %b",tb_txD,Instancia.Estado,tb_tdre);
		tb_clk = 0;
		tb_clr = 0;
		tb_ready = 0;
		tb_tx_data = 8'b10101010;
		#10;
		tb_clr = 1;
		#10;
		tb_ready = 1;
		tb_clr = 0;
		#10;


	end

	always #5 tb_clk = !tb_clk;


endmodule // TB_UART_TX
