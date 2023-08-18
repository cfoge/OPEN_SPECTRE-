
--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|                                               
-- Module Name: window_comparator_tb by RD Jordan
-- Created: Early 2023
-- Description: 
-- Dependencies: 
-- Additional Comments: You can view the project here: https://github.com/cfoge/OPEN_SPECTRE-
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity window_comparator_tb is
end window_comparator_tb;

architecture Behavioral of window_comparator_tb is
    signal input, lower, upper : std_logic_vector(7 downto 0);
    signal output : std_logic;
begin
    -- Instantiate the DUT
    dut: entity work.window_comparator
        port map (input => input, lower => lower, upper => upper, output => output);
stim_proc: process
    begin
    -- Test case 1: input within the window
    input <= "01010101";
    lower <= "01000000";
    upper <= "01111111";
    wait for 10 ns;
    assert output = '1'
    report "Test case 1 failed: input within the window" severity error;
    wait for 10 ns;
    -- Test case 2: input below the lower threshold
    input <= "00111111";
    lower <= "01000000";
    upper <= "01111111";
    wait for 10 ns;
    assert output = '0'
    report "Test case 2 failed: input below the lower threshold" severity error;
    wait for 10 ns;
    -- Test case 3: input above the upper threshold
    input <= "01111111";
    lower <= "01000000";
    upper <= "01100000";
    wait for 10 ns;
    assert output = '0'
    report "Test case 3 failed: input above the upper threshold" severity error;
       -- end the test
        wait;
    end process;
end Behavioral;
