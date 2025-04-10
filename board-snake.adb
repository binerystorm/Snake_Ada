package body Board.Snake is
    function Move (s: out Snake; new_head: Vec2; b: out Board)
    return Status is
        tail: Vec2 := s.data(s.tail);
    begin
        if b(new_head.X, new_head.Y) = Cell_Snake then 
            return Collide;
        end if;
        s.tail := s.tail + 1;
        b(tail.X, tail.Y) := Cell_Empty;

        s.head := s.head + 1;
        b(new_head.X, new_head.Y) := Cell_Snake;

        s.data(s.head) := new_head;
        return Ok;
    end Move;

    procedure Eat(s: out Snake; new_head: Vec2; b: out Board) is
    begin
        s.head := s.head + 1;
        b(new_head.X, new_head.Y) := Cell_Snake;
        s.data(s.head) := new_head;
    end Eat;

    procedure Init (s: out Snake; len: SnakeIdx; b: out Board) is
        Y: Rows := 0;
        X: Cols := 0;
    begin
        s.head := len-1;
        s.tail := 0;
        for I in 0..len-1 loop
            s.data(I).X := X; 
            s.data(I).Y := Y; 
            b(X,Y) := Cell_Snake;
            X := X + 1;
            if X = 0 then 
                Y := Y+1;
            end if;
        end loop;
    end Init;

end Board.Snake;
