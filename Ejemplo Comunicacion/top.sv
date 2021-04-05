//Comunicacion de MODULO-TEST BENCH-TOP
//TOP
module top;
	logic[1:0] grant, request;
	bit clk;
	always #50 clk= ~clk;

	//Instancias
	arb_with_port a1(grant, request, rst, clk);
	test_with_port t1(grant, request, rst, clk);
endmodule // top
 