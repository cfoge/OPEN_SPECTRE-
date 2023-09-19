
--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|                                               
-- Module Name: shapes_pulse_gen by RD Jordan
-- Created: Early 2023
-- Description: 
-- Dependencies: 
-- Additional Comments: You can view the project here: https://github.com/cfoge/OPEN_SPECTRE-
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shapes_pulse_gen is
    port (
        clk          : in  std_logic;
        rst          : in  std_logic;
        counter_in   : in  std_logic_vector(8 downto 0);
        pulse_start  : in  std_logic_vector(8 downto 0);
        pulse_len    : in  std_logic_vector(8 downto 0);
        zoom         : in  std_logic_vector(8 downto 0);
        pulse_out    : out std_logic;
        ramp_out     : out std_logic_vector(8 downto 0);
        parab_out    : out std_logic_vector(8 downto 0);
        reset_ramp   : out std_logic_vector(8 downto 0);
        noise_out    : out std_logic_vector(8 downto 0)
    );
end entity shapes_pulse_gen;

architecture Behavioral of shapes_pulse_gen is
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
    signal rst_ramp_mux           : std_logic_vector(8 downto 0);
    constant parab_max : unsigned(8 downto 0) := "100000000";  -- 512 in binary


begin
    process (clk, rst) -- pulse out, ramp out and parabala logic ------- 
    begin
    reset_ramp_zoom <= '0' & zoom(7 downto 0);
        if rst = '1' then
            counter <= (others => '0');
            pulse_counter <= (others => '0');
            pulse_active <= '0';
            ramp <= (others => '0');
            parab <= (others => '1');
        elsif rising_edge(clk) then
            counter <= unsigned(counter_in);
            counter_d <= counter;
            
            if counter_d /= counter then
                    ramp_tick <= '1';
                    else
                    ramp_tick <= '0';
                    end if;
            
            
            if pulse_active = '1' then
                if counter_d /= counter then
                    if pulse_counter = unsigned(pulse_len) then
                        pulse_active <= '0';
                        
                        pulse_counter <= (others => '0');
                        ramp <= (others => '0');
                        parab <= (others => '1');
                    else
                        pulse_counter <= pulse_counter + 1;
                      
                        ramp <= ramp + step_size;
                        if pulse_counter > shift_right(unsigned(pulse_len), 1) then
                            parab_up <= TRUE;  
                        end if;
                        if parab_up = TRUE then
                            parab <= parab + parab_size;  
                        else
                            if parab_size > parab then             
                                    parab <= (others => '0');  
                                else
                                    parab <= parab - parab_size;  
                                end if;
                        end if;
                   
                      
      
                    end if;
                    
                end if;
            elsif counter = unsigned(pulse_start) then
                pulse_active <= '1';
                parab_up <= FALSE;
                step_size <= step_size_calc;
                parab_size <= shift_left(to_unsigned(step_size_calc, 9), 1); --step size X2 to make the parabola
                pulse_counter <= (others => '0');
                ramp <= (others => '0');
                parab <= (others => '1');
            end if;
        end if;
    end process;
    
    process (pulse_len_int)
    begin
          if pulse_len_int = 0 then 
        
            step_size_calc <= 511;
        else
            step_size_calc <= TO_INTEGER(parab_max / pulse_len_int);
        end if;
        
       -- end if; 
    end process;
    
--    process (clk, rst) -- random reset ramp logic, counts up till zoom value then uses mux to jump up and rand oddly, needs beter method
--    -- need to jus tuse a ramp get osc reset by the pulse active at 0 and the freq controlled by zoom
    
--    begin
--        if pulse_active = '0' then
--          ramp_rst <= '1';
--        elsif rising_edge(clk) then       
--            if(pulse_counter mod unsigned(zoom) = 0 ) then
--                ramp_rst <= '1';
                
            
--            elsif (pulse_counter > unsigned(zoom) ) then
--                ramp_rst <= '0';
--                rst_ramp_mux <= rst_ramp_out(4 downto 0) & "0000" ;            
--                else
--                ramp_rst <= '0';
--                rst_ramp_mux <= rst_ramp_out(4 downto 0) & "0000" ;
--            end if;
--        end if;
        
--    end process;
    
    -- NOISE GENERATOR
    noise_gen : entity work.rand_num
        generic map (
            N => 8
        )
            port map (
            clk => clk,
            reset => rst,
            q => noise_out
        );
    -- Random reset ramp * is it actual random?
        rst_ramp: entity work.nco
        port map (
            i_clk => ramp_tick, -- need to slow down more maybe devide counter change by 2 or 4
            i_rstb => rst,
            i_sync_reset =>  pulse_active,
            i_fcw => reset_ramp_zoom,
            o_nco => rst_ramp_out
        );

    pulse_len_int <= unsigned(pulse_len);
    pulse_out <= pulse_active;
    ramp_out <= std_logic_vector(ramp);
    parab_out <= std_logic_vector(parab);
    reset_ramp <= '0' & rst_ramp_out(8 downto 1);

end architecture Behavioral;

