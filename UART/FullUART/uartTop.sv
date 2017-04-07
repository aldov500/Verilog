//--------------------------------------
//---------TOP UART---------------------
//--------------------------------------
module top_uart(output reg clk);
	
	uart_if intf(clk);				//Instancia interfaz
	uart_tx tx1(intf);				//Instancia transmisor
	uart_rx rx1(intf);				//Instancia receptor
	monitor mn1(intf);				//Instancia de monitor
	test_bench_uart tb1(intf);		//Instancia test bench

	always
	begin
  	clk<=1;
  	#10;
  	clk<=0;	//Generador de reloj
  	#10;
	end
endmodule: top_uart