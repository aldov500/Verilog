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

//--------------------------------------
//---------TEST BENCH-------------------
//--------------------------------------
module test_bench_uart(uart_if.TEST intf);
	initial
	@(posedge intf.clk) 
 	begin
 	intf.clr<=1;	
	for (int i = 0; i < 50; i++) begin
		
		intf.ready<=0;
		intf.tx_data<= $urandom_range(7,30000);
		#100;
		intf.clr<=0;
		intf.ready<=1;
		#760;
		intf.ready<=0;
		#100;
	end
	
	intf.clr<=1;
	$finish;
	end
endmodule: test_bench_uart

//--------------------------------------
//----------MONITOR---------------------
//--------------------------------------
module monitor (uart_if.MONITOR intf);
	reg [4:0] bandera=0;

	always@(posedge intf.clr or posedge intf.ready or posedge intf.tdre)
	begin
		if(intf.clr)
			$display("[%0t]: Reset presionado",$time);
		else
		
		if(intf.ready)
		begin
			if(intf.tdre)
			begin
				$display("									");
				$display("[%0t] Transmision [%0d] completada.",$time, bandera);
				$display("Datos recibidos = [%0b]",intf.rx_data);
				$display("----------------------------------");
				if(intf.FE)
				begin
					$display("[%0t]: |||Error de paridad|||",$time);
				end
			end
			else
			begin
				bandera++;
				$display("----------------------------------");
				$display("[%0t]: Transmision [%0d] iniciada.",$time, bandera);
				$display("Enviando datos:[%0b]",intf.tx_data);
				$display("									");
			end
		end
	end
endmodule: monitor

//--------------------------------------
//---------TRANSMISOR-------------------
//--------------------------------------
module uart_tx(uart_if.TX intf);			//Transmision completa

	reg [2:0] state;			//Manejador de estados
	reg [7:0] bufftx;			//Copia del dato a enviar
	reg [15:0] baud_count;		//Contador Baud Rate
	reg [3:0] bit_count;		//Bits transmitidos

	parameter bit_time = 3'b010; 	//16'h1458; 	//Baud Rate, o la tasa de envío
	parameter idle=  3'b000,		//||Estados de la maquina
			  start= 3'b001, 		//||Los cuales llevaran procesos
			  delay= 3'b010, 		//||En las diferentes etapas
		  	  shift= 3'b011, 		
		  	  stop=  3'b100; 

	always @(posedge intf.clk or posedge intf.clr) 
	begin
	if(intf.clr) 
	begin						
		state <= idle;			//"Espera"
		bufftx <= 0;			//Copia del Dato a 0
		baud_count <= 0;		//Contador de tasa de envio a 0
		bit_count <= 0;			//Bits enviados a 0
		intf.txD <= 1;			//Salida a 1
	end 
	
	else 
	begin
		
		case (state)					
			idle:						//Estado principal Espera
			begin
				bit_count <= 0;			//Bits enviados a 0			
				intf.tdre  <= 0;				//Trans. Completa a 0
				
				if (~intf.ready) 			//Si "ready" no es presionado
				begin
					state <= idle;		//Cicla el mismo estado en la maquina
				end
				
				else					//Si "ready" es presionado
				begin
					bufftx <= intf.tx_data;	//Copia el dato al buffer	
					baud_count <= 0;	//Contador de tasa de envío a 0
					state <= start;		//Cambia de estado
				end	
			end
				
			start:						//Segundo estado Preparacion
			begin
				baud_count <= 0;		//Se mantiene el contador de tasa en 0
				intf.txD <= 0;				//Salida cambia a 1, indicando el envío
				intf.tdre <= 0;				//Envío completo se mantiene en 0
				state <= delay;			//Cambia el estado
			end
				
			delay:									//||Tercer estado para enviar el dato															
			begin									//||en la tasa de envío seleccionada
				intf.tdre <= 0;							//Envío completo en 0
				
				if (baud_count >= bit_time)			//||Si es igual o mayor el contador de tasa
				begin								//||al de bits enviados
					baud_count <= 0;				//Contador de tasa a 0
					
					if(bit_count < 8)				//Si no se han enviado los 8 bits				
						state <= shift;				//Cambia de estado de recorrimiento
					else							//Si se enviaron 8 bits
						state <= stop;				//Cambia estado final
				end
				
				else								//||Si el contador de tasa es menor o igual al 
				begin								//||estipulado de Baud Rate
					baud_count <= baud_count +1;	//Incrementa +1 el contador de tasa
					state <= delay;					//Cicla el mismo estado
				end
			end
			
			shift:								//Cuarto estado Recorrimiento de bits
			begin									
				intf.tdre <= 0;						//Transmision completa en 0
				intf.txD <= bufftx[0];				//Salida es el LSB de la copia del dato a enviar
				bufftx[6:0] <= bufftx[7:1];		//Recorre el vector, para ir sacando los LSB's
				bit_count <= bit_count +1;		//Aumenta cuando envía un bit
				state <= delay;					//Regresa al Tercer estado 
			end
							
			stop:								//Estado final					
			begin
				intf.tdre <= 1;						//Transmision completa a 1
				intf.txD <= 1;						//Salida se queda en 1
			
				if(baud_count >= bit_time)		//||Si el contador de tasa, es mayor
				begin							//||o igual al Baud rate elegido
					baud_count <= 0;			//Contador de tasa a 0
					state <= idle;				//Estado a Primer estado Espera
				end
			
				else							//Si el contador es menor al parametro
				begin
					baud_count <= baud_count+1;	//Incrementa el contador
					state <= stop;				//Cicla el mismo estado final
				end
			end
		endcase
	 end
	end
