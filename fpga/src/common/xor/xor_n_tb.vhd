
--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|                                               
-- Module Name: xor_n_tb by RD Jordan
-- Created: Early 2023
-- Description: 
-- Dependencies: 
-- Additional Comments: You can view the project here: https://github.com/cfoge/OPEN_SPECTRE-
-- test bench for n parallel XOR gates

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity xor_n_tb is
end entity;

architecture behavioral of xor_n_tb is
    -- test inputs
    signal a: std_logic_vector(7 downto 0) := (others => '0');
    signal b: std_logic_vector(7 downto 0) := (others => '0');

    -- test output
    signal y: std_logic_vector(7 downto 0);

    -- instantiate the XOR gates
    component xor_n is
        generic (
            n: positive := 4 -- number of XOR gates
        );
        port (
            a: in std_logic_vector(n-1 downto 0);  -- first inputs
            b: in std_logic_vector(n-1 downto 0);  -- second inputs
            y: out std_logic_vector(n-1 downto 0)  -- outputs
        );
    end component;

begin
    -- instantiate the XOR gates
    UUT: xor_n
        generic map (
            n => 8
        )
        port map (
            a => a,
            b => b,
            y => y
        );

-- test stimulus process
stim_proc: process
begin
    -- set the input signals and wait for the output to be stable
    a <= "00000001";
    b <= "00000000";
    wait for 10 ns;
    assert y = "00000000" report "Test 1 failed" severity error;

    -- set the input signals and wait for the output to be stable
    a <= "11111110";
    b <= "11111111";
    wait for 10 ns;
    assert y = "00000000" report "Test 2 failed" severity error;

    -- set the input signals and wait for the output to be stable
    a <= "10101010";
    b <= "01010101";
    wait for 10 ns;
    assert y = "11111111" report "Test 3 failed" severity error;

    -- set the input signals and wait for the output to be stable
    a <= "01010101";
    b <= "10101010";
    wait for 10 ns;
    assert y = "11111111" report "Test 4 failed" severity error;

    -- end the test
    wait;
end process;
end architecture;
