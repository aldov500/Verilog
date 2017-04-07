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
