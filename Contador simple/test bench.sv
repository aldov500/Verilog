module tb_contador(tb_clk,tb_reset,tb_act,tb_out);
	output reg tb_clk, tb_reset, tb_act;
	input wire[7:0] tb_out;

	contador intancia(
		.clk(tb_clk),
		.reset(tb_reset),
		.act(tb_act),
		.out(tb_out)
	);

	initial begin
		tb_clk = 0;
		tb_reset = 1;
		tb_act = 0;
		$monitor("Contador: %4d",tb_out);
		#10;
		tb_reset = 0;
		tb_act = 1;
		#1000;
	end

	always #5 tb_clk = !tb_clk;

endmodule

module tb_contador2(tb_clk,tb_reset,tb_act,tb_out,updown);
	output reg tb_clk, tb_reset, tb_act, updown;
	input wire[7:0] tb_out;

	contador2 intancia(
		.clk(tb_clk),
		.reset(tb_reset),
		.act(tb_act),
		.updown(updown),
		.out(tb_out)
	);

	initial begin
		tb_clk = 0;
		updown = 1;
		tb_reset = 1;
		tb_act = 0;
		$monitor("Contador: %3d",tb_out);
		#10;
		tb_reset = 0;
		tb_act = 1;
		#2500;
		updown = 0;
		#2500;
	end

	always #5 tb_clk = !tb_clk;

endmodule
