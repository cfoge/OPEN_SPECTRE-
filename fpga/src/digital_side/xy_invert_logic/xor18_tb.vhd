-- test bench for 18 parallel XOR gates

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity xor18_tb is
end entity;

architecture behavioral of xor18_tb is
    -- test inputs
    signal a: std_logic_vector(17 downto 0) := (others => '0');
    signal b: std_logic_vector(17 downto 0) := (others => '0');

    -- test output
    signal y: std_logic_vector(17 downto 0);

    -- instantiate the XOR gates
    component xor18 is
        port (
            a: in std_logic_vector(17 downto 0);  -- first inputs
            b: in std_logic_vector(17 downto 0);  -- second inputs
            y: out std_logic_vector(17 downto 0)  -- outputs
        );
    end component;

begin
    -- instantiate the XOR gates
    UUT: xor18
        port map (
            a => a,
            b => b,
            y => y
        );

    -- test stimulus process
    stim_proc: process
  begin
    -- set the input signals and wait for the output to be stable
    a <= "000000000000000000";
    b <= "000000000000000000";
    wait for 10 ns;
    assert y = "000000000000000000" report "Test 1 failed" severity error;

    -- set the input signals and wait for the output to be stable
    a <= "111111111111111111";
    b <= "111111111111111111";
    wait for 10 ns;
    assert y = "000000000000000000" report "Test 2 failed" severity error;

    -- set the input signals and wait for the output to be stable
    a <= "101010101010101010";
    b <= "010101010101010101";
    wait for 10 ns;
    assert y = "111111111111111111" report "Test 3 failed" severity error;

    -- set the input signals and wait for the output to be stable
    a <= "010101010101010101";
    b <= "101010101010101010";
    wait for 10 ns;
    assert y = "111111111111111111" report "Test 4 failed" severity error;

    -- end the test
    wait;
    end process;
end architecture;
