
--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|                                               
-- Module Name: nand4 by RD Jordan
-- Created: Early 2023
-- Description: 
-- Dependencies: 
-- Additional Comments: You can view the project here: https://github.com/cfoge/OPEN_SPECTRE-
-- 4 parallel NAND gates, each with the second input inverted 
--OVERLAY GATES

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity nand4 is
    port (
        -- inputs
        a: in std_logic_vector(3 downto 0);  -- first inputs
        b: in std_logic_vector(3 downto 0);  -- second inputs

        -- outputs
        y: out std_logic_vector(3 downto 0)  -- outputs
    );
end entity;

architecture behavioral of nand4 is
begin
    -- implement the NAND gates
    y(0) <= not (a(0) and not b(0));
    y(1) <= not (a(1) and not b(1));
    y(2) <= not (a(2) and not b(2));
    y(3) <= not (a(3) and not b(3));
end architecture;
