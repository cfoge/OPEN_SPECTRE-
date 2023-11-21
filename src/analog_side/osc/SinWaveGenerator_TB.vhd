library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SinWaveGenerator_TB is
end SinWaveGenerator_TB;

architecture Behavioral of SinWaveGenerator_TB is
    signal clk, reset, sync_in : STD_LOGIC;
    signal freq :  STD_LOGIC_VECTOR(9 downto 0);
    signal sin_out : STD_LOGIC_VECTOR(11 downto 0);
    signal square_out : STD_LOGIC;
begin
    -- Instantiate the SinWaveGenerator module
    UUT: entity work.SinWaveGenerator
        Port map (
            clk => clk,
            reset => reset,
            freq => freq,
            sync_in => sync_in,
            sin_out => sin_out,
            square_out => square_out
        );

    -- Clock process
    process
    begin
        clk <= '0';
        wait for 5 ns; -- Adjust this time period based on your clock frequency
        clk <= '1';
        wait for 5 ns; -- Adjust this time period based on your clock frequency
    end process;

    -- Stimulus process
    process
    begin
        reset <= '1';
        freq <= "0000000000";
        sync_in <= '0';
        wait for 10 ns;

        reset <= '0';
        freq <= "0000001100"; -- Set the frequency to your desired value
--        sync_in <= '1';
        wait for 1000 ns; -- Simulate for some time

     
        wait;
    end process;

end Behavioral;
