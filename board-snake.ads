-- with Board;
-- use Board;
package Board.Snake is
    type Vec2 is record
        Y: Rows;
        X: Cols;
    end record;
    type Direction is (Up, Down, Left, Right);
    type Status is (Ok, Collide);
    type SnakeIdx is mod (Integer (Rows'Last) + 1) * (Integer (Cols'Last) + 1);
    type RingBuffer is array (SnakeIdx) of Vec2;
    type Snake is record
        head: SnakeIdx;
        tail: SnakeIdx;
        data: RingBuffer;
    end record;

    procedure Init (s: out Snake; len: SnakeIdx; b: out Board);
    function Move (s: out Snake; new_head: Vec2; b: out Board) return Status;
    procedure Eat(s: out Snake; new_head: Vec2; b: out Board);
    -- procedure Eat (s: out Snake; pos: Vec2);

end Board.Snake;
