
--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|                                               
-- Module Name: shapes_pulse_gen_x by RD Jordan
-- Created: Early 2023
-- Description: 
-- Dependencies: 
-- Additional Comments: You can view the project here: https://github.com/cfoge/OPEN_SPECTRE-
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shapes_pulse_gen_x is
    port (
        clk          : in  std_logic;
        rst          : in  std_logic;
        sync_rst_i          : in  std_logic;
        counter_in   : in  std_logic_vector(8 downto 0);
        pulse_start  : in  std_logic_vector(8 downto 0);
        pulse_len    : in  std_logic_vector(8 downto 0);
        zoom         : in  std_logic_vector(8 downto 0);
        pulse_out    : out std_logic;
        i_preload     : in  std_logic_vector(8 downto 0); -- New preload input
        ramp_out     : out std_logic_vector(8 downto 0);
        parab_out    : out std_logic_vector(8 downto 0);
        reset_ramp   : out std_logic_vector(8 downto 0);
        noise_out    : out std_logic_vector(8 downto 0)
    );
end entity shapes_pulse_gen_x;

architecture Behavioral of shapes_pulse_gen_x is
    signal counter        : unsigned(8 downto 0);
    signal counter_d        : unsigned(8 downto 0);

    signal step_size_calc : integer range 0 to 512; 
    signal step_size      : integer range 0 to 512; 
    signal parab_size     : unsigned(8 downto 0); 
    signal pulse_counter  : unsigned(8 downto 0);
    signal pulse_len_int  : unsigned(8 downto 0);
    signal pulse_active   : std_logic;
    signal ramp           : unsigned(8 downto 0);
    signal parab           : unsigned(8 downto 0);
    signal parab_up    :boolean ;
    signal ramp_rst   : std_logic;
    signal ramp_tick   : std_logic;


    
    signal reset_ramp_zoom     : std_logic_vector(8 downto 0); 

    signal rst_ramp_out           : std_logic_vector(8 downto 0);

    signal noise_i                : std_logic_vector(8 downto 0);
    

begin
    reset_ramp_zoom <=  zoom(8 downto 0);-- & '0';

 

    
    -- NOISE GENERATOR
    noise_gen : entity work.rand_num
        generic map (
            N => 8
        )
            port map (
            clk => clk,
            reset => rst,
            q => noise_i
        );

        rst_ramp: entity work.nco
        port map (
            i_clk => clk, -- need to slow down more maybe devide counter change by 2 or 4
            i_rstb => rst,
            i_preload => i_preload,
            i_sync_reset => sync_rst_i,
            i_fcw => reset_ramp_zoom,
            o_nco => rst_ramp_out
        );

    pulse_len_int <= unsigned(pulse_len);
    pulse_out <= pulse_active;
    ramp_out <= std_logic_vector(ramp);
    parab_out <= std_logic_vector(parab);
    reset_ramp <= '0' & rst_ramp_out(8 downto 1);
    noise_out <= noise_i(0) & noise_i(3) & noise_i(2 downto 1) & noise_i(8 downto 4);

end architecture Behavioral;

