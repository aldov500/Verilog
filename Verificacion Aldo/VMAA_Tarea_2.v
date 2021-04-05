//Aldo Alexandro Vargas Meza
//Programa con dos entradas[2 bits], una salida[4 bits]
//Condicional a>2

module condicionales(
  //Entradas
  input [1:0]a,
  input wire [1:0]b,
  //Salida y su registro 
  output wire [3:0]c, 
  output reg [3:0]c
);
//Proceso detectar cambios en a o b
always @ (a or b)
  begin
    //Condicional
    if(a>2)
      assign c = a+b;
    else
      assign c = 0;
  end 
endmodule