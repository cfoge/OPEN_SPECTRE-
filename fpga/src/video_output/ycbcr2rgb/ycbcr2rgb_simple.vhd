----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.05.2023 16:15:50
-- Design Name: 
-- Module Name: ycrcr2rgb_simple - Behavioral
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

entity ycbcr2rgb_simple is
  Port ( 
        y  : in std_logic_vector(7 downto 0);
        cb : in std_logic_vector(7 downto 0);
        cr : in std_logic_vector(7 downto 0);
        r  : out std_logic_vector(7 downto 0);
        g  : out std_logic_vector(7 downto 0);
        b  : out std_logic_vector(7 downto 0)
  );
end ycbcr2rgb_simple;

architecture Behavioral of ycbcr2rgb_simple is

-- Scaled Coeff = Original Coeff * 256
constant R_COEFF  : signed(9 downto 0) := to_signed(359, 10); -- 359 = 1.402 * 256
constant G_COEFF1 : signed(7 downto 0) := to_signed(88, 8);   -- 88  = 0.344 * 256
constant G_COEFF2 : signed(8 downto 0) := to_signed(182,9);   -- 182 = 0.714 * 256
constant B_COEFF  : signed(9 downto 0) := to_signed(455, 10); -- 455 = 1.722 * 256

--                                        Range of values:
signal y_i     : signed(8 downto 0);  --      0 to 255
signal cr_i    : signed(7 downto 0);  --   -128 to 127
signal cb_i    : signed(7 downto 0);  --   -128 to 127
signal r_mult  : signed(16 downto 0); -- -45952 to 45593 
signal g_mult1 : signed(14 downto 0); -- -11264 to 11176
signal g_mult2 : signed(15 downto 0); -- -23296 to 23114
signal b_mult  : signed(16 downto 0); -- -58240 to 57785
signal r_i     : signed(9 downto 0);  --   -179 to 433
signal g_i     : signed(9 downto 0);  --   -133 to 390
signal b_i     : signed(9 downto 0);  --   -277 to 480

begin

-- Convert to signed
y_i  <= signed('0' & y);
cr_i <= resize(signed('0' & cr) - to_signed(128, 9), cr_i'length);
cb_i <= resize(signed('0' & cb) - to_signed(128, 9), cb_i'length);

r_mult <= resize(cr_i * R_COEFF, r_mult'length);
r_i    <= y_i + resize(shift_right(r_mult, 8), 10);

g_mult1 <= resize(cb_i * G_COEFF1, g_mult1'length); 
g_mult2 <= resize(cr_i * G_COEFF2, g_mult2'length); 
g_i     <= y_i - resize(shift_right((g_mult1 + g_mult2), 8), 10);

b_mult <= resize(cb_i * B_COEFF, b_mult'length);   
b_i    <= y_i + resize(shift_right(b_mult, 8), 10); 

-- Clamp in case of overflow + underflow
r <= (others => '1') when r_i > to_signed(255, 10) else
     (others => '0') when r_i < to_signed(0,   10) else
     std_logic_vector(r_i(7 downto 0));

g <= (others => '1') when g_i > to_signed(255, 10) else
     (others => '0') when g_i < to_signed(0,   10) else
     std_logic_vector(g_i(7 downto 0));

b <= (others => '1') when b_i > to_signed(255, 10) else
     (others => '0') when b_i < to_signed(0,   10) else
     std_logic_vector(b_i(7 downto 0)); 

end Behavioral;
