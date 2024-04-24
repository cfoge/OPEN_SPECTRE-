--a spimplified version of the EMS FF


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity D_flipflop_ext is
    Port ( clk : in STD_LOGIC;
           trig : in STD_LOGIC;
           rst : in STD_LOGIC;
           ff_out : out STD_LOGIC);
end D_flipflop_ext;

architecture Behavioral of D_flipflop_ext is

signal ff_state_int : std_logic := '0';
signal trig_d : std_logic := '0';

begin

process(clk)
    begin
    if (rising_edge(clk)) then
        if (rst = '1') then
            ff_state_int <= '0';
        else
        trig_d <= trig;
            if trig_d = '0' and trig = '1' then
                ff_state_int <= NOT ff_state_int;
            end if;
        end if;
    end if;
end process;

ff_out <= ff_state_int;
end Behavioral;