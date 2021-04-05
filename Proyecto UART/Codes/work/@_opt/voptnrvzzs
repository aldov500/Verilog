library verilog;
use verilog.vl_types.all;
entity uart_tx is
    generic(
        bit_time        : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        idle            : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        start           : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        delay           : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        shift           : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        stop            : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of bit_time : constant is 1;
    attribute mti_svvh_generic_type of idle : constant is 1;
    attribute mti_svvh_generic_type of start : constant is 1;
    attribute mti_svvh_generic_type of delay : constant is 1;
    attribute mti_svvh_generic_type of shift : constant is 1;
    attribute mti_svvh_generic_type of stop : constant is 1;
end uart_tx;
