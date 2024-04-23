library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Adder_Subtractor_12bit_OverflowProtection is
  Port ( 
    A : in STD_LOGIC_VECTOR(11 downto 0);
    B : in STD_LOGIC_VECTOR(11 downto 0);
    Mode : in STD_LOGIC;  -- Control signal for mode selection (0: addition, 1: subtraction)
    Result : out STD_LOGIC_VECTOR(11 downto 0);
    Overflow : out STD_LOGIC;
    Underflow : out STD_LOGIC
  );
end Adder_Subtractor_12bit_OverflowProtection;

architecture Behavioral of Adder_Subtractor_12bit_OverflowProtection is
  signal temp_result : STD_LOGIC_VECTOR(12 downto 0);
begin
  process (A, B, Mode)
  begin
    if Mode = '0' then  -- Addition mode
      temp_result <= ('0' & A) + ('0' & B);
    else  -- Subtraction mode
      temp_result <= ('0' & A) - ('0' & B);
    end if;
  end process;

  -- Check for overflow and underflow
  Overflow <= '1' when temp_result(12) = '1' else '0';
  Underflow <= '1' when temp_result(12) = '1' else '0';

  -- Assign the result with overflow/underflow protection
  process (temp_result, temp_result(12))
  begin
    if temp_result(12) = '1' then  -- Overflow or underflow occurred
      if Mode = '0' then  -- Addition mode
        Result <= (others => '1');  -- Set result to maximum value
      else  -- Subtraction mode
        Result <= (others => '0');  -- Set result to minimum value
      end if;
    else  -- No overflow or underflow
      Result <= temp_result(11 downto 0);  -- Assign the result
    end if;
  end process;
  
end Behavioral;
