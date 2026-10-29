-- Self-checking testbench for alu_4bit
-- Part 1: directed tests   Part 2: exhaustive test (8 opcodes x 16 x 16)
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_4bit_tb is
end alu_4bit_tb;

architecture Sim of alu_4bit_tb is

    component alu_4bit
        Port ( X      : in  STD_LOGIC_VECTOR (3 downto 0);
               Y      : in  STD_LOGIC_VECTOR (3 downto 0);
               OPCODE : in  STD_LOGIC_VECTOR (2 downto 0);
               F      : out STD_LOGIC_VECTOR (3 downto 0);
               COUT   : out STD_LOGIC;
               ZF     : out STD_LOGIC);
    end component;

    signal X_s, Y_s : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal OP_s     : STD_LOGIC_VECTOR (2 downto 0) := "000";
    signal F_s      : STD_LOGIC_VECTOR (3 downto 0);
    signal COUT_s, ZF_s : STD_LOGIC;

    -- expected 5-bit result (bit 4 = carry/borrow) from plain integer maths
    function model (x, y, op : integer) return integer is
        variable ux : unsigned(3 downto 0) := to_unsigned(x, 4);
        variable uy : unsigned(3 downto 0) := to_unsigned(y, 4);
    begin
        case op is
            when 0 => return x + y;
            when 1 => if x >= y then return x - y; else return x - y + 32; end if;
            when 2 => return to_integer(ux and uy);
            when 3 => return to_integer(ux or  uy);
            when 4 => return to_integer(ux xor uy);
            when 5 => return 15 - x;
            when 6 => return x + 1;
            when others => return 2 * x;
        end case;
    end function;

begin

    UUT : alu_4bit port map (X => X_s, Y => Y_s, OPCODE => OP_s,
                             F => F_s, COUT => COUT_s, ZF => ZF_s);

    process
        variable errors : integer := 0;
        variable total  : integer := 0;
        variable m      : integer;

        procedure drive (x, y, op : in integer) is
        begin
            X_s  <= std_logic_vector(to_unsigned(x, 4));
            Y_s  <= std_logic_vector(to_unsigned(y, 4));
            OP_s <= std_logic_vector(to_unsigned(op, 3));
            wait for 10 ns;
        end procedure;

        -- directed test with hand-calculated expected F, COUT, ZF
        procedure directed (x, y, op, ef : in integer; ec, ez : in STD_LOGIC) is
        begin
            drive(x, y, op);
            total := total + 1;
            if F_s /= std_logic_vector(to_unsigned(ef, 4)) or
               COUT_s /= ec or ZF_s /= ez then
                errors := errors + 1;
                report "Directed test failed: op=" & integer'image(op) &
                       " x=" & integer'image(x) & " y=" & integer'image(y)
                       severity error;
            end if;
        end procedure;
    begin
        wait for 10 ns;

        --        x   y  op  F   COUT ZF
        directed ( 5,  3, 0,  8, '0','0');   -- 5 + 3
        directed (15,  1, 0,  0, '1','1');   -- 15 + 1 : carry, zero
        directed ( 7,  2, 1,  5, '0','0');   -- 7 - 2
        directed ( 3,  5, 1, 14, '1','0');   -- 3 - 5  : borrow
        directed ( 6,  6, 1,  0, '0','1');   -- 6 - 6  : zero
        directed ( 9,  5, 2,  1, '0','0');   -- 1001 and 0101
        directed ( 9,  5, 3, 13, '0','0');   -- 1001 or  0101
        directed ( 9,  5, 4, 12, '0','0');   -- 1001 xor 0101
        directed (10,  0, 5,  5, '0','0');   -- not 1010
        directed (15,  0, 6,  0, '1','1');   -- 15 + 1
        directed ( 9,  0, 7,  2, '1','0');   -- 1001 << 1 = 0010, carry 1

        -- exhaustive check against the model
        for op in 0 to 7 loop
            for x in 0 to 15 loop
                for y in 0 to 15 loop
                    drive(x, y, op);
                    m := model(x, y, op);
                    total := total + 1;
                    if F_s /= std_logic_vector(to_unsigned(m mod 16, 4)) or
                       COUT_s /= std_logic(to_unsigned(m / 16, 1)(0)) or
                       (ZF_s = '1') /= ((m mod 16) = 0) then
                        errors := errors + 1;
                        report "Mismatch: op=" & integer'image(op) &
                               " x=" & integer'image(x) & " y=" & integer'image(y)
                               severity error;
                    end if;
                end loop;
            end loop;
        end loop;

        if errors = 0 then
            report "PASS: alu_4bit - " & integer'image(total) &
                   " tests, no errors" severity note;
        else
            report "FAIL: alu_4bit - " & integer'image(errors) &
                   " errors" severity error;
        end if;
        wait;
    end process;

end Sim;
