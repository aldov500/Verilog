//Aldo Alexandro Vargas Meza
//Contador 8 bits con condicional

module contador(
  input wire clk,
  input wire reset,
  input wire enable,
  output reg[7:0]old_valor,   //El valor actual
  output reg[7:0]new_valor, 	//El proximo valor
  output reg[7:0]out         //Salida del sistema
);

always @(posedge clk or posedge reset)
  begin
    if(reset)
      old_valor=0;
    else
      old_valor=new_valor;
  end
    
always@(old_valor)
  new_valor= old_valor +1;

always@(new_valor)
  begin
    if(enable)
      out= old_valor;
    else
      out=0;
  end
endmodule