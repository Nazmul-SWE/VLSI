----------------------------------------------------------------------------------
-- Design  : 4-bit register
-- Features: asynchronous active-low reset (RST_N), synchronous write enable (WE)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nibble_register is
    Port ( CLK   : in  STD_LOGIC;                        -- clock, rising edge
           RST_N : in  STD_LOGIC;                        -- asynchronous reset, active-low
           WE    : in  STD_LOGIC;                        -- write enable
           DIN   : in  STD_LOGIC_VECTOR (3 downto 0);    -- data in
           DOUT  : out STD_LOGIC_VECTOR (3 downto 0) );  -- stored data out
end nibble_register;

architecture RTL of nibble_register is
    signal reg_q : STD_LOGIC_VECTOR (3 downto 0);
begin

    reg_proc : process (CLK, RST_N)
    begin
        if RST_N = '0' then
            reg_q <= "0000";                    -- reset acts immediately
        elsif rising_edge(CLK) then
            if WE = '1' then
                reg_q <= DIN;                   -- write
            end if;                             -- otherwise keep old value
        end if;
    end process reg_proc;

    DOUT <= reg_q;

end RTL;
