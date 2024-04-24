library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Adder_12bit_NoOverflow is
  Port ( 
    A : in STD_LOGIC_VECTOR(11 downto 0);
    B : in STD_LOGIC_VECTOR(11 downto 0);
    Sum : out STD_LOGIC_VECTOR(11 downto 0);
    Overflow : out STD_LOGIC
  );
end Adder_12bit_NoOverflow;

architecture Behavioral of Adder_12bit_NoOverflow is
  signal temp_sum : STD_LOGIC_VECTOR(12 downto 0);
begin
  -- Add the two input numbers
  temp_sum <= ('0' & A) + ('0' & B);

  -- Check for overflow
  Overflow <= '1' when temp_sum(12) = '1' else '0';

  -- Assign the result without overflow
  process (temp_sum, temp_sum(12)) begin
    if temp_sum(12) = '1' then
      Sum <= (others => '1');
    else
      Sum <= temp_sum(11 downto 0);
    end if;
  end process;
  
end Behavioral;
