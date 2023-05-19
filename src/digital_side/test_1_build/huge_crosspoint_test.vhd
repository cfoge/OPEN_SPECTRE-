----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.05.2023 15:32:50
-- Design Name: 
-- Module Name: huge_crospoint_test - Behavioral
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
use IEEE.math_real.all;
use ieee.numeric_std.all; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity huge_crospoint_test is
    Port ( matrix_in : in STD_LOGIC_VECTOR (64 downto 0);
            mux_sel_A : in STD_LOGIC_VECTOR (383 downto 0);
            mux_sel_B : in STD_LOGIC_VECTOR (383 downto 0);
            mux_sel_C : in STD_LOGIC_VECTOR (383 downto 0);
           matrix_out : out STD_LOGIC_VECTOR (64 downto 0));
end huge_crospoint_test;

architecture Behavioral of huge_crospoint_test is

 function mux_n (A,B: in std_logic_vector) return std_logic is
  begin
      return A(to_integer(unsigned(B)));
  end mux_n;
  
  function demux_n (B: in std_logic_vector) return std_logic_vector is --- NEED TO CHECK THIS DECODER!!!!
    variable  unshifted_val : std_logic_vector(2**to_integer(unsigned(B)) -1 downto 0) := (others => '0');
  begin
     unshifted_val := unshifted_val(2**to_integer(unsigned(B)) -1 downto 1) & '1'; --add a 1 at the end of the 000s
      for i in 0 to to_integer(unsigned(B)) loop                 --shifts left by the number 
        unshifted_val := unshifted_val(unshifted_val'left-1 downto 0) & '0';
      end loop;
      return unshifted_val; -- issue here
  end demux_n;
  
  signal matrix_out_A :  STD_LOGIC_VECTOR (64 downto 0);
  signal matrix_out_B :  STD_LOGIC_VECTOR (64 downto 0);
  signal matrix_out_C :  STD_LOGIC_VECTOR (64 downto 0);
  signal matrix_out_D :  STD_LOGIC_VECTOR (64 downto 0);

begin

 g_GENERATE_HUGE_MATRIX_A: for ii in 0 to 63 generate
    matrix_out_A(ii) <= mux_n(matrix_in, mux_sel_A((ii*6 + 5) downto ii*6));
  end generate g_GENERATE_HUGE_MATRIX_A;
  
 g_GENERATE_HUGE_MATRIX_B: for ii in 0 to 63 generate
    matrix_out_B(ii) <= mux_n(matrix_in, mux_sel_B((ii*6 + 5) downto ii*6));
  end generate g_GENERATE_HUGE_MATRIX_B;
  
 g_GENERATE_HUGE_MATRIX_C: for ii in 0 to 63 generate
    matrix_out_C(ii) <= mux_n(matrix_in, mux_sel_B((ii*6 + 5) downto ii*6));
  end generate g_GENERATE_HUGE_MATRIX_C;

  
matrix_out <= matrix_out_A or matrix_out_B or matrix_out_C;


end Behavioral;
