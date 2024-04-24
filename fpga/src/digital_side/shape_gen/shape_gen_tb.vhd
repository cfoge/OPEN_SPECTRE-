
--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|                                               
-- Module Name: shape_gen_tb by RD Jordan
-- Created: Early 2023
-- Description: 
-- Dependencies: 
-- Additional Comments: You can view the project here: https://github.com/cfoge/OPEN_SPECTRE-
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity shape_gen_tb is
end shape_gen_tb;

architecture Behavioral of shape_gen_tb is

    component shape_gen is
        Port (
            clk          : in  std_logic;
            counter_x    : in  std_logic_vector(8 downto 0);
            counter_y    : in  std_logic_vector(8 downto 0);
            rst          : in  std_logic;
            pos_h        : in  std_logic_vector(8 downto 0);
            pos_v        : in  std_logic_vector(8 downto 0);
            zoom_h       : in  std_logic_vector(8 downto 0);
            zoom_v       : in  std_logic_vector(8 downto 0);
            circle_i     : in  std_logic_vector(8 downto 0);
            gear_i       : in  std_logic_vector(8 downto 0);
            lantern_i    : in  std_logic_vector(8 downto 0);
            fizz_i       : in  std_logic_vector(8 downto 0);
            shape_a      : out std_logic;
            shape_b      : out std_logic
        );
    end component shape_gen;

    signal clk_tb        : std_logic := '0';
    signal counter_x_tb  : std_logic_vector(8 downto 0) := (others => '0');
    signal counter_y_tb  : std_logic_vector(8 downto 0) := (others => '0');
    signal rst_tb        : std_logic := '0';
    signal pos_h_tb      : std_logic_vector(8 downto 0) := (others => '0');
    signal pos_v_tb      : std_logic_vector(8 downto 0) := (others => '0');
    signal zoom_h_tb     : std_logic_vector(8 downto 0) := (others => '0');
    signal zoom_v_tb     : std_logic_vector(8 downto 0) := (others => '0');
    signal circle_i_tb   : std_logic_vector(8 downto 0) := (others => '0');
    signal gear_i_tb     : std_logic_vector(8 downto 0) := (others => '0');
    signal lantern_i_tb  : std_logic_vector(8 downto 0) := (others => '0');
    signal fizz_i_tb     : std_logic_vector(8 downto 0) := (others => '0');
    signal shape_a_tb    : std_logic;
    signal shape_b_tb    : std_logic;

begin

    uut: shape_gen
        port map (
            clk          => clk_tb,
            counter_x    => counter_x_tb,
            counter_y    => counter_y_tb,
            rst          => rst_tb,
            pos_h        => pos_h_tb,
            pos_v        => pos_v_tb,
            zoom_h       => zoom_h_tb,
            zoom_v       => zoom_v_tb,
            circle_i     => circle_i_tb,
            gear_i       => gear_i_tb,
            lantern_i    => lantern_i_tb,
            fizz_i       => fizz_i_tb,
            shape_a      => shape_a_tb,
            shape_b      => shape_b_tb
        );

    clk_process: process
    begin
        while true loop
            clk_tb <= '0';
            wait for 5 ns;
            clk_tb <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process clk_process;

    stimulus_process: process
    begin
    
    zoom_h_tb <= "111111111";    
    zoom_v_tb <=  "111111111";  
    circle_i_tb <= "110000000";
    
    
        rst_tb <= '1';
        wait for 10 ns;
        rst_tb <= '0';

        while true loop
            -- Increment counter_x and counter_y by 1
            counter_x_tb <= std_logic_vector(unsigned(counter_x_tb) + 1);
            wait for 10 ns;
        end loop;
        

    end process stimulus_process;

process
begin
            while true loop
            -- Increment counter_x and counter_y by 1
            counter_y_tb <= std_logic_vector(unsigned(counter_y_tb) + 1);
            wait for 100 ns;
        end loop;
end process;
    -- Add assertions or other analysis processes if needed

end Behavioral;
