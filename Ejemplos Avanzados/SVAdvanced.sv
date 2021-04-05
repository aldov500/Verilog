// ============================================================
// Example #30 - Class, Objects, and Handlers
// ============================================================
module example30;
	// ---------------------------------------------
	class TBasePacket;
		// Propertie: List of bytes
		byte bList[$];
		
		// Print Method
		function void Print();
			$write( "Packet = {" ); foreach( bList[i] ) $write( "%h,", bList[i] ); 
			$write( "}\n" );
		endfunction: Print
	endclass: TBasePacket
	// ---------------------------------------------
	TBasePacket Packet1, Packet2, Packets[$];	// Object handlers and a list of Packets
	TBasePacket Packet3 = new();				// Creating an object
	// ---------------------------------------------
   initial begin: Main
		Packet1 = new();                   				// Creates the object Packet1
		Packet2 = Packet1;                    			// Packet1 will also be handled by Packet2
		Packet1.bList = {'h11,'h22,'h33,'h44,'h55};		// Modifies Packet1
		$display( "Packet1 using the Packet2 handler:" ); Packet1.Print();
		
		Packet2.bList = {'hAA,'hBB,'hCC};				// Modifies the first copy of Packet1
		Packets = {Packet1};					// Adds Packet1 and Packet2 to Packets
		$display( "List of Packets, content:" );
		foreach ( Packets[i] ) Packets[i].Print();
		
		Packet1.bList = {'h11,'h22,'h33,'h44,'h55};		// Modifies Packet1
		Packet3.bList = {'hAA,'hBB,'hCC};				// Modifies Packet3
		Packets[0] = new Packet1;						// Shallow copy (deep copy should be implemented by the user)
		Packets[1] = new Packet3;
		$display( "List of Packets: content with individual creation:" );
		foreach ( Packets[i] ) Packets[i].Print();
	end: Main
	
endmodule: example30


// ============================================================
// Example #31 - Inheritance and Constructor
// ============================================================
module example31;
	// ---------------------------------------------
	class TBasePacket;					// Superclass Definition
		int PktId;
		byte bList[$];
		// ---------------------------------------------
		function new( int ID=0 ); PktId = ID; endfunction
		// ---------------------------------------------
		function void Print();
			$write( "Packet #%0d = {", PktId ); foreach( bList[i] ) $write( "%h,", bList[i] ); $write( "}\n" );
		endfunction: Print
	endclass: TBasePacket
	// ---------------------------------------------
	class TPacket extends TBasePacket;	// Subclass Definition
		byte Header, Parity;
		// ---------------------------------------------
		function new( int ID=0 ); super.new( ID ); endfunction
		// ---------------------------------------------
		task Print (); 					// Overwrites TBasePacket::Print()
			$display( "New Packet..." );
			bList = {Header, bList, Parity};
			super.Print();				// Uses TBasePacket::Print()
		endtask: Print
	endclass: TPacket
	// ---------------------------------------------
	TBasePacket BasePacket;
	TPacket     Packet;
   initial begin: Main
		Packet         = new(2);
		BasePacket     = Packet;
		Packet.Header  = 'hAA; 
		Packet.Parity  = 'hBB;
		Packet.bList   = {'h11,'h22,'h33,'h44,'h55};
		BasePacket.Print();
		Packet.Print();
	end: Main
	
endmodule: example31


// ============================================================
// Example #32 - Virtual Methods and Polymorphism
// ============================================================
module example32;

	class TFigure;
		virtual function void Draw();
			$display("Figure  :: Draw");
		endfunction: Draw
		// ------------------------------------
		function void Area();
			$display("Figure  :: Compute Area");
		endfunction: Area
	endclass: TFigure

	class TPolygon extends TFigure;
		virtual function void Draw();
			$display("Polygon :: Draw");
		endfunction: Draw
		// ------------------------------------
		function void Area();
			$display("Polygon :: Compute Area");
		endfunction: Area
	endclass: TPolygon

	class TSquare extends TPolygon;
		function void Draw();
			$display("Square  :: Draw");
		endfunction: Draw
		// ------------------------------------
		function void Area();
			$display("Square  :: Compute Area");
		endfunction: Area
	endclass: TSquare

	TSquare  Square  = new();	// Creates a Square object
	TFigure  Figure  = Square;	// figure  handles the square object
	TPolygon Polygon = Square;	// polygon handles the square object
	
	
	initial begin: Main
		Figure.Draw();		// Square :: Draw    <<< POLYMORPHISM
		Figure.Area();		// Figure :: Compute Area
		
		Polygon.Draw();	// Square :: Draw    <<< POLYMORPHISM
		Polygon.Area();	// Polygon:: Compute Area
		
		Square.Draw();		// Square :: Draw
		Square.Area();		// Square :: Compute Area
		
	end: Main	
endmodule: example32


// ============================================================
// Example #33 - Abstract Classes and Virtual Methods
// ============================================================
module example33;

	virtual class TBase;		// Abstract Class
		pure virtual function void Print   ();	// Pure Virtual Method
		pure virtual task          Send    ();	// Pure Virtual Method
		virtual task               Receive (); // Virtual Method, and
		endtask: Receive								//  should be implemented
	endclass: TBase
	
	class TBasePacket extends TBase;	// Subclass
		byte bList[$];
		
		function void Print ();		// Should be implemented
			// ...
		endfunction: Print			// Should be implemented
		
		task Send ();
			// ...
		endtask: Send
		
	endclass: TBasePacket

endmodule: example33


// ============================================================
// Example #34 - Virtual Interface
// ============================================================

// Router Interface
interface RouterIf ( input Clk, Rst );
	logic       ValidIn, ValidOut;
	logic [7:0] DataIn, DataOut;
	modport DUV ( input Clk, Rst, ValidIn, DataIn, output ValidOut, DataOut );
	modport DRV ( input Clk, Rst, output ValidIn, DataIn );
	modport MON ( input Clk, Rst, ValidOut, DataOut );
endinterface: RouterIf

// Module used as DUV
module Router ( RouterIf.DUV RouterIf );
	always_ff @(posedge RouterIf.Clk, posedge RouterIf.Rst) 
		{RouterIf.ValidOut, RouterIf.DataOut} <= RouterIf.Rst ? {1'b0,8'h0} : {RouterIf.ValidIn, RouterIf.DataIn};
endmodule: Router

// This package contains the class definitions for verfication 
package EnvPkg;

	// Transaction class: Simple packet of bytes
	class TPacket;
		rand byte Data[$];
		constraint Size { Data.size() inside {[2:5]}; };
		function string Conv2Str();
			string Pkt = "{";
			foreach( Data[i] ) $sformat( Pkt, "%s %h,", Pkt, Data[i] );
			return {Pkt,"}"};
		endfunction: Conv2Str
	endclass: TPacket
	
	// Base Class
	class TBase;
		int              NumPkt = 0;
		string           Name   = "NAME";
		event            eEnd;
		virtual RouterIf RouterIf;
		
		function new ( string sName ); Name = sName; endfunction
		
		function void Connect ( virtual RouterIf RtrIf );			
			RouterIf = RtrIf;
		endfunction: Connect
	endclass: TBase
	
	// Driver class: To send a TPacket to the DUV
	class TDriver extends TBase;
		
		function new ( string sName ); super.new( sName ); endfunction
		
		// Send task: Converts a TPacket into bit activity using the interface
		task Send ( const ref TPacket Packet );
			$display( "[%5tns][%s]  Sending Packet[%0d]  = %s", $time, Name, NumPkt++, Packet.Conv2Str() );
			foreach( Packet.Data[i] ) @(posedge RouterIf.Clk ) begin
				RouterIf.ValidIn <= (i < Packet.Data.size()-1) ? 1'b1 : 1'b0;
				RouterIf.DataIn  <= Packet.Data[i];
			end
			-> eEnd;
		endtask: Send
		
	endclass: TDriver
	
	// Monitor Class
	class TMonitor extends TBase;
		enum { WAIT, LOAD } State = WAIT;
		
		function new ( string sName ); super.new( sName ); endfunction
		
		// Receive task: Converts bit activity from interface into a TPacket
		task Receive();
			TPacket Packet;
			forever @( posedge RouterIf.Clk )
				unique case( State )
					WAIT:	if  ( RouterIf.ValidOut ) begin
								State  = LOAD;
								Packet = new();
								Packet.Data.push_back( RouterIf.DataOut );
							end
					LOAD:	if ( !RouterIf.ValidOut ) begin
								State = WAIT;
								Packet.Data.push_back( RouterIf.DataOut );
								$display( "[%5tns][%s] Recieved Packet[%0d] = %s", $time, Name, NumPkt++, Packet.Conv2Str() );
								-> eEnd;
							end
							else Packet.Data.push_back( RouterIf.DataOut );
				endcase
		endtask: Receive
		
	endclass: TMonitor
	
endpackage: EnvPkg

// Module used as Testbench
module example34;
	import EnvPkg::*;								// Import Classes for verification
	
	bit Clk=1, Rst=1;								// Top Clock and Reset signals
   always   #50ns Clk = !Clk;					// Clock period:   100ns
   initial #200ns Rst = 0;						// Reset:          200ns

	RouterIf RouterIf( Clk, Rst );			// Interface instance
	Router   DUV  ( RouterIf );				// DUV and Interface connection
	TDriver  Driver  = new( "DRIVER" );		// Driver and Interface connection
	TMonitor Monitor = new( "MONITOR" );	// Monitor and Interface connection
	TPacket  Packet;								// Transaction instance
	
	initial begin
		RouterIf.ValidIn = 1'b0;				// Initial values in RouterIf
		RouterIf.DataIn  = 8'h0;
		Driver.Connect(  RouterIf.DRV );		// Connect the Driver to the RouterIf
		Monitor.Connect( RouterIf.MON );		// Connect the Monitor to the RouterIf
	end
	
	event evSend    = Driver.eEnd;			// Event assignation to show in a waveform
	event evReceive = Monitor.eEnd;
	
	initial begin: Test							// Test sequence:
		Packet = new();							// Create a new Packet
		fork Monitor.Receive(); join_none	// Launch the Monitor (thread)
		@(negedge Rst);							// Wait for a falling edge in Rst
		repeat( 3 ) begin							// For N times
			assert( Packet.randomize() );		// Randomize the new Packet
			Driver.Send( Packet );				// Send the Packet to the RTL
		end
		wait( Monitor.eEnd.triggered() );	// Wait for last packet received
		#200ns										// extra time
		$finish();									// Finish test
	end: Test
		
endmodule: example34
