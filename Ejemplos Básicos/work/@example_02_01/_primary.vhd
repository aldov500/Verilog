library verilog;
use verilog.vl_types.all;
entity Example_02_01 is
    generic(
        DATA            : vl_notype
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA : constant is 4;
end Example_02_01;
