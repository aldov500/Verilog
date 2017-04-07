/*Transmisor UART*/
module UART_TX(clk, clr, ready, tx_data, txD,tdre);
	input wire clk, clr, ready;
	input wire[7:0]tx_data;
	output reg txD, tdre;

	reg [2:0]Estado;
	reg [7:0]buffer;
	reg [15:0]baud_cont;
	reg [3:0]bit_cont;

	/*Estados*/
	parameter espera  = 3'b000;
	parameter inicia  = 3'b001;
	parameter retardo = 3'b010;
	parameter cambio  = 3'b011;
	parameter alto    = 3'b100;

	parameter bit_tiempo = 3'b100;
	
	always @(posedge clk or negedge clr) begin
		if(clr) begin
			Estado = espera;
			buffer = 0;
			baud_cont = 0;
			txD = 1;
		end
		else begin
			case (Estado)

				espera: begin
					bit_cont = 0;
					tdre = 0;

					if(!ready) 
						Estado = espera;
					else begin
						buffer = tx_data;
						baud_cont = 0;
						Estado = inicia;
					end
				end

				inicia:begin
					baud_cont = 0;
					txD = 0;
					tdre = 0;
					Estado = retardo;
				end

				retardo:begin
					tdre = 0;
					if(baud_cont>=bit_tiempo) begin
						baud_cont = 0;
						if(bit_cont<8) Estado = cambio;
						else Estado = alto;
					end
					else begin
						baud_cont = baud_cont + 1;
						Estado = retardo;
					end
				end

				cambio:begin
					tdre = 0;
					txD = buffer[0];
					buffer[6:0] = buffer[7:1];
					bit_cont = bit_cont + 1;
					Estado = retardo;
				end

				alto:begin
					tdre = 1;
					txD = 1;
					if(baud_cont >= bit_tiempo) begin
						baud_cont = 0;
						Estado = espera;
					end
					else begin
						baud_cont = baud_cont + 1;
						Estado = alto;
					end
				end

			endcase
		end
	end

endmodule // UART_TX