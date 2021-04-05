class Transaction;
	logic[31:0] addr, csm, data[8];
	endclass : Transaction
	
class Driver;
	Transaction tr;
	function new();
		tr= new();
	endfunction : new
endclass : Driver

Transaction t;
t = new();
t.addr= 32'h42;
t.display();