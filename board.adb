with Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
use Ada.Text_IO;
package body Board is
    procedure Clear_Board (b : out Board) is
    begin
        b := (others => (others => Cell_Empty));
    end Clear_Board;

    procedure Display_Board (b : Board) is
    begin
        Put(ASCII.ESC & "[2J"); 
        for Y in Rows loop
            for X in Cols loop
                case b(X,Y) is
                    when Cell_Empty => Put(".");
                    when Cell_Snake => Put("#");
                    when Cell_Food => Put("@");
                end case;
            end loop;
            New_Line;
        end loop;
    end Display_Board;

    procedure Gen_Food (b: out Board) is
        package X_Gen_Pack is new
            Ada.Numerics.Discrete_Random (Cols);
        package Y_Gen_Pack is new
            Ada.Numerics.Discrete_Random (Rows);

        X_G : X_Gen_Pack.Generator;
        Y_G : Y_Gen_Pack.Generator;
        X : Cols;
        Y : Rows;
    begin
        X_Gen_Pack.Reset(X_G);
        Y_Gen_Pack.Reset(Y_G);

        X := X_Gen_Pack.Random(X_G);
        Y := Y_Gen_Pack.Random(Y_G);

        while b(X,Y) = Cell_Snake loop
            X := X_Gen_Pack.Random(X_G);
            Y := Y_Gen_Pack.Random(Y_G);
        end loop;

        b(X,Y) := Cell_Food;
    end Gen_Food;

end Board;
