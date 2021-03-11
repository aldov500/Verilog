/*Modulo Compuertas Logicas
  Selector
  Funciones Logicas: AND, OR, XOR, NAND, NOR, XNOR
  Señal Activacion
  3 Entradas
  Asincrona
*/

module compuertasLogicas(in1, in2, in3, sel, out, act);
	input wire 	in1, in2, in3;
	input wire 	act;
	input wire [2:0]sel;
	output reg 	out;

	always@(*)begin
		if(sel == 3'b001) // AND
			out = ( ent1 & ent2 & ent3 );
		else if(sel == 3'b010) // OR
			out = ( ent1 | ent2 | ent3 );
		else if(sel == 3'b011) // XOR
			out = ( ent1 ^ ent2 ^ ent3 );
		else if(sel == 3'b100) // NAND
			out = !( ent1 & ent2 & ent3 );
		else if(sel == 3'b101) // NOR
			out = !( ent1 | ent2 | ent3 );
		else if(sel == 3'b110) // XNOR
			out = !( ent1 ^ ent2 ^ ent3 );
		end
	end

endmodule
