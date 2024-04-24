
--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|                                               
-- Module Name: rand_num by RD Jordan
-- Created: Early 2023
-- Description: 
-- Dependencies: 
-- Additional Comments: You can view the project here: https://github.com/cfoge/OPEN_SPECTRE-
-- rand_num_generator.vhd

-- created by   :   Meher Krishna Patel
-- date                 :   22-Dec-16

-- Feedback polynomial : x^3 + x^2 + 1 
-- maximum length : 2^3 - 1 = 7

-- if generic value is changed,
-- then choose the correct Feedback polynomial i.e. change 'feedback_value' pattern
    
library ieee;
use ieee.std_logic_1164.all;

entity rand_num is
    generic (N :integer := 3);
    port(
        clk, reset  : in std_logic;
        q : out std_logic_vector(N downto 0) -- output of LFSR i.e. random number
    );
end rand_num;

architecture arch of rand_num is
    signal r_reg, r_next : std_logic_vector(N downto 0);
    signal feedback_value : std_logic;  -- based on feedback polynomial
begin
    process(clk, reset)
    begin
        if(reset='1') then
            -- set initial value to '1'. 
            r_reg(0) <= '1'; -- 0th bit = 1
            r_reg(N downto 1) <= (others=>'0'); -- other bits are 0         
        elsif (clk'event and clk='1') then
            r_reg <= r_next; -- otherwise save the next state
        end if;
    end process;
    
    -- N = 3
    -- Feedback polynomial : x^3 + x^2 + 1 
    -- total sequences (maximum) : 2^3 - 1 = 7
    feedback_value <= r_reg(3) xor r_reg(2) xor r_reg(0);
    
    -- N = 4
    -- feedback_value <= r_reg(4) xor r_reg(3) xor r_reg(0);

    -- N = 5, maximum length = 28 (not 31)
    -- feedback_value <= r_reg(5) xor r_reg(3) xor r_reg(0);
    
    -- N = 9 
    -- feedback_value <= r_reg(9) xor r_reg(5) xor r_reg(0);
    
    r_next <= feedback_value & r_reg(N downto 1);
    q <= r_reg;
end arch;
