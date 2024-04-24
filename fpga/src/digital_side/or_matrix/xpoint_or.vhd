----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.09.2023 09:43:23
-- Design Name: 
-- Module Name: xpoint_or - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_misc.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity xpoint_or is
    Port ( input : in STD_LOGIC_VECTOR (63 downto 0);
           mask : in STD_LOGIC_VECTOR (63 downto 0);
           output : out STD_LOGIC);
end xpoint_or;

architecture Behavioral of xpoint_or is
    
    signal internal_bus : std_logic_vector (63 downto 0) := (others => '0');
    
begin
    internal_bus <= input and mask;
    
    process(input,mask)
    begin
        if or_reduce(mask) = '0' then --pullup behavior
            output <= '1';
        else
            output <= or_reduce(internal_bus);
        end if;
    end process;
    
 

end Behavioral;