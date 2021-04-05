// ============================================================
// Example #34 - Virtual Interface
// ============================================================

// Module used as DUV
module Router ( RouterIf.DUV RouterIf );
	always_ff @(posedge RouterIf.Clk, posedge RouterIf.Rst) 
	{RouterIf.ValidOut, RouterIf.DataOut} <= RouterIf.Rst ? {1'b0,8'h0} : {RouterIf.ValidIn, RouterIf.DataIn};
endmodule: Router

// Router Interface
interface RouterIf ( input Clk, Rst );
	logic       ValidIn, ValidOut;
	logic [7:0] DataIn, DataOut;
	modport DUV ( 
		input Clk, Rst, ValidIn, DataIn, 
		output ValidOut, DataOut );
	
	modport DRV ( input Clk, Rst, 
		output ValidIn, DataIn );
	
	modport MON ( input Clk, Rst, ValidOut, DataOut );

endinterface: RouterIf



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
