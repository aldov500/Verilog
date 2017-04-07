//--------------------------------------
//---------INTERFAZ---------------------
//--------------------------------------
interface uart_if (input wire clk);
	logic clr;				//Reset
	logic ready;			//Enviar datos
	logic [7:0] tx_data;	//Datos a enviar
	logic txD;				//Salida del Transmisor
	logic tdre;				
	
	logic RxD;				//Aqui se conecta el Transmisor
	logic rdrf_clr;			//Reset envío completo
	logic rdrf;				//Recepción completa
	logic [7:0] rx_data;		//Salida UART
	logic FE;


	modport TX (
		input clk, clr, ready, tx_data, 				//Puertos Transmisor
		output txD, tdre);

	modport RX(
		input tdre, txD, clk, clr, RxD, rdrf_clr, 		//Puertos de Receptor
		output rdrf, rx_data, FE);

	modport TEST(
		input clk, 								//Puertos del Test Bench
		output clr, ready, tx_data);

	modport MONITOR (
		input clk, clr, ready, tx_data, tdre, rx_data, FE);
endinterface: uart_if