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
