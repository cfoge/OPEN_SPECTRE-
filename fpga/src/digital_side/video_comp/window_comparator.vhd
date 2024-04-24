library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity window_comparator is
    Port ( input : in  STD_LOGIC_VECTOR(7 downto 0);
           lower : in  STD_LOGIC_VECTOR(7 downto 0);
           upper : in  STD_LOGIC_VECTOR(7 downto 0);
           output : out  STD_LOGIC);
end window_comparator;

architecture Behavioral of window_comparator is
begin
  output <= '0' when (input < lower) or (input > upper) else '1';
end Behavioral;
