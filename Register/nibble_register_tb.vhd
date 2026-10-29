----------------------------------------------------------------------------------
-- Testbench for nibble_register (4-bit register)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nibble_register_tb is
end nibble_register_tb;

architecture sim of nibble_register_tb is

    constant CLK_HALF : time := 5 ns;                    -- 10 ns clock period

    signal clk   : std_logic := '0';
    signal rst_n : std_logic := '0';
    signal we    : std_logic := '0';
    signal din   : std_logic_vector(3 downto 0) := "0000";
    signal dout  : std_logic_vector(3 downto 0);
    signal done  : boolean := false;

    type nibble_array is array (0 to 5) of std_logic_vector(3 downto 0);
    constant TEST_DATA : nibble_array := ("1010", "0101", "0001", "1000", "1111", "0110");

begin

    dut : entity work.nibble_register
        port map ( CLK => clk, RST_N => rst_n, WE => we, DIN => din, DOUT => dout );

    -- clock runs until the stimulus is finished
    clock_gen : process
    begin
        while not done loop
            clk <= '0'; wait for CLK_HALF;
            clk <= '1'; wait for CLK_HALF;
        end loop;
        wait;
    end process clock_gen;

    stimulus : process

        -- apply one clock cycle and check the output just after the edge
        procedure cycle (value      : in std_logic_vector(3 downto 0);
                         write_en   : in std_logic;
                         expect_out : in std_logic_vector(3 downto 0);
                         msg        : in string) is
        begin
            din <= value;
            we  <= write_en;
            wait until rising_edge(clk);
            wait for 1 ns;
            assert dout = expect_out
                report "FAIL: " & msg severity error;
        end procedure;

    begin
        -- 1. power-up: reset held low
        rst_n <= '0';
        wait for 12 ns;
        assert dout = "0000" report "FAIL: async reset did not clear output" severity error;

        -- release reset away from a clock edge
        rst_n <= '1';
        wait until falling_edge(clk);

        -- 2. WE = 0 : input must be ignored
        cycle("1111", '0', "0000", "write happened with WE=0");

        -- 3. write every pattern in the table
        for i in TEST_DATA'range loop
            cycle(TEST_DATA(i), '1', TEST_DATA(i), "pattern not stored");
        end loop;

        -- 4. hold: new data on DIN but WE = 0 (last stored value was "0110")
        cycle("1001", '0', "0110", "value changed with WE=0");
        cycle("0000", '0', "0110", "value changed with WE=0 (second hold)");

        -- 5. asynchronous reset in the middle of a clock cycle
        wait until falling_edge(clk);
        rst_n <= '0';
        wait for 1 ns;                           -- no clock edge has happened yet
        assert dout = "0000" report "FAIL: reset is not asynchronous" severity error;
        wait until rising_edge(clk);
        wait for 1 ns;
        assert dout = "0000" report "FAIL: output changed while reset active" severity error;

        -- 6. writes are ignored during reset, then work again after release
        cycle("1100", '1', "0000", "write accepted during reset");
        wait until falling_edge(clk);
        rst_n <= '1';
        cycle("1100", '1', "1100", "write failed after reset release");

        report "PASS: nibble_register testbench completed" severity note;
        done <= true;
        wait;
    end process stimulus;

end sim;
