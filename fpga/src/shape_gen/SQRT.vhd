
--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|                                               
-- Module Name: SQRT by RD Jordan
-- Created: Early 2023
-- Description: 
-- Dependencies: 
-- Additional Comments: You can view the project here: https://github.com/cfoge/OPEN_SPECTRE-
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SQRT is
    Generic ( b  : natural range 4 to 32 := 19 ); 
    Port ( value  : in   STD_LOGIC_VECTOR (18 downto 0);
           result : out  STD_LOGIC_VECTOR (18 downto 0));
end SQRT;

architecture Behave of SQRT is
begin
   process (value)
   variable vop  : unsigned(b-1 downto 0);  
   variable vres : unsigned(b-1 downto 0);  
   variable vone : unsigned(b-1 downto 0);  
   begin
      vone := to_unsigned(2**(b-2),b);
      vop  := unsigned(value);
      vres := (others=>'0'); 
      while (vone /= 0) loop
         if (vop >= vres+vone) then
            vop   := vop - (vres+vone);
            vres  := vres/2 + vone;
         else
            vres  := vres/2;
         end if;
         vone := vone/4;
      end loop;
      result <= std_logic_vector(vres(result'range));
   end process;
end;


--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

--entity SQRT is
--    Generic ( b  : natural range 4 to 32 := 16 ); 
--    Port ( value  : in   STD_LOGIC_VECTOR (15 downto 0);
--           result : out  STD_LOGIC_VECTOR (7 downto 0));
--end SQRT;

--architecture Behave of SQRT is
--begin
--   process (value)
--   variable vop  : unsigned(b-1 downto 0);  
--   variable vres : unsigned(b-1 downto 0);  
--   variable vone : unsigned(b-1 downto 0);  
--   begin
--      vone := to_unsigned(2**(b-2),b);
--      vop  := unsigned(value);
--      vres := (others=>'0'); 
--      while (vone /= 0) loop
--         if (vop >= vres+vone) then
--            vop   := vop - (vres+vone);
--            vres  := vres/2 + vone;
--         else
--            vres  := vres/2;
--         end if;
--         vone := vone/4;
--      end loop;
--      result <= std_logic_vector(vres(result'range));
--   end process;
--end;