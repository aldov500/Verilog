/*Test bench Sumador y Restador de 4 bits*/

module tb_Sum_Rest (tb_clk, tb_sel, tb_ent1, tb_ent2, tb_sal);
	output reg tb_clk, tb_sel;
	output reg[3:0] tb_ent1;
	output reg[3:0] tb_ent2;
	input wire[4:0] tb_sal;
	integer i;

	/*Instancias*/
	Sum_Rest instancia(
		.clk(tb_clk),
		.sel(tb_sel),
		.ent1(tb_ent1),
		.ent2(tb_ent2),
		.sal(tb_sal)
	);

	initial begin
		tb_clk = 0;
		tb_sel = 0;
		tb_ent1 = 4'b0000;
		tb_ent2 = 4'b0000;
		#5;
		$monitor("Inicializando variables...");
		#5;
		$monitor("Modo Sumador Seleccionado.");
		#5;
		$monitor("Inicia Suma: ");
		tb_sel = 1'b1;
		#5;

		for (i = 0; i < 8; i= i+1) begin
			#10;
			tb_ent1 = i;
			tb_ent2 = 15-i*2;
			$monitor("ENT1[%d] ENT2[%d] SAL[%d]",tb_ent1,tb_ent2,tb_sal);
			#10;
		end

		tb_sel = 1'b0;
		tb_ent1 = 4'b1111;
		tb_ent2 = 4'b0000;
		#5;
		$monitor("Inicializando variables...");
		#5;
		$monitor("Modo Restador Seleccionado.");
		#5;
		$monitor("Inicia resta: ");
		#5;

		for (i = 0; i < 8; i= i+1) begin
			#10;
				tb_ent1 = 15 - i;
				tb_ent2 = i;
			
			$monitor("ENT1[%d] ENT2[%d] SAL[%d]",tb_ent1,tb_ent2,tb_sal);
			#10;
		end


	end

	/*Generacion del Reloj*/
	always #10 tb_clk=!tb_clk;


endmodule
