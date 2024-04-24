LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY compare_7_tb IS
END compare_7_tb;

ARCHITECTURE behavior OF compare_7_tb IS 

COMPONENT compare_7
    PORT(
         clk : IN  std_logic;
         luma_i : IN  std_logic_vector(7 downto 0);
         output : OUT  std_logic_vector(6 downto 0);
         span : IN  std_logic_vector(7 downto 0)
        );
END COMPONENT;

SIGNAL clk : std_logic := '0';
SIGNAL luma_i : std_logic_vector(7 downto 0);
SIGNAL output : std_logic_vector(6 downto 0);
SIGNAL span : std_logic_vector(7 downto 0);

BEGIN

UUT: compare_7 PORT MAP (
    clk => clk,
    luma_i => luma_i,
    output => output,
    span => span
);

CLOCK: process
begin
    clk <= '0';
    wait for 5 ns;
    clk <= '1';
    wait for 5 ns;
end process;

STIMULUS: process
begin
    --Test 1
    luma_i <= "00000000";
    span <= "11111111";
    wait for 10 ns;
    assert output = "0000000" report "Test 1 failed" severity error;

    --Test 2
    luma_i <= "01010101";
    span <= "11111111";
    wait for 10 ns;
    assert output = "0000001" report "Test 2 failed" severity error;

    --Test 3
    luma_i <= "11111111";
    span <= "00000000";
    wait for 10 ns;
    assert output = "0000001" report "Test 3 failed" severity error;

    --Test 4
    luma_i <= "11111111";
    span <= "11111111";
    wait for 10 ns;
    assert output = "0000000" report "Test 4 failed" severity error;

    wait;
end process;

END;
