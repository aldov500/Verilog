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