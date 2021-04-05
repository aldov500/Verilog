//Comunicacion de MODULO-TEST BENCH-TOP
//Test Bench
module test_with_port(
	input logic[1:0] grant,
	output logic[1:0] request,
	output bit rst,
	output bit clk);

initial begin
	@(posedge clk);
	request<= 2'b01;
	$display("@%0t: Drove req= 01",$time);
	repeat(2) @(posedge clk);
	if(grant== 2'b01) 
		$display("@%0t: Success: grant = 2'b01",$time);
	else
		$display("@%0t: Error: grant != 2'b01",$time);
	$finish;
end // initial
endmodule // test_with_port