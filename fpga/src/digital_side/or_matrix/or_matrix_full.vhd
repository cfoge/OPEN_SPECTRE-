----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.09.2023 09:51:42
-- Design Name: 
-- Module Name: or_matrix_full - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity or_matrix_full is
    Port ( input : in STD_LOGIC_VECTOR (63 downto 0);
           clk : in std_logic;
           mask : in STD_LOGIC_VECTOR (63 downto 0);
           mask_en : in std_logic;
           mask_addr : in STD_LOGIC_VECTOR (5 downto 0);
           output : out STD_LOGIC_VECTOR (63 downto 0));
end or_matrix_full;

architecture Behavioral of or_matrix_full is

    type out_mask is array (0 to 63) of std_logic_vector(63 downto 0);
    signal mat_mask : out_mask;
    signal mask_in_reg : std_logic_vector (63 downto 0) := (others => '0');
    signal mask_out_reg : std_logic_vector (63 downto 0) := (others => '0');

begin

  g_GENERATE_OR_MATRIX: for ii in 0 to 63 generate
    or_mattrix : entity work.xpoint_or
    Port map ( input => mask_in_reg,
           mask => mat_mask(ii),
           output => mask_out_reg(ii));
  end generate g_GENERATE_OR_MATRIX;
   
  process(clk)
  begin
    if rising_edge(clk) then
        mask_in_reg <= input;
        output <= mask_out_reg;
    
        if mask_en = '1' then
            mat_mask(to_integer(unsigned(mask_addr))) <= mask;
        end if;
    end if;
  end process;


end Behavioral;