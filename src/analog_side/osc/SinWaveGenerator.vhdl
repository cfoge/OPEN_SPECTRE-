library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SinWaveGenerator is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        freq : in STD_LOGIC_VECTOR(9 downto 0);
        sync_in : in STD_LOGIC;
        sin_out : out STD_LOGIC_VECTOR(11 downto 0);
        square_out : out STD_LOGIC
    );
end SinWaveGenerator;

architecture Behavioral of SinWaveGenerator is
    signal counter : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
    signal phase_accumulator : STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
    signal sine_table : STD_LOGIC_VECTOR(11 downto 0) := "000010010111"; -- 12-bit sine values for one period
    signal sync_edge : STD_LOGIC := '0';

begin
    process(clk, reset, sync_in)
    begin
        if reset = '1' then
            counter <= (others => '0');
            phase_accumulator <= (others => '0');
            sync_edge <= '0';
        elsif rising_edge(clk) then
            if sync_in = '1' and sync_edge = '0' then
                sync_edge <= '1';
                counter <= (others => '0');
                phase_accumulator <= (others => '0');
            else
                sync_edge <= sync_in;
                counter <= counter + 1;
                if counter = freq then
                    counter <= (others => '0');
                    phase_accumulator <= phase_accumulator + 1;
                    if phase_accumulator = "1111111111111111111111111" then
                        phase_accumulator <= (others => '0');
                    end if;
                end if;
            end if;
        end if;
    end process;

    sin_out <= sine_table when phase_accumulator(23 downto 12) >= sine_table else (others => '0');
    square_out <= '1' when phase_accumulator(23) = '1' else '0';

end Behavioral;
