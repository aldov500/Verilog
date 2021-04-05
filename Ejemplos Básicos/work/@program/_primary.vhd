library verilog;
use verilog.vl_types.all;
entity Program is
    generic(
        DATA            : vl_notype
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA : constant is 4;
end Program;
