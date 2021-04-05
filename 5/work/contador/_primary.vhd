library verilog;
use verilog.vl_types.all;
entity contador is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        enable          : in     vl_logic;
        old_valor       : out    vl_logic_vector(7 downto 0);
        new_valor       : out    vl_logic_vector(7 downto 0);
        \out\           : out    vl_logic_vector(7 downto 0)
    );
end contador;
