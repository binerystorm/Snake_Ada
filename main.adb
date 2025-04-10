with Ada.Text_IO;
with Ada.IO_Exceptions;
with Ada.Assertions;
with Board;
with Board.Snake;
with C_Interface;
with Interfaces.C;
use Ada.Text_IO;


procedure Main is
    package Snake renames Board.Snake;
    use type Board.Rows;
    use type Board.Cols;
    use type Snake.Status;
    use type Snake.Direction;
    use type Snake.SnakeIdx;
    use type Board.Cell;


    type Head is record
        X: Board.Cols;
        Y: Board.Rows;
    end record;

    term: aliased C_Interface.termios;
    b : Board.Board :=  (others => (others => Board.Cell_Empty));
    err : Snake.Status := Snake.Ok;
    drop  : Interfaces.C.int;
    dir : Snake.Direction := Snake.Right;
    s : Snake.Snake;
    new_head: Snake.Vec2 := (0, 0);
    input : String (1..1);

    function Dumb_Or (a: Interfaces.C.int; b: Interfaces.C.int) return Interfaces.C.int is
        type Uint is mod 2** Integer'Size;
    begin
        return Interfaces.C.int (UInt (a) or Uint (b));
    end Dumb_Or;

    procedure Reset_The_Term (term: C_Interface.termios) is
        use C_Interface;
        use Interfaces.C;
        drop: int;
        term_copy: aliased termios := term;
    begin
        drop := tcsetattr(0, 0, term_copy'Access);
    end Reset_The_Term;

    procedure Mangle_The_Term (term: C_Interface.termios) is
        use C_Interface;
        use Interfaces.C;
        drop: int;
        term_copy: aliased termios := term;
    begin
        -- drop := tcgetattr(0, term'Access);
        drop := fcntl(0, 4, Dumb_Or(fcntl(0, 3, 0), int (2048)));
        term_copy.c_lflag := term_copy.c_lflag and not 8;
        term_copy.c_lflag := term_copy.c_lflag and not 2;
        drop := tcsetattr(0, 0, term_copy'Access);
    end Mangle_The_Term;

    procedure Get_Input(s: out String) is
        save: String(1..1) := " ";
    begin
        Get(s);
        save := s;
        while not End_Of_File loop
            Get(s);
        end loop;
    exception
            when ADA.IO_EXCEPTIONS.DEVICE_ERROR => s := save;
    end Get_Input;

begin
    drop := C_Interface.tcgetattr(0, term'Access);
    Mangle_The_Term(term);
    Snake.Init(s,3, b);
    Board.Gen_Food(b);
    loop
        Board.Display_Board(b);
        delay 0.3;
        new_head := s.data(s.head);

        New_Line;
        if  err = snake.collide then
            put_line("you be a loser!!!");
            exit;
        end if;
        -- Put_Line("wel fuck" & Integer'Image(Character'Pos(input(input'First))));
        Get_Input(input);
        exit when input = "q";
        if input = "w" and dir /= Snake.Down then
            dir := Snake.Up;
        elsif input = "a" and dir /= Snake.Right then
            dir := Snake.Left;
        elsif input = "s" and dir  /= Snake.Up then
            dir := Snake.Down;
        elsif input = "d" and dir /= Snake.Left then
            dir := Snake.Right;
        end if;

        case dir is
            when Snake.Up => new_head.Y := new_head.Y - 1;
            when Snake.Down => new_head.Y := new_head.Y + 1;
            when Snake.Left => new_head.X := new_head.X - 1;
            when Snake.Right => new_head.X := new_head.X + 1;
        end case;

        if b(new_head.X, new_head.Y) = Board.Cell_Food then
            Snake.Eat(s, new_head, b);
            if  s.head = s.tail-1 then
                put_line("you be a winner!!!");
                exit;
            end if;
            Board.Gen_Food(b);
        else
            err := Snake.Move(s, new_head, b);
        end if;
    end loop;
    Reset_The_Term(term);
end Main;
