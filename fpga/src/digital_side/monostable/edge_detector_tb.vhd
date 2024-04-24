library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity edge_detector_tb is
end entity;

architecture tb of edge_detector_tb is
    signal x: std_logic;
    signal clk: std_logic;
    signal rising_edge_O: std_logic;
    signal falling_edge_O: std_logic;
begin
    -- instantiate the DUT
    dut: entity work.edge_detector
        port map (
            x => x,
            clk => clk,
            rising_edge_O => rising_edge_O,
            falling_edge_O => falling_edge_O
        );

    -- clock process for the test bench
    clk_process: process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    -- test process for the test bench
    test_process: process
    begin
        -- wait for the initial state to settle
        wait for 10 ns;

        -- test the rising edge detection
        x <= '0';
        wait for 10 ns;
        x <= '1';
        wait for 5 ns;
        assert rising_edge_O = '1' report "Rising edge not detected" severity error;
        wait for 5 ns;

        -- test the falling edge detection
        x <= '1';
        wait for 10 ns;
        x <= '0';
        wait for 5 ns;
        assert falling_edge_O = '1' report "Falling edge not detected" severity error;
        wait for 5 ns;

        -- wait for the end of simulation
        wait;
    end process;
end architecture;
