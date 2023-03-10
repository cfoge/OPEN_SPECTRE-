library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity D_flipflop_ext is
    Port ( D : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           clear : in  STD_LOGIC;
           preset : in  STD_LOGIC;
           Q : out  STD_LOGIC;
           Q_not : out  STD_LOGIC);
end D_flipflop_ext;

architecture Behavioral of D_flipflop_ext is
begin
    process (clk) begin
        if (clk'event and clk = '1') then
            if (clear = '1') then
                Q <= '0';
            elsif (preset = '1') then
                Q <= '1';
            else
                Q <= D;
            end if;
        end if;
    end process;
    Q_not <= not Q;
end Behavioral;
