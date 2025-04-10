package Board is
    type Rows is mod 10;
    type Cols is mod 10;
    type Cell is (Cell_Empty, Cell_Snake, Cell_Food);
    type Board is array (Cols, Rows) of Cell;

    procedure Display_Board (b : Board);
    procedure Clear_Board (b : out Board);
    procedure Gen_Food (b: out Board);
end Board;
