----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.01.2023 15:21:44
-- Design Name: 
-- Module Name: pin_matrix_n - Behavioral
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
use IEEE.std_logic_misc.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pin_matrix_n is
generic (
    width : integer := 53
);
port
(
    Data_In  :in  std_logic_vector(width downto 0);
    en  :in  std_logic_vector(width downto 0);
    Data_out :out   std_logic 
    
);
end pin_matrix_n;

architecture Behavioral of pin_matrix_n is

begin
    Data_out <= or_reduce(Data_in and en);

end Behavioral;
