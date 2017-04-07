
module tb_Mux4_1(selector,A,B,C,D,O);
	output reg[1:0]selector;
	output reg[3:0]A, B, C, D;
	input wire[3:0]O;

	/*Instancias*/
	Mux4_1 instancia(
		.selector(selector),
		.A(A),
		.B(B),
		.C(C),
		.D(D),
		.O(O)
	);

	initial begin
		selector = 2'b0;
		A = 4'b0;
		B = 4'b0;
		C = 4'b0;
		D = 4'b0;
		#10;
		$monitor("[T+ %0t]::Selector[%d]|A[%d]B[%d]C[%d]D[%d]|Salida[%d]",$time,selector,A,B,C,D,O);
		#10;
		A = 4'b1100;
		B = 4'b1011;
		C = 4'b1001;
		D = 4'b1110;
		#10;
		$monitor("[T+ %0t]::Selector[%d]|A[%d]B[%d]C[%d]D[%d]|Salida[%d]",$time,selector,A,B,C,D,O);
		#10;
		
		repeat(8)begin
			selector = selector + 1;
			#10;
			$monitor("[T+ %0t]::Selector[%d]|A[%d]B[%d]C[%d]D[%d]|Salida[%d]",$time,selector,A,B,C,D,O);
			#10;
		end
		
	end

	
endmodule