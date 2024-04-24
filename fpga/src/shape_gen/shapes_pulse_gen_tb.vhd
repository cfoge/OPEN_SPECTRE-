
--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|                                               
-- Module Name: shapes_pulse_gen_tb by RD Jordan
-- Created: Early 2023
-- Description: 
-- Dependencies: 
-- Additional Comments: You can view the project here: https://github.com/cfoge/OPEN_SPECTRE-
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shapes_pulse_gen_tb is
end entity shapes_pulse_gen_tb;

architecture Behavioral of shapes_pulse_gen_tb is
    constant CLK_PERIOD: time := 10 ns; -- Define the clock period
    
    signal clk: std_logic := '0'; -- Clock signal
    signal rst: std_logic := '1'; -- Reset signal
    signal counter_in: std_logic_vector(8 downto 0) := (others => '0');
    signal pulse_start: std_logic_vector(8 downto 0) := (others => '0');
    signal pulse_len: std_logic_vector(8 downto 0) := (others => '0');
    signal pulse_out: std_logic;
    signal ramp_out: std_logic_vector(8 downto 0);
    signal zoom     : std_logic_vector(8 downto 0);
    
begin
    -- Instantiate the DUT (Design Under Test)
    dut: entity work.shapes_pulse_gen
        port map (
            clk => clk,
            rst => rst,
            zoom => zoom,
            counter_in => counter_in,
            pulse_start => pulse_start,
            pulse_len => pulse_len,
            pulse_out => pulse_out,
            ramp_out => ramp_out
        );
        
    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize inputs
        counter_in <= (others => '0');
        pulse_start <= "000001010"; -- - 10
        pulse_len   <= "010010011"; --
        zoom   <= "000001111"; --

        
        -- Apply reset
        rst <= '1';
        wait for 5 ns;
        rst <= '0';
        
        -- Wait for a few clock cycles
        wait for 5 ns;
        
--        -- Set inputs and observe outputs
        counter_in <= "000001010";
--        pulse_start <= "000000001";
--        pulse_len <= "000000010";
--        wait for 10 ns;
        
--        counter_in <= "000000010";
--        pulse_start <= "000000005";
--        pulse_len <= "000000020";
--        wait for 10 ns;
        
--        counter_in <= "000000100";
--        pulse_start <= "000000050";
--        pulse_len <= "000000030";
--        wait for 10 ns;
        
--        counter_in <= "000000111";
--        pulse_start <= "000000080";
--        pulse_len <= "000000040";
--        wait for 10 ns;
        
--        counter_in <= "000001000";
--        pulse_start <= "000000100";
--        pulse_len <= "000000050";
--        wait for 10 ns;
        
        -- Add more test cases as needed
        
        -- End the simulation
        wait;
    end process;
    
    -- Clock process
    clk_proc: process
    begin
        while now < 1000 us loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;
    
end architecture Behavioral;
