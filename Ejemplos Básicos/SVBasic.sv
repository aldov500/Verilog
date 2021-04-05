	`timescale 1ns/1ns

// ==================================================================
// Example 2.1: Module “Hello SystemVerilog World!!!”
// ==================================================================
module Example_02_01 #( type TData=reg[7:0], TData DATA='hF7 );

   // Main Process
   initial begin: Main
      $display ( "Hello SystemVerilog World!!!" );
      $display ( "Typed Parameter   TData = %s", $typename(TData) );
      $display ( "Numeric Parameter  DATA = 0x%h", DATA );
   end: Main
   
endmodule: Example_02_01

// ==================================================================
// Example 2.2: Program “Hello SystemVerilog World!!!”
// ==================================================================
program Program #( type TData=reg[7:0], TData DATA='hF7 );

   // Main Process
   initial begin: Main
      $display ( "Hello SystemVerilog World!!!" );
      $display ( "Numeric Parameter  DATA = 0x%h", DATA );
      $display ( "Typed Parameter   TData = %s", $typename(TData) );
   end: Main
   
endprogram: Program

module Example_02_02;
   
   // Program Instance
   Program #( .TData(int), .DATA('hAA) ) Program1();
	Program #(    shortint,       'hFF  ) Program2();
   
endmodule: Example_02_02

// ==================================================================
// Example 2.3: Package for Sharing Namespace
// ==================================================================
package PkgA;
   typedef logic [7:0] TWord;		
   TWord Word0='h00, Word1='h11, Word2='h22;
endpackage: PkgA

package PkgB;
   import PkgA::*;         // Imports all items from PkgA
   export PkgA::*;         // Owns all items from PkgA
   TWord Word3='h33, Word4='h44, Word5='h55;
endpackage: PkgB

module Example_02_03;
   import PkgB::*;   		// Imports all items from PkgB and PackA
   TWord Word0='hF0, Word1='hF1, Word2='hF2;
   
   initial begin: Main
      $display ( "Local Words: 0x%h 0x%h 0x%h", 
                 Word0, Word1, Word2 );
      $display ( "PkgA  Words: 0x%h 0x%h 0x%h", 
                 PkgA::Word0, PkgA::Word1, PkgA::Word2 );
      $display ( "PkgB  Words: 0x%h 0x%h 0x%h", 
                 Word3, Word4, Word5 );
   end: Main
endmodule: Example_02_03

// ==================================================================
// Example 3.1: Numeric Types
// ==================================================================
module Example_03_01;
	timeunit      1ns;
	timeprecision 1ps;	

	reg   [7:0] regVar;
	logic [7:0] logicVar;
	integer     integerVar;
	time        timeVar;
	
	bit   [7:0] bitVar;
	byte        byteVar;
	shortint    shortintVar;
	int         intVar;
	longint     longintVar;
	
	shortreal   shortrealVar;
	real        realVar;
	realtime    realtimeVar;
	
	initial begin: Main
		$display( "regVar=%h logicVar=%h, integerVar=%0d, timeVar=%0t", 
		           regVar, logicVar, integerVar, timeVar );
		$display( "bitVar=%h byteVar=%h, shortintVar=%0d, intVar=%0d, longintVar=%0d", 
		           bitVar, byteVar, shortintVar, intVar, longintVar );
		$display( "shortrealVar=%f realVar=%2.1e, realtimeVar=%2.1f", 
		           shortrealVar, realVar, realtimeVar );
		
		regVar='hFF; 	logicVar=255; 	integerVar=27; 	timeVar=3us;
		bitVar='b0101;	byteVar='hAF;	shortintVar=33; 	intVar=45;	longintVar=2345678;
		shortrealVar=0.3e-3; 			realVar=0.3e-24;	realtimeVar=1.2ns;		
		
		$display( "regVar=%h logicVar=%h, integerVar=%0d, timeVar=%0t", 
		           regVar, logicVar, integerVar, timeVar );
		$display( "bitVar=%h byteVar=%h, shortintVar=%0d, intVar=%0d, longintVar=%0d", 
		           bitVar, byteVar, shortintVar, intVar, longintVar );
		$display( "shortrealVar=%f realVar=%2.1e, realtimeVar=%2.3f", 
		           shortrealVar, realVar, realtimeVar );
	end: Main
	
endmodule: Example_03_01

// ==================================================================
// Example 3.2: User-Defined Types
// ==================================================================
module Example_03_02;

	typedef enum bit { FALSE, TRUE } Bool;
	Bool MyVar;
	
	initial begin: Main
		$display( "MyVar Type  = %s", $typename( Bool ) );
		$display( "MyVar Value = %b [%s]", MyVar, MyVar.name() );
	end: Main
	
endmodule: Example_03_02

// ==================================================================
// Example 3.3: Static and Dynamic Casting
// ==================================================================
module Example_03_03;

	bit[7:0] Value;
	
	initial begin: Main
		Value = signed'( -4 );
		$display ( "Value = %b (%0d)", Value, Value );
		$cast( Value, -1.3 );		// As a System Task
		$display ( "Value = %b (%0d)", Value, Value );
	end: Main
	
endmodule: Example_03_03

// ==================================================================
// Example 3.4: Strings
// ==================================================================
module Example_03_04;

	string sName    = "Samanta";
	string sAddress = {"4469 ", "Fifth Avenue"};
	
	initial begin: Main
		$display ( "Name: [%-10s] Address: %s Length: %0d :: sName[0]: %s", 
		sName, sAddress, sName.len()+sAddress.len(), sName[0] );
	end: Main
	
endmodule: Example_03_04

// ==================================================================
// Example 3.5: Enumeration type
// ==================================================================
module Example_03_05;

	typedef enum bit[2:0] { S0='b100, S1, S2, S3 } TState;	
	TState State;
	
	initial begin: Main
		State = State.first();
		$display ("State=%s, Value=%0d ('b%b)", State.name(), State, State );
		State = State.next();
		$display ("State=%s, Value=%0d ('b%b)", State.name(), State, State );
		State = State.last();  	
		$display ("State=%s, Value=%0d ('b%b)", State.name(), State, State );
		State = State.next( 3 );	
		$display ("State=%s, Value=%0d ('b%b)", State.name(), State, State );
		State = State.prev( 3 );	
		$display ("State=%s, Value=%0d ('b%b)", State.name(), State, State );
	end: Main

endmodule: Example_03_05

// ==================================================================
// Example 3.6.1: Packed/Unpacked Structure
// ==================================================================
module Example_03_06_01;

   typedef struct {
      bit   [3:0] Code;
      logic [7:0] Addr;
      bit   [7:0] Data;
      } TUnpacked;
   
   typedef struct packed {
      bit   [3:0] Code;
      logic [7:0] Addr;
      bit   [7:0] Data;
      } TPacked;
   
   // Declaration and initialization
   TUnpacked Unpacked = '{default:0};
   TPacked   Packed   = 'h0;
   
   initial begin: Main
		// Individual Member access
      $display ("Unpacked :: Code=0x%h Data=0x%h Addr=0x%h", 
                 Unpacked.Code, Unpacked.Data, Unpacked.Addr );
      $display ("Packed   :: Code=0x%h Data=0x%h Addr=0x%h", 
                   Packed.Code,   Packed.Data,   Packed.Addr );
      
      // Assign by position
      Unpacked = '{ 'h1, 'hD1, 'hA1 };
      Packed   = 'h1_D1_A1;
      
      $display ("Unpacked :: Code=0x%h Data=0x%h Addr=0x%h", 
                 Unpacked.Code, Unpacked.Data, Unpacked.Addr );
      $display ("Packed   :: Code=0x%h Data=0x%h Addr=0x%h", 
                   Packed.Code,   Packed.Data,   Packed.Addr );
      
      // Assign by name
      Unpacked      = '{ Addr:'h2, Code:'hC2, Data:'hD2 };
      Packed[23:16] = 'h2;
      Packed[15:8]  = 'hD2;
      Packed[7:0]   = 'hA2;
      
      $display ("Unpacked :: Code=0x%h Data=0x%h Addr=0x%h", 
                 Unpacked.Code, Unpacked.Data, Unpacked.Addr );
      $display ("Packed   :: Code=0x%h Data=0x%h Addr=0x%h", 
                   Packed.Code,   Packed.Data,   Packed.Addr );
   end: Main
   
endmodule: Example_03_06_01

// ==================================================================
// Example 3.6.2: Packed Union
// ==================================================================
module Example_03_06_02;
	
	typedef struct packed { 
		bit  [5:0] OpCode;
		bit  [4:0] RS, RT, RD, ShAmt;
		bit  [5:0] Funct; } RegType;
	
	typedef struct packed {
		bit  [5:0] OpCode;
		bit  [4:0] RS, RT;
		bit [15:0] Imm;   } ImmType;
	
	typedef struct packed {
		bit  [5:0] OpCode;
		bit [25:0] Addr;  } JumpType;
	
	typedef union packed {
		RegType  RType;
		ImmType  IType;
		JumpType JType;   } MipsInstruction;
	
	MipsInstruction Instr;
	
	initial begin: Main
		Instr = $random();
		$display( "RTYPE :: OpCode=%b RS=%b RT=%b RD=%b ShAmt=%b Funct=%b", 
			Instr.RType.OpCode, Instr.RType.RS, Instr.RType.RT,
			Instr.RType.RD, Instr.RType.ShAmt, Instr.RType.Funct );
		$display( "ITYPE :: OpCode=%b RS=%b RT=%b Imm=%b",
			Instr.IType.OpCode, Instr.IType.RS, Instr.IType.RT, 
			Instr.IType.Imm );
		$display( "JTYPE :: OpCode=%b Addr=%b",
			Instr.JType.OpCode, Instr.JType.Addr );
	end: Main
	
endmodule: Example_03_06_02

// ==================================================================
// Example 3.7.1: Packed/Unpacked Arrays
// ==================================================================
module Example_03_07_01;

	logic [3:0][7:0] Packed;		// Packed Array
	logic Unpacked [3:0][7:0];		// Unpacked Array
	logic [7:0] Memory [3:0];		// Memory: Packed/Unpacked Array
	
	initial begin: Main
		// Initialization
		Packed   = '0;
		Unpacked = '{default:0};
		Memory   = '{default:0};
		$display ( "Packed   = 0x%h \nUnpacked = %0p \nMemory   = %p\n", 
						Packed, Unpacked, Memory );
		
		// Value assignation
		Packed   = 'hFF_AA_00_55; 
		Unpacked = '{  '{default:1}, '{1,0,1,0,1,0,1,0},
							'{default:0}, '{0,1,0,1,0,1,0,1} };
		Memory   = '{'hFF,'hAA,'h00,'h55};
		$display ( "Packed   = 0x%h \nUnpacked = %0p \nMemory   = %p\n",
						Packed, Unpacked, Memory );
		
		// Slice accessing 
		Packed[1]   = 'h11;	// Not allowed: Packed[15:8] = 'h11
		Unpacked[1] = '{0,0,0,1,0,0,0,1};
		Memory[1]   = 'h11;
		$display ( "Packed   = 0x%h \nUnpacked = %0p \nMemory   = %p\n",
						Packed, Unpacked, Memory );
	end: Main
	
endmodule: Example_03_07_01

// ============================================================
// Example 3.7.2: Dynamic Arrays
// ============================================================
module Example_03_07_02;

	int       Addr[];              		// Dynamic array
	int       newAddr[3] = '{1,2,3};		// Unpacked array
	bit [3:0] data[];              		// Dynamic array
	
	initial begin: Main
		// Creating a 3-items array
		Addr = new[3];
		Addr = '{ 1, 2, 3 };
		$display( "Size=%0d Addr=%p ", Addr.size(), Addr );
		
		// Resizing array, deleting old values
		Addr = new[5] ( '{ 4, 5, 6, 7, 8 } );	
		$display( "Size=%0d Addr=%p ", Addr.size(), Addr );
		
		// Resizing array and preserving old values
		Addr = new[8] ( {newAddr, Addr} );	
		$display( "Size=%0d Addr=%p ", Addr.size(), Addr );
		
		// Delete the array content
		Addr.delete();						
		$display( "Size=%0d Addr=%p ", Addr.size(), Addr );
	end: Main
	
endmodule: Example_03_07_02

// ============================================================
// Example 3.7.3: Queue or List
// ============================================================
module Example_03_07_03;

	int List[$]={}, newList[$:10] = {1,2,3,4,5}; 
	int Item, newItem;
	
	initial begin: Main
		List = newList;
		
		List.insert(3,30);		
		newList = {newList[0:2], 30, newList[3:$]};
		$display( "List={%0p} Size=%0d :: newList={%0p} Size=%0d", 
					List, List.size(), newList, newList.size() );
		
		List.delete(2);		
		newList = {newList[0:1], newList[3:$]};
		$display( "List={%0p} :: newList={%0p}", List, newList );
		
		List.push_front(100);
		newList = {100, newList[0:$]};
		$display( "List={%0p} :: newList={%0p}", List, newList );
		
		List.push_back(500);
		newList = {newList, 500};
		$display( "List={%0p} :: newList={%0p}", List, newList );
		
		Item = List.pop_front();
		newItem = newList[0]; newList = newList[1:$];
		$display( "Item=%0d List={%0p} :: newItem=%0d newList={%0p}", 
					Item, List, newItem, newList );
		
		Item = List.pop_back();
		newItem = newList[$]; newList = newList[0:$-1];
		$display( "Item=%0d List={%0p} :: newItem=%0d newList={%0p}", 
					Item, List, newItem, newList );
	end: Main
	
endmodule: Example_03_07_03

// ============================================================
// Example 3.7.4: Hash or Associative Array
// ============================================================
module Example_03_07_04;
	
	typedef struct { int Age; real Weight; } TData;
	TData Data[string];
	string Name;
	
	initial begin: Main
		$display ("Data = %0p", Data);
		
		Data = '{ 	"Judit":'{14,32.7}, "Erika":'{7,10.0}, 
						"Marco":'{8,23.4}, "Samanta":'{7,15.5} };
		$display ("Data = %p", Data);
		
		if ( Data.exists("Erika") )   Data.delete("Erika");
		$display ("Data = %0p", Data);
		
		if ( !Data.exists("Rebeca") ) Data["Rebeca"] = '{6,14.3};
		$display ("Data = %0p", Data);
		
		assert ( Data.first(Name) );
		$display ("\nName          Age      Weight ");
		$display ("==============================");
		do
			$display( "%s \t %0d \t %2.2fkgr", 
						Name, Data[Name].Age, Data[Name].Weight );
		while( Data.next(Name) );
	end: Main
	
endmodule: Example_03_07_04

// ============================================================
// Example 4.1: Unique/Priority in Conditional Statements
// ============================================================
module Example_04_01;
	
	initial begin: Main
		for( logic[3:0] a=0; a<8; a++ ) begin
			$write("a = %u ('b%b) :: ", a, a);
			unique if ( a == 0 || a == 1 ) $display( "(unique) asserts: 0 or 1" );
			else   if ( a == 2 )           $display( "(unique) asserts: 2" );
			else   if ( a == 4 )           $display( "(unique) asserts: 4" );	
		end
		
		for( logic[3:0] a=0; a<8; a++ ) begin
			$write("a = %u ('b%b) :: ", a, a);
			priority if ( a[2:1] == 'b00 ) $display("(priority) asserts: a[2:1] == 'b00" );
			else     if ( a[2]   == 'b0  ) $display("(priority) asserts: a[2] == 'b0" );
		end
	end: Main
	
endmodule: Example_04_01

// ============================================================
// Example 4.2: Loop Statements
// ============================================================
module Example_04_02;

	typedef struct { int Age; real Weight; } TData;
	TData Data[string] = '{ 
		"Judit":'{14,32.7}, "Rebeca": '{6,14.3}, 
		"Marco":'{8,23.4},  "Samanta":'{7,15.5} 
		};
	string Name;
	
	initial begin: Main
		
		assert ( Data.first(Name) );
		$display ("\nName          Age      Weight ");
		$display ("==============================");
		
		do
			$display( "%s \t %0d \t %2.2fkgr", 
				Name, Data[Name].Age, Data[Name].Weight );
		while( Data.next(Name) );
		
		$display ("\nName          Age      Weight ");
		$display ("==============================");
		
		foreach( Data[Iterator] ) begin
			$display( "%s \t %0d \t %2.2fkgr", 
				Iterator, Data[Iterator].Age, Data[Iterator].Weight );
		end
		
	end: Main
	
endmodule: Example_04_02

// ============================================================
// Example 4.3: Functions
// ============================================================
module Example_04_03;
	
	function int Factorial( int Num=1 );
		return (Num == 0) ? 1 : Num*Factorial(Num-1);
	endfunction: Factorial
	
	initial begin: Main
		
		for( int N=0; N<5; N++ )
			$display( "Factorial(%0d) = %0d", N, Factorial(N) );
		
	end: Main
	
endmodule: Example_04_03

// ============================================================
// Example 4.4: Tasks
// ============================================================
package TaskPkg;
	task automatic Task ( int Id=1, time Time=10ns );
		$display( "[%0tns] Starting Thread #%0d", $time, Id );
		#Time;
		$display( "[%0tns] Thread #%0d has ended", $time, Id );
	endtask: Task
endpackage: TaskPkg

module Example_04_04;

	initial TaskPkg::Task( ,30ns );
	initial TaskPkg::Task( 2, );
	
endmodule: Example_04_04

// ============================================================
// Example 5.2: Intial and Final Processes
// ============================================================
module Example_05_02;

	initial 
	begin
		$display ( "Hello SystemVerilog World!!!" );
		$finish();					// Try to comment this line
		$display ( "%0tns", $time );
		#20;
	end
	
	
endmodule: Example_05_02

// ============================================================
// Example 5.3: Always Processes
// ============================================================
module Example_05_03;
	
	bit Clk=1;
	shortint unsigned a, b;
	
	always #100ns Clk = !Clk;
	
	always_ff @(posedge Clk) {a,b} = $random();
	
	function void Print( string Name );
		$display( "[%0t] %s :: a=%5d b
		=%5d", $time, Name, a, b );
	endfunction: Print
	
	always_comb Print( "always_comb" );
	
	always @(Clk)	Print( "always @*  " );
	//	$display( "[%0t] always @*  :: a=%5d b=%5d", $time, a, b );
	
	initial #1us $finish();
	
endmodule: Example_05_03

// ============================================================
// Example 5.4.1: Threads: fork-join/join_any/join_none
// ============================================================
module Example_05_04_01;
	import TaskPkg::*;
	
	initial begin: Main
		fork
			Task( 1,  5ns );		// Thread #1
			Task( 2, 10ns );		// Thread #2
		//join
		join_any
		//join_none
		//Task( 3, 10ns );			// Thread #3
		#0 Task( 3, 10ns );		// Thread #3
	end: Main
	
endmodule: Example_05_04_01

// ============================================================
// Example 5.4.2: Thread Control: wait-fork
// ============================================================
module Example_05_04_02;
	import TaskPkg::*;

	initial begin: Main
		fork
			Task(1, 10ns);		// Thread #1
			Task(2, 50ns);		// Thread #2
		join_any	
		
		fork
			Task(3, 20ns);		// Thread #3
			Task(4, 30ns);		// Thread #4
		join_none
		
		#0 $display("[%0tns] Waiting for delayed threads...", $time);
		wait fork;				// Try to comment this line
		$display("[%0tns] All threads ended!!!", $time);
		$finish();
	end: Main
	
endmodule: Example_05_04_02

// ============================================================
// Example 5.4.3: Thread Control: disable-fork
// ============================================================
module Example_05_04_03;
	import TaskPkg::*;
	
	task RunTest();
		fork
			Task(1, 20ns);		// Thread #1
			Task(2, 40ns);		// Thread #2
		join
		$display("[%0tns] RunTest thread ended!!!", $time);
	endtask: RunTest
	
	task Timeout ( time Time );
		Task(3, Time);			// Thread #3
		$display("[%0tns] Timeout thread ended!!!", $time);
	endtask: Timeout

	initial begin: Main
		fork
			RunTest();
			Timeout( 40ns );	// Try using 30ns
		join_any
		disable fork;
		$finish();
	end: Main
	
endmodule: Example_05_04_03

// ============================================================
// Example 5.5: Mailboxes
// ============================================================
module Example_05_05;
	mailbox #(int) Fifo = new();
	
	task TxThread( int Num=5 );
		int TxData;
		repeat( Num ) begin
			TxData = $random();
			$display( "[%0t] TxThread :: Sending:   %5d", $time, TxData );
			#10ns Fifo.put( TxData );
		end
	endtask: TxThread
	
	task RxThread();
		int RxData;
		forever begin
			Fifo.get( RxData );
			$display( "[%0t] RxThread :: Receiving: %5d", $time, RxData );
		end
	endtask: RxThread
	
	 initial begin: Main
		fork
			TxThread();
			RxThread();
		join_none
		#0;
		wait fork;
		$finish();
	end: Main
	
endmodule: Example_05_05

// ============================================================
// Example 6.1: Typical Interface (Verilog 1995-2001)
// ============================================================

module Example_06_01;
	module mpu ( output reg rw, en, [7:0]addr, [7:0]dataout, input [7:0]datain );
		// functionality
		reg [7:0] temp, resultado;
		
		initial begin
			en = 0;
			#10
			
			rw = 1;
			addr = 2;
			en = 1;
			#10
			
			temp = datain;
			#10 
			
			addr = 3;
			#10
			
			resultado = temp + datain;
			#10
			
			en = 0;
			rw = 0;
			addr = 5;
			dataout = resultado;
			#10
			
			en = 1;
			//$display( "Escribe dato de la memoria: %h MUP", resultado);
		end
			
	endmodule
	
	module mem ( input  rw, en, [7:0]addr, [7:0]datain, output reg [7:0]dataout );
		// functionality
		reg [7:0] memory [255:0];
		
		initial begin
			memory [2] = 8'h04;
			memory [3] = 8'h08;
		end
		
		always@(*)begin
			if(en) begin
				if(rw)	begin
					dataout = memory [addr];
					$display( "Lee dato de la memoria [%d]: %h", addr, memory [addr]);
				end
				else begin
					memory[addr] = datain;
					$display( "Escribe dato de la memoria [%d]: %h",addr,  memory [addr]);
				end
			end
		end
	endmodule
	
	module top();
		wire        rw, en;
		wire  [7:0] data, data1;
		wire [7:0] addr;
		
		mpu mpu ( .rw(rw), .en(en), .addr(addr), .datain(data), .dataout(data1) );
		mem mem ( .rw(rw), .en(en), .addr(addr), .datain(data1), .dataout(data) );
	endmodule
	
	top top_inst01();

endmodule: Example_06_01

// ============================================================
// Example 6.2: Basic Interface
// ============================================================
module Example_06_02;
	
	interface MemIf();
		logic        rd, wr, en;		
		logic [15:0] addr; 
		logic  [7:0] data;
	endinterface: MemIf
	

	module mpu ( MemIf mpu_if );
		// functionality
	endmodule

	module mem ( MemIf mem_if );
		// functionality
	endmodule
	
	module top();
		MemIf MemIf ();
		mpu   Mpu   ( .mpu_if( MemIf ) );
		mem   Mem   ( .mem_if( MemIf ) );
	endmodule
	
endmodule: Example_06_02

// ============================================================
// Example 6.3: Interface and Modports
// ============================================================
module Example_06_03;

	interface DataIf ( input Clk, Rst );
		logic       Req, Ack;
		logic [7:0] Data; 
		modport MasterMode ( output Req, input  Clk, Rst, Ack, ref Data );
		modport SlaveMode  ( input  Clk, Rst, Req, output Ack, ref Data );
	endinterface: DataIf
	
	//module Master ( DataIf.MasterMode MstIf );	// Mode #1
	module Master ( DataIf MstIf );					// Mode #2
		
		initial {MstIf.Req, MstIf.Data} <= {1'b0,8'hZZ};
		
		task Send( bit [7:0] Data=$random() );
			@(posedge MstIf.Clk) {MstIf.Req, MstIf.Data} <= {1'b1, Data};
			@(posedge MstIf.Clk) {MstIf.Req, MstIf.Data} <= {1'b0,8'hZZ};
		endtask: Send
	endmodule: Master
	
	//module Slave ( DataIf.SlaveMode SlvIf );		// Mode #1
	module Slave ( DataIf SlvIf );						// Mode #2
		
		initial {SlvIf.Ack, SlvIf.Data} <= {1'b0,8'hZZ};
		
		always_ff @(posedge SlvIf.Clk iff !SlvIf.Rst) begin
			SlvIf.Ack  <= SlvIf.Req ?           1 : '0;
			SlvIf.Data <= SlvIf.Req ? ~SlvIf.Data : 'Z;
		end
	endmodule: Slave
	
	module Top();
		
		bit Clk=1, Rst=1;
		always  #50ns  Clk = ~Clk;
		initial #100ns Rst = 0;
		
		DataIf DataIf ( .Clk(Clk), .Rst(Rst) );
		
		//Master Master ( .MstIf ( DataIf ) );				// Mode #1
		Master Master ( .MstIf ( DataIf.MasterMode ) );	// Mode #2
		
		//Slave  Slave  ( .SlvIf  ( DataIf ) );				// Mode #1
		Slave  Slave  ( .SlvIf  ( DataIf.SlaveMode ) );	// Mode #2
		
		initial begin: Main
			@(negedge Rst);
			repeat(5) Master.Send();
			#100ns $finish();
		end: Main
		
		always_ff @(posedge Clk) if( DataIf.Ack )
			$display( "[%0t] SLAVE  - Responding Data=0x%h", $time, DataIf.Data );
		
		always_ff @(posedge Clk) if( DataIf.Req )
			$display( "[%0t] MASTER - Requesting Data=0x%h", $time, DataIf.Data );
		
	endmodule: Top
	
	Top Top1();
	
endmodule: Example_06_03

// ============================================================
// Example 6.4: Virtual Interfaces
// ============================================================
module Example_06_04;
	
	interface DataIf ( input Clk, Rst );
		logic       Req, Ack;
		logic [7:0] Data; 
		modport MasterMode ( output Req, input  Clk, Rst, Ack, ref Data );
		modport SlaveMode  ( input  Clk, Rst, Req, output Ack, ref Data );
	endinterface: DataIf
	
	module Master ();
		virtual DataIf.MasterMode MstVif;
		initial {MstVif.Req, MstVif.Data} = {1'b0,8'hZZ};
		task Send( bit [7:0] Data=$random() );
			@(posedge MstVif.Clk) {MstVif.Req, MstVif.Data} <= {1'b1, Data};
			@(posedge MstVif.Clk) {MstVif.Req, MstVif.Data} <= {1'b0,8'hZZ};
		endtask: Send
	endmodule: Master
	
	//module Slave ( DataIf.SlaveMode SlvIf );		// Mode #1
	module Slave ( DataIf SlvIf );						// Mode #2
		
		initial {SlvIf.Ack, SlvIf.Data} <= {1'b0,8'hZZ};
		
		always_ff @(posedge SlvIf.Clk iff !SlvIf.Rst) begin
			SlvIf.Ack  <= SlvIf.Req ?           1 : '0;
			SlvIf.Data <= SlvIf.Req ? ~SlvIf.Data : 'Z;
		end
	endmodule: Slave
	
	module Top();
		bit Clk=1, Rst=1;
		always  #50ns  Clk = ~Clk;
		initial #100ns Rst = 0;
		
		initial begin: Main
			Master.MstVif = DataIf.MasterMode;
			@(negedge Rst);
			repeat(5) Master.Send();
			#100ns $finish();
		end: Main
		
		always_ff @(posedge Clk) if( DataIf.Ack )
			$display( "[%0t] SLAVE  - Responding Data=0x%h", $time, DataIf.Data );
		
		always_ff @(posedge Clk) if( DataIf.Req )
			$display( "[%0t] MASTER - Requesting Data=0x%h", $time, DataIf.Data );
		
		DataIf DataIf ( .Clk(Clk), .Rst(Rst) );
		
		Master Master ();
		
		Slave Slave( DataIf.SlaveMode );
		
	endmodule: Top
	
	Top Top1();
	
endmodule: Example_06_04

// ============================================================
// Example 6.5: Clocking Blocks
// ============================================================
module Example_06_05;
	
	int  DATABITS=8, ADDRBITS=8;
	time CLKPERIOD=100ns;	
	bit  Clk=1, Rst=1;
	
	always  #(CLKPERIOD/2)  Clk = ~Clk;
	initial #100ns          Rst = 0;
	
	logic                Rd, Wr;
	logic [ADDRBITS-1:0] Addr;
	logic [DATABITS-1:0] Data
	
	SynchMemory #(DATABITS, ADDRBITS) syncMem (
		.Clk(Clk),   .Rst(Rst), 
		.Rd(Rd),     .Wr(Wr),
		.Addr(Addr), .Data(Data) );
	
	module SyncMemory #(int DATABITS=8, ADDRBITS=8 ,time SETUPTIME=5ns, RSPNSTIME=10ns )(
		input logic                Clk, Rst, Rd, Wr, 
		input logic [ADDRBITS-1:0] Addr, 
		inout logic [DATABITS-1:0] Data );
		
		default clocking ClkBlock @(posedge Clk);
			input  #SETUPTIME Rst, Rd, Wr, Addr, Data;
			output #RSPNSTIME Data;
		endclocking
		
		logic [DATABITS-1:0] Mem [2**ADDRBITS];
		
		always_ff @ClkBlock
			if (Rst) Mem       = '{default:0};
			else     Mem[Addr] =  Wr ? Data : Mem[Addr];
		
		always_ff @ClkBlock
			Data <= Rst ? 'Z : Rd ? Mem[Addr] : Data;
		
	endmodule: Memory
	
endmodule: Example_06_05

// ============================================================
// Example 6.6: Clocking Blocks and Interfaces
// ============================================================
module Example_06_06;

	interface RouterIf ( input Clk, Rst );
		logic       ValidIn, ParityError, SizeError, Suspend;
		logic [7:0] DataIn, DataOut[2:0];
		logic [2:0] Enable, ValidOut;
		
		modport DUV (
			input  Clk, Rst, ValidIn, DataIn, Enable,
			output ParityError, SizeError, Suspend, ValidOut, DataOut );
		
		modport DRV (
			input  Clk, Rst, Suspend, 
			output ValidIn, DataIn );
		
		modport MON (
			input Clk, Rst, ValidOut, DataOut, Enable );
		
		clocking cbEnv @(posedge Clk);
			input  Suspend; 
			output ValidIn, DataIn;
			input  negedge Enable, ValidOut, DataOut;
		endclocking
		
	endinterface: RouterIf

endmodule: Example_06_06










