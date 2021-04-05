//Compuerta logica and
module and_gate(
  input wire [3:0]and_a,
  input wire [3:0]and_b,
  output reg [3:0]and_out
);

always @ (*)
  and_out= and_a&and_b; //SALIDA AND
endmodule

//Compuerta logica or
module or_gate(
  input wire [3:0]or_a,
  input wire [3:0]or_b,
  output reg [3:0]or_out
);

always @ (*)
  or_out= or_a|or_b; //SALIDA OR  
endmodule

//Compuerta logica nand
module nand_gate(
  input wire [3:0]nand_a,
  input wire [3:0]nand_b,
  output reg [3:0]nand_out
);

always @ (*)
  assign nand_out= ~(nand_a&nand_b); //SALIDA NAND
endmodule

//Compuerta logica xor
module xor_gate(
  input wire [3:0]xor_a,
  input wire [3:0]xor_b,
  output reg [3:0]xor_out
);

always @ (*)
  assign xor_out= xor_a^xor_b; //SALIDA XOR  
endmodule
