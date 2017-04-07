/*Receptor UART*/
module UART_RX(clk,clr,rdrf_clr,rdrf,rx_data,FE,RxD);
	
	input wire RxD,clk,clr, rdrf_clr;			
	output reg rdrf,FE;
	output reg [7:0] rx_data;	

	reg[ 2:0]  Estado;
	reg[ 7:0]  buffer;
	reg[11:0] baud_cont;
	reg[ 3:0]  bit_cont;

	parameter espera  = 3'b000;
	parameter inicia  = 3'b001; 
	parameter retardo = 3'b010; 
	parameter cambio  = 3'b011; 
	parameter alto    = 3'b100; 

	parameter bit_tiempo = 3'b100;
	parameter medio_bitt = 3'b010;

	

	always @(posedge clk or posedge clr or posedge rdrf_clr) begin
		assign rx_data = buffer;
		if(clr)begin
			Estado = espera;
			buffer = 0;
			baud_cont = 0;
			rdrf = 0;
			FE = 0;
		end

		else begin
			if(!rdrf_clr) rdrf <= 0;				
	    	
	    	else case(Estado)

	    		espera:begin							
					bit_cont = 0;				
					baud_cont = 0;			
         			if(RxD)						
               			Estado = espera;			
         			else begin 
			   			FE <= 0;			
               			Estado = inicia;	 	
 						end
        	   	end   

        	   	inicia:begin
        	   		if(baud_cont >= medio_bitt) begin 
						baud_cont = 0;			//Reiniciar el contador
            			Estado = retardo;				//Cambiar de estado
					end	   
				
					else begin 
						baud_cont = baud_cont+1;	//Aumentar el contador +1
            			Estado = inicia;				//Permanecer en el estado
					end	   

        	   	end    

        	   	retardo:begin
        	   		if(baud_cont >= bit_tiempo)	begin 
			  			baud_cont = 0;			//Contador a 0
			   	  		if(bit_cont < 8)			//Si no ha enviado los 8 bits
							Estado  = cambio;			//Cambia al 4 estado
			   			else						//Si ya los envió
 		        			Estado  = alto;			//Cambia al ultimo estado
			   		end 
				
					else begin 
			   			baud_cont = baud_cont+1;	//Aumenta el contador
 		        		Estado = retardo;	 			//Cicla el mismo estado
 		      		end

        	   	end

        	   	cambio:begin 
		      		buffer[7] = RxD;			//Mete en el MSB el valor del bit transmitido
     	      		buffer[6:0] = buffer[7:1];	//Recorre el vector
	 	      		bit_cont = bit_cont + 1; //Aumenta el contador de bits
		      		Estado <= retardo;				//Regresa al tercer estado
			  	end

			  	alto:begin
			  		rdrf = 1;					//Recepcion completa
          			if(!RxD)					//Si la entrada desde el transmisor es 0
			 			FE = 1;				//Hay error de paridad
		    		else 						//S es 1
			 			FE = 0;				//No hay error
 		 			Estado = espera;				//Regresa al primer estado
          		end 			  
			endcase

		end
		
	end

endmodule // UART_RX




      		