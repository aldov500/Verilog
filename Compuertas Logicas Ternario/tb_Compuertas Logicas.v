/* Test Bench Compuertas Logicas
   3 salidas de Prueba
   1 salida de Activador
   1 salida de Selector[2:0]
   1 entrada de Salida
   Comprobar: Funciones Logicas: AND, OR, XOR, NAND, NOR, XNOR
*/

module tb_compuertasLogicas(tb_ent1, tb_ent2, tb_ent3, tb_sel, tb_sal, tb_act);
	output reg 	tb_ent1, tb_ent2, tb_ent3;
	output reg 	tb_act;
 	output reg [2:0]tb_sel;
	input wire 	tb_sal;
	
	/*Instancia*/
	compuertasLogicas instancia (
		.ent1(tb_ent1),
		.ent2(tb_ent2),
		.ent3(tb_ent3),
		.act(tb_act),
		.sel(tb_sel),
		.sal(tb_sal)
		);

	initial begin
		tb_sel = 3'b000;
		tb_act = 1'b0;
		#10;
		tb_act = 1'b1;
		#10;
		tb_sel = 3'b001;
		#10;

		repeat(6)begin
		#10;
		$monitor("Ent1[%b] | Ent2[%b] | Ent3[%b] | Salida[%b]",tb_ent1,tb_ent2,tb_ent3,tb_sal);
		
		tb_ent1 = 0;
		tb_ent2 = 0;
		tb_ent3 = 0;
		#10;

		tb_ent1 = 1;
		tb_ent2 = 0;
		tb_ent3 = 0;
		#10;

		tb_ent1 = 0;
		tb_ent2 = 1;
		tb_ent3 = 0;
		#10;

		tb_ent1 = 1;
		tb_ent2 = 1;
		tb_ent3 = 0;
		#10;


		tb_ent1 = 0;
		tb_ent2 = 0;
		tb_ent3 = 1;
		#10;

		tb_ent1 = 1;
		tb_ent2 = 0;
		tb_ent3 = 1;
		#10;

		tb_ent1 = 0;
		tb_ent2 = 1;
		tb_ent3 = 1;
		#10;

		tb_ent1 = 1;
		tb_ent2 = 1;
		tb_ent3 = 1;
		#10;

		tb_sel = tb_sel + 1;
		#10;

		end

	end



	always@(*)begin

		if(tb_act)		$display("ACT = ON");
		else if(!tb_act)	$display("ACT = OFF");

		case(tb_sel)
			3'b001: $display("SEL = AND");
			3'b010: $display("SEL = OR");
			3'b011: $display("SEL = XOR");
			3'b100: $display("SEL = NAND");
			3'b101: $display("SEL = NOR");
			3'b110: $display("SEL = XNOR");
		default: $display("SEL = OFF");
		endcase

	end

endmodule

