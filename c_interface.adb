with Interfaces.C; use Interfaces.C;
package body C_Interface is
    function "and"(right, left: cflag_t) return cflag_t is
    begin
        return cflag_t(unsigned (right) and unsigned (left));
    end "and";

    function "not"(right: cflag_t) return cflag_t is
    begin
        return cflag_t(not unsigned (right));
    end "not";
    
    function "or"(right, left: cflag_t) return cflag_t is
    begin
        return cflag_t(unsigned (right) or unsigned (left));
    end "or";
end C_Interface;
