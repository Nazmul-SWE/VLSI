--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:03:25 10/02/2026
-- Design Name:   
-- Module Name:   /home/ise/Full_adder/full_adder_eight_bit_tb.vhd
-- Project Name:  Full_adder
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: full_adder_eight_bit
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY full_adder_eight_bit_tb IS
END full_adder_eight_bit_tb;
 
ARCHITECTURE behavior OF full_adder_eight_bit_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT full_adder_eight_bit
    PORT(
         a0 : IN  std_logic;
         a1 : IN  std_logic;
         a2 : IN  std_logic;
         a3 : IN  std_logic;
         a4 : IN  std_logic;
         a5 : IN  std_logic;
         a6 : IN  std_logic;
         a7 : IN  std_logic;
         b0 : IN  std_logic;
         b1 : IN  std_logic;
         b2 : IN  std_logic;
         b3 : IN  std_logic;
         b4 : IN  std_logic;
         b5 : IN  std_logic;
         b6 : IN  std_logic;
         b7 : IN  std_logic;
         cin : IN  std_logic;
         s0 : OUT  std_logic;
         s1 : OUT  std_logic;
         s2 : OUT  std_logic;
         s3 : OUT  std_logic;
         s4 : OUT  std_logic;
         s5 : OUT  std_logic;
         s6 : OUT  std_logic;
         s7 : OUT  std_logic;
         cout : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal a0 : std_logic := '0';
   signal a1 : std_logic := '0';
   signal a2 : std_logic := '0';
   signal a3 : std_logic := '0';
   signal a4 : std_logic := '0';
   signal a5 : std_logic := '0';
   signal a6 : std_logic := '0';
   signal a7 : std_logic := '0';
   signal b0 : std_logic := '0';
   signal b1 : std_logic := '0';
   signal b2 : std_logic := '0';
   signal b3 : std_logic := '0';
   signal b4 : std_logic := '0';
   signal b5 : std_logic := '0';
   signal b6 : std_logic := '0';
   signal b7 : std_logic := '0';
   signal cin : std_logic := '0';

 	--Outputs
   signal s0 : std_logic;
   signal s1 : std_logic;
   signal s2 : std_logic;
   signal s3 : std_logic;
   signal s4 : std_logic;
   signal s5 : std_logic;
   signal s6 : std_logic;
   signal s7 : std_logic;
   signal cout : std_logic;
   
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: full_adder_eight_bit PORT MAP (
          a0 => a0,
          a1 => a1,
          a2 => a2,
          a3 => a3,
          a4 => a4,
          a5 => a5,
          a6 => a6,
          a7 => a7,
          b0 => b0,
          b1 => b1,
          b2 => b2,
          b3 => b3,
          b4 => b4,
          b5 => b5,
          b6 => b6,
          b7 => b7,
          cin => cin,
          s0 => s0,
          s1 => s1,
          s2 => s2,
          s3 => s3,
          s4 => s4,
          s5 => s5,
          s6 => s6,
          s7 => s7,
          cout => cout
        );

  

   -- Stimulus process
   stim_proc: process
   begin		
    -- Test Case 1: 10 + 12
      -- A = 10 (00001010)
      a7<='0'; a6<='0'; a5<='0'; a4<='0'; a3<='1'; a2<='0'; a1<='1'; a0<='0'; 
      -- B = 12 (00001100)
      b7<='0'; b6<='0'; b5<='0'; b4<='0'; b3<='1'; b2<='1'; b1<='0'; b0<='0';
      cin <= '0';
      wait for 20 ns;
		-- Test Case 2: 13 + 14
      -- A = 13 (00001101)
      a7<='0'; a6<='0'; a5<='0'; a4<='0'; a3<='1'; a2<='1'; a1<='0'; a0<='1'; 
      -- B = 14 (00001110)
      b7<='0'; b6<='0'; b5<='0'; b4<='0'; b3<='1'; b2<='1'; b1<='1'; b0<='0';
      cin <= '0';
      wait for 20 ns;
		-- Test Case 3: 9 + 6
      -- A = 9 (00001001)
      a7<='0'; a6<='0'; a5<='0'; a4<='0'; a3<='1'; a2<='0'; a1<='0'; a0<='1'; 
      -- B = 6 (00000110)
      b7<='0'; b6<='0'; b5<='0'; b4<='0'; b3<='0'; b2<='1'; b1<='1'; b0<='0';
      cin <= '0';
      wait for 20 ns;
		
		-- Test Case 4: 11 + 9
      -- A = 11 (00001011)
      a7<='0'; a6<='0'; a5<='0'; a4<='0'; a3<='1'; a2<='0'; a1<='1'; a0<='1'; 
      -- B = 9 (00001001)
      b7<='0'; b6<='0'; b5<='0'; b4<='0'; b3<='1'; b2<='0'; b1<='0'; b0<='1';
      cin <= '0';
      wait for 20 ns;
		-- Test Case 5: 14 + 2
      -- A = 14 (00001110)
      a7<='0'; a6<='0'; a5<='0'; a4<='0'; a3<='1'; a2<='1'; a1<='1'; a0<='0'; 
      -- B = 2 (00000010)
      b7<='0'; b6<='0'; b5<='0'; b4<='0'; b3<='0'; b2<='0'; b1<='1'; b0<='0';
      cin <= '0';
      wait for 20 ns;

      wait;
		
   end process;

END;
