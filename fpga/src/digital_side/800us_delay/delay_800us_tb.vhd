library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity delay_800us_tb is
end entity;

architecture behavioral of delay_800us_tb is
    signal clk: std_logic := '0';
    signal input: std_logic := '0';
    signal output: std_logic;
begin
    -- Create a clock signal with a 50% duty cycle
    clk_process: process
    begin
        wait for 10 ns;
        clk <= not clk;
        if now > 100 ns then
            wait;
        end if;
    end process;

    -- Instantiate the design under test
    dut: entity work.delay_800us
        port map (
            clk => clk,
            input => input,
            output => output
        );

    -- Test the delay by toggling the input signal and checking the output
    test_process: process
    begin
        -- Wait for the clock to stabilize
        wait for 50 ns;

        -- Assert that the output is 'Z' (undetermined) initially
        assert output = 'Z' report "Output is not 'Z' initially" severity note;

        -- Toggle the input signal and wait for one clock cycle
        input <= not input;
        wait for 10 ns;

        -- Assert that the output has not changed
        assert output = 'Z' report "Output changed before delay expired" severity note;

        -- Wait for the delay to expire
        wait for 200 us;

        -- Assert that the output has changed to the same value as the input
        assert output = input report "Output does not match input after delay expired" severity note;

        -- Toggle the input signal and wait for one clock cycle
        input <= not input;
        wait for 10 ns;

        -- Assert that the output has not changed
        assert output = input report "Output changed before delay expired" severity note;

        -- Wait for the delay to expire
        wait for 200 us;

        -- Assert that the output has changed to the same value as the input
        assert output = input report "Output does not match input after delay expired" severity note;

        wait;
    end process;
end architecture;