endmodule

//--------------------------------------
//---------RECEPTOR---------------------
//--------------------------------------

module uart_rx(uart_if.RX intf);					//Bandera paridad

	reg [2:0] state;				//Manejador para la FSM
	reg [7:0] rxbuff;				//Copia del dato
	reg [11:0] baud_count;			//Contador para tasa de envío
	reg [3:0] bit_count;			//Contador de Bits recibidos
	

	parameter mark = 3'b000,			//Valores que tomará la FSM
		start= 3'b001, 
		delay= 3'b010, 
		shift= 3'b011, 
		stop = 3'b100; 

	parameter bit_time= 3'b010;		//12'hA28;  		//Tasa de envío de cada bit 9600 baud= 12'hA28
	parameter half_bit_time =3'b001;	//12'h514;  //Mitad de tasa de envío, para sincronización

	assign intf.rx_data = rxbuff; 			//Copia del valor a la salida
	assign intf.RxD = intf.txD;				//Copia de la interfaz la salida del TX
	assign intf.rdrf_clr = intf.tdre;		//copia el valor de la interfaz


	always @(posedge intf.clk or posedge intf.clr or posedge intf.rdrf_clr) 	
	begin 
	if(intf.clr)							//Reset en 1
	begin 
		state <= mark;				//Selecciona el primer estado
		rxbuff <= 0;				//Copia en 0
		baud_count <= 0;			//Contador de tasa en 0
		bit_count <= 0;				//Bits recibidos en 0
		intf.rdrf <= 0;					//Recepcion completa en 0
		intf.FE <= 0;					//Error de paridad en 0
	end
	
	else							//Reset desactivado 
	begin 
		if(intf.rdrf_clr)				//||Recepcion completa desactivada a menos 		
			intf.rdrf <= 0;				//||que el transmisor indique envio
	    else
	    	case(state)		  
      			mark:							//Primer estado, espera el primer bit
				begin 
					bit_count <= 0;				//Bits enviados a 0
					baud_count <= 0;			//Contador de tasa de envio a 0
         			if(intf.RxD)						//Si la entrada está en 1
               			state <= mark;			//Permanece en el estado
         			else						//Si la entrada está en 0
					begin
               			intf.FE <= 0;			//Error de paridad a 0
               			state <= start;	 	//Cambio de estado
               		end	
 						
        	   	end       
      		
      			start:							//Segundo estado
				if(baud_count >= half_bit_time)	//Si el contador de tasa llega a medio bit transmitido
			  	begin 
					baud_count <= 0;			//Reiniciar el contador
            		state <= delay;				//Cambiar de estado
				end	   
				
				else							//Si aun no llega a medio bit
			  	begin 
					baud_count <= baud_count+1;	//Aumentar el contador +1
            		state <= start;				//Permanecer en el estado
				end	   
 			
 				delay:							//Tercer estado
 	      		if(baud_count >= bit_time)		//Si el contador es igua o mayor al parametro de BR
				begin 
			  		baud_count <= 0;			//Contador a 0
			   	  	if(bit_count < 8)			//Si no ha enviado los 8 bits
						state <= shift;			//Cambia al 4 estado
			   		else						//Si ya los envió
 		        		state <= stop;			//Cambia al ultimo estado
			   	end 
				
				else 							//Si el contador es menor al parametro BR
				begin 
			   		baud_count <= baud_count+1;	//Aumenta el contador
 		        	state <= delay;	 			//Cicla el mismo estado
 		      	end
			

				shift:							//Cuarto estado, recorrimiento
				begin 
		      		rxbuff[7] <= intf.RxD;			//Mete en el MSB el valor del bit transmitido
     	      		rxbuff[6:0] <= rxbuff[7:1];	//Recorre el vector
	 	      		bit_count <= bit_count + 1; //Aumenta el contador de bits
		      		state <= delay;				//Regresa al tercer estado
			   	end
 				
 				stop:							//Ultimo estado
			 	begin 
		   			intf.rdrf <= 1;					//Recepcion completa
          			if(~intf.RxD)					//Si la entrada desde el transmisor es 0
          			begin
			 			   intf.FE <= 1;
			 			   state<= stop;			//Hay error de paridad
		    		   end
		    		   else 						//S es 1
			 			 begin
			 			   intf.FE <= 0;				//No hay error
 		 				   state <= mark;			//Regresa al primer estado
          		  end
      		  end 			  
			endcase
		end
    end  	
endmodule: uart_rx
