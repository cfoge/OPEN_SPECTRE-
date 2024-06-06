--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:49:01 02/03/2012
-- Design Name:   
-- Module Name:   /home/rene/test/midi_tb.vhd
-- Project Name:  test
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: midi
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
 
ENTITY midi_tb IS
END midi_tb;
 
ARCHITECTURE behavior OF midi_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT midi
    PORT(
         clk : IN  std_logic;
         midi_in : IN  std_logic;
         midi_new : OUT  std_logic;
         midi_ch : OUT  std_logic_vector(3 downto 0);
         midi_note : OUT  std_logic_vector(6 downto 0);
         midi_velo : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal midi_in : std_logic := '0';
   signal midi_data : std_logic_vector(7 downto 0) := (others => '0');
   signal uart_busy : std_logic := '1';

 	--Outputs
   signal midi_new : std_logic;
   signal midi_ch : std_logic_vector(3 downto 0);
   signal midi_note : std_logic_vector(6 downto 0);
   signal midi_velo : std_logic_vector(6 downto 0);
   signal data : std_logic_vector(7 downto 0);
   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant bit_time: time := 1 sec / 31250;
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: midi PORT MAP (
          clk => clk,
          midi_in => midi_in,
          midi_new => midi_new,
          midi_ch => midi_ch,
          midi_note => midi_note,
          midi_velo => midi_velo
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      midi_in <= '1';
      wait for 100 ns;

      wait for bit_time;
      data <= "10010101";
      midi_in <= '0';
      wait for bit_time;
      for i in 0 to 7 loop
      midi_in <= data(i);
      wait for bit_time;
      end loop;
      midi_in <= '1';
      wait for bit_time;

      wait for bit_time;
      data <= "01010101";
      midi_in <= '0';
      wait for bit_time;
      for i in 0 to 7 loop
      midi_in <= data(i);
      wait for bit_time;
      end loop;
      midi_in <= '1';
      wait for bit_time;

      wait for bit_time;
      data <= "01111111";
      midi_in <= '0';
      wait for bit_time;
      for i in 0 to 7 loop
      midi_in <= data(i);
      wait for bit_time;
      end loop;
      midi_in <= '1';
      wait for bit_time;


      wait for bit_time;
      data <= "10000101";
      midi_in <= '0';
      wait for bit_time;
      for i in 0 to 7 loop
      midi_in <= data(i);
      wait for bit_time;
      end loop;
      midi_in <= '1';
      wait for bit_time;

      wait for bit_time;
      data <= "01010101";
      midi_in <= '0';
      wait for bit_time;
      for i in 0 to 7 loop
      midi_in <= data(i);
      wait for bit_time;
      end loop;
      midi_in <= '1';
      wait for bit_time;

      wait for bit_time;
      data <= "00000000";
      midi_in <= '0';
      wait for bit_time;
      for i in 0 to 7 loop
      midi_in <= data(i);
      wait for bit_time;
      end loop;
      midi_in <= '1';
      wait for bit_time;



      wait for clk_period*10;
      -- insert stimulus here 

      wait;
   end process;

END;
