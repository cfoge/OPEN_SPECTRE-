
--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|                                               
-- Module Name: rot_enc by RD Jordan
-- Created: Early 2023
-- Description: 
-- Dependencies: 
-- Additional Comments: You can view the project here: https://github.com/cfoge/OPEN_SPECTRE-
-- Roter encoder
-- RDJ

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rot_enc is
    Port ( clk        : in  STD_LOGIC; -- Input clock
           enc_a      : in  STD_LOGIC; -- encoder pin A
           enc_b      : in  STD_LOGIC; -- encoder pin B
           count_en   : out  STD_LOGIC; -- encoder movement detected
           count_dir : out  STD_LOGIC); -- encoder dirtection 0 = up 1 = dewn
end rot_enc;

architecture Behavioral of rot_enc is
   signal enc_quad_sr : std_logic_vector(7 downto 0) := (others => '0'); -- shift reg for keeping incoming pulses 
   attribute keep : string;
   attribute keep of enc_quad_sr: signal is "true";  -- dont let synthisizer remove (dont know why it would but just to be sure)
begin
   
process(clk)
   begin
      if rising_edge(clk) then
         count_en  <= '0';
         count_dir <= '0';         
         case enc_quad_sr(5 downto 0) is
             when "010010" => count_en <= '1'; 
             when "001011" => count_en <= '1';
             when "101101" => count_en <= '1';
             when "110100" => count_en <= '1';
             when "100001" => count_en <= '1'; count_dir <= '1';
             when "000111" => count_en <= '1'; count_dir <= '1';
             when "011110" => count_en <= '1'; count_dir <= '1';
             when "111000" => count_en <= '1'; count_dir <= '1';
             when others => NULL;
         end case;
         -- Last two pairs in enc_quad_sr only shift when synchronised input has changed
         if enc_quad_sr(5 downto 4) /=  enc_quad_sr(3 downto 2) then 
            enc_quad_sr(3 downto 0) <= enc_quad_sr(5 downto 2);
         end if;
         -- First two pairs act as a synchroniser for the encoder
         enc_quad_sr(7 downto 4) <= enc_b & enc_a & enc_quad_sr(7 downto 6);            
      end if;
   end process;
end Behavioral;