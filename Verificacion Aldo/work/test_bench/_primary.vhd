library verilog;
use verilog.vl_types.all;
entity test_bench is
    port(
        a               : out    vl_logic_vector(3 downto 0);
        b               : out    vl_logic_vector(3 downto 0);
        dec_enable      : out    vl_logic;
        dec_selector    : out    vl_logic_vector(1 downto 0);
        or_out          : in     vl_logic_vector(3 downto 0);
        nand_out        : in     vl_logic_vector(3 downto 0);
        xor_out         : in     vl_logic_vector(3 downto 0);
        and_out         : in     vl_logic_vector(3 downto 0);
        mux_out         : in     vl_logic_vector(3 downto 0)
    );
end test_bench;
