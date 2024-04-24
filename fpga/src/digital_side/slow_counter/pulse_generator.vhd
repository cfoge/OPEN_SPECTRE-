library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pulse_generator is
    generic (
        toggle_period : natural := 156_250_000 -- Number of clock cycles for 0.4 Hz toggle frequency
    );
    port (
        clk : in std_logic;
        enable: in std_logic;    -- enable input
        output : out std_logic
    );
end entity pulse_generator;

architecture Behavioral of pulse_generator is
    signal toggle_counter : natural range 0 to toggle_period - 1 := 0;
    signal toggle_output : std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if enable = '1' then
                if toggle_counter = toggle_period - 1 then
                    toggle_output <= not toggle_output;
                    toggle_counter <= 0;
                else
                    toggle_counter <= toggle_counter + 1;
                end if;
            end if;
        end if;
    end process;

    output <= toggle_output;
end architecture Behavioral;
