-- 9-bit counter with reset

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter is
    generic (
        width: integer := 9  -- width of the counter
    );
    port (
        clk: in std_logic;       -- clock input
        rst: in std_logic;       -- reset input
        enable: in std_logic;    -- enable input
        count: out std_logic_vector(width-1 downto 0)  -- count output
    );
end entity;

architecture behavioral of counter is
    signal count_int: unsigned(width-1 downto 0);  -- internal count
begin
    process(clk, rst)  -- sensitivity list
    begin
        if rst = '1' then
            count_int <= (others => '0');
        elsif clk'event and clk = '1' then
            if enable = '1' then
                count_int <= count_int + 1;
            end if;
        end if;
    end process;
    count <= std_logic_vector(count_int);
end architecture;
