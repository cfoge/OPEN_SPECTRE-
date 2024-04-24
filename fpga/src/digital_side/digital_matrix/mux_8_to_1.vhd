library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_8_to_1 is
    Port ( 
        data: in  std_logic_vector(7 downto 0);
        sel: in  std_logic_vector(2 downto 0);
        mux_out: out  std_logic
    );
end mux_8_to_1;

architecture Behavioral of mux_8_to_1 is
begin
    process(sel, data)
    begin
        case sel is
            when "000" => mux_out <= data(0);
            when "001" => mux_out <= data(1);
            when "010" => mux_out <= data(2);
            when "011" => mux_out <= data(3);
            when "100" => mux_out <= data(4);
            when "101" => mux_out <= data(5);
            when "110" => mux_out <= data(6);
            when "111" => mux_out <= data(7);
            when others => mux_out <= '0';
        end case;
    end process;
end Behavioral;
