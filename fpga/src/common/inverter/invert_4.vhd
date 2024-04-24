
--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|                                               
-- Module Name: invert_4 by RD Jordan
-- Created: Early 2023
-- Description: 
-- Dependencies: 
-- Additional Comments: You can view the project here: https://github.com/cfoge/OPEN_SPECTRE-
----------------------------------------------------------------------------------
--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______
--                              |______|
--
-- Module Name: invert_4 - Behavioral
-- EMS SPECTRE Function Name: Common Component
-- Creator: <your name>
-- Name of component in Schematics (if named): n/a
-- PG Number from Schematics:     -> https://github.com/cfoge/OPEN_SPECTRE-/blob/main/Spectron%20Resources/Technical/Circuits.pdf
-- Description Of Function:
--
-- Dependencies:
--
-- Additional Comments:
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity invert_4 is
    Port ( input : in STD_LOGIC_VECTOR (3 downto 0);
           output : out STD_LOGIC_VECTOR (3 downto 0));
end invert_4;

architecture Behavioral of invert_4 is

begin
    output <= NOT input;

end Behavioral;
