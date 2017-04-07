//--------------------------------------
//---------TEST BENCH-------------------
//--------------------------------------
module test_bench_uart(uart_if.TEST intf);
	initial
	@(posedge intf.clk) 
 	begin
 	intf.clr<=1;	
	for (int i = 0; i < 50; i++) begin
		
		intf.ready<=0;
		intf.tx_data<= $urandom_range(7,30000);
		#100;
		intf.clr<=0;
		intf.ready<=1;
		#760;
		intf.ready<=0;
		#100;
	end
	
	intf.clr<=1;
	$finish;
	end
endmodule: test_bench_uart