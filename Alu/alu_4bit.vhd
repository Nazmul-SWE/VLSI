-- 4-bit ALU (dataflow style), Xilinx ISE / VHDL-93
-- OPCODE : 000 ADD   F = X + Y
--          001 SUB   F = X - Y   (COUT = borrow)
--          010 AND   F = X and Y
--          011 OR    F = X or Y
--          100 XOR   F = X xor Y
--          101 NOT   F = not X
--          110 INC   F = X + 1
--          111 SHL   F = X shifted left by 1 (COUT = old X(3))
-- ZF = '1' when F = "0000"
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_4bit is
    Port ( X      : in  STD_LOGIC_VECTOR (3 downto 0);
           Y      : in  STD_LOGIC_VECTOR (3 downto 0);
           OPCODE : in  STD_LOGIC_VECTOR (2 downto 0);
           F      : out STD_LOGIC_VECTOR (3 downto 0);
           COUT   : out STD_LOGIC;
           ZF     : out STD_LOGIC);
end alu_4bit;

architecture Dataflow of alu_4bit is
    signal xu, yu : unsigned(3 downto 0);
    signal r      : unsigned(4 downto 0);   -- 5 bits: bit 4 = carry / borrow
begin
    xu <= unsigned(X);
    yu <= unsigned(Y);

    with OPCODE select
        r <= ('0' & xu) + ('0' & yu)   when "000",
             ('0' & xu) - ('0' & yu)   when "001",
             '0' & (xu and yu)         when "010",
             '0' & (xu or  yu)         when "011",
             '0' & (xu xor yu)         when "100",
             '0' & (not xu)            when "101",
             ('0' & xu) + 1            when "110",
             xu & '0'                  when "111",
             "00000"                   when others;

    F    <= std_logic_vector(r(3 downto 0));
    COUT <= r(4);
    ZF   <= '1' when r(3 downto 0) = "0000" else '0';
end Dataflow;
