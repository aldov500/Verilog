library verilog;
use verilog.vl_types.all;
entity decodificador is
    port(
        dec_enable      : in     vl_logic;
        dec_selector    : in     vl_logic_vector(1 downto 0);
        dec_out         : out    vl_logic_vector(3 downto 0)
    );
end decodificador;
