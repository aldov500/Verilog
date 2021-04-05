library verilog;
use verilog.vl_types.all;
entity multiplexor is
    port(
        mux_out         : out    vl_logic_vector(3 downto 0);
        mux_selector    : in     vl_logic_vector(3 downto 0);
        mux_and         : in     vl_logic_vector(3 downto 0);
        mux_or          : in     vl_logic_vector(3 downto 0);
        mux_nand        : in     vl_logic_vector(3 downto 0);
        mux_xor         : in     vl_logic_vector(3 downto 0)
    );
end multiplexor;
