library verilog;
use verilog.vl_types.all;
entity and_gate is
    port(
        and_a           : in     vl_logic_vector(3 downto 0);
        and_b           : in     vl_logic_vector(3 downto 0);
        and_out         : out    vl_logic_vector(3 downto 0)
    );
end and_gate;
