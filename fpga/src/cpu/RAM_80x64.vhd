library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RAM_80x64 is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           write_enable : in STD_LOGIC;
           address : in STD_LOGIC_VECTOR(7 downto 0);
           data_in : in STD_LOGIC_VECTOR(63 downto 0);
           data_out : out STD_LOGIC_VECTOR(63 downto 0));
end RAM_80x64;

architecture Behavioral of RAM_80x64 is -- its actualy 128 deep
    type ram_type is array (0 to 127) of STD_LOGIC_VECTOR(63 downto 0);
    signal ram : ram_type := (others => (others => '0'));
begin
    process (clk, reset)
    begin
        if reset = '1' then
            -- Reset the RAM contents
            ram <= (others => (others => '0'));
        elsif rising_edge(clk) then
            -- Write operation
            if write_enable = '1' then
                ram(conv_integer(address)) <= data_in;
            end if;
            -- Read operation
            data_out <= ram(conv_integer(address));
        end if;
    end process;
end Behavioral;
