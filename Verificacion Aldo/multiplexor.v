//Multiplexor
module multiplexor(
output reg[3:0]mux_out,              //SALIDA
input wire [3:0]mux_selector,        //Selector de datos
//Lectura valores logicos
input wire[3:0]mux_and,  //Entrada AND
input [3:0]mux_or,   //Entrada OR
input [3:0]mux_nand, //Entrada NAND
input [3:0]mux_xor   //Entrada XOR
);

and_gate and_data(
  .and_out(mux_and)
);
or_gate or_data(
  .or_out(mux_or)
);
nand_gate nand_data(
  .nand_out(mux_nand)
);
xor_gate xor_data(
  .xor_out(mux_xor)
);
decodificador dec_data(
  .dec_out(mux_selector)
);
always @(*)
begin
  case(mux_selector)
    4'b0001:
      mux_out=mux_and;
    4'b0010:
      mux_out=mux_or;
    4'b0100:
      mux_out=mux_nand;
    4'b1000:
      mux_out=mux_xor;
    endcase       
end

endmodule
