with Interfaces.C; use Interfaces.C;
package C_Interface is
    --pragma Pure(Interfaces.C);
    type cc_t is new unsigned_char;
    type cflag_t is new unsigned;
    type cc_t_array is array (size_t range <>) of aliased cc_t;
    type speed_t is new unsigned;
    -- tcflag_t c_iflag;
    -- tcflag_t c_oflag;
    -- tcflag_t c_cflag;
    -- tcflag_t c_lflag;
    -- cc_t c_line;
    -- cc_t c_cc[32];
    -- speed_t c_ispeed;
    -- speed_t c_ospeed;
    type termios is record 
        c_iflag: cflag_t;		--input mode flags */
        c_oflag: cflag_t;		-- output mode flags */
        c_cflag: cflag_t;		-- control mode flags */
        c_lflag: cflag_t;		-- local mode flags */
        c_line: cc_t;			-- line discipline */
        c_cc: cc_t_array(1..32);
        c_ispeed: speed_t;
        c_ospeed: speed_t;
    end record;
    --pragma Pack(termios);


    function "or"(right, left: cflag_t) return cflag_t;
    function "and"(right, left: cflag_t) return cflag_t;
    function "not"(right: cflag_t) return cflag_t;
    function tcgetattr  (fd : int; term : access termios) return int;
    pragma Import (C, tcgetattr, "tcgetattr");
    function tcsetattr  (fd : int; cmd: int; term : access termios) return int;
    pragma Import (C, tcsetattr, "tcsetattr");
    function fcntl (fd : int; cmd : int; value : int) return int;
    pragma Import (C, fcntl, "fcntl");
end C_Interface;
