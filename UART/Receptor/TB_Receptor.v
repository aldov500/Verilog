module TB_UART_RX(tb_clk,tb_clr,tb_rdrf_clr,tb_rdrf,tb_rx_data,tb_FE,tb_RxD);
	
	output reg tb_RxD,tb_clk,tb_clr,tb_rdrf_clr;			
	input wire tb_rdrf, tb_FE;
	input wire[7:0] tb_rx_data;		
	
	UART_RX Instancia(
		.clk(tb_clk),
		.clr(tb_clr),
		.rdrf_clr(tb_rdrf_clr),
		.rdrf(tb_rdrf),
		.rx_data(tb_rx_data),
		.FE(tb_FE),
		.RxD(tb_RxD)
	);

	initial begin
		$monitor("Salida de TX: %8b y %b Estado: %d Transmision: %b Contador %d" ,tb_rx_data, tb_RxD,Instancia.Estado, tb_rdrf,Instancia.baud_cont);
		tb_clk = 0;
		tb_RxD = 0;
		tb_clr = 1;
		#10;
		tb_clr = 0;
		#10;
		tb_rdrf_clr = 1;
		#5;
		repeat(100)begin
			tb_RxD = !tb_RxD;
			#10;
		end
		


		
		
		


	end

	always #5 tb_clk = !tb_clk;


endmodule // TB_UART_RX
