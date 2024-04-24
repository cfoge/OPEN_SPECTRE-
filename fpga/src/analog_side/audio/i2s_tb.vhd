
--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|                                               
-- Module Name: i2s_tb by RD Jordan
-- Created: Early 2023
-- Description: 
-- Dependencies: 
-- Additional Comments: You can view the project here: https://github.com/cfoge/OPEN_SPECTRE-
library ieee;
use ieee.std_logic_1164.all;

entity i2s_tb is
	generic ( DATA_WIDTH : integer := 24;
    		  BITPERFRAME : integer := 64);
end i2s_tb;

architecture behavioral of i2s_tb is
	signal clk_50 : std_logic;
    signal dac_d  : std_logic;
   	signal adc_d  : std_logic;
    signal bclk   : std_logic;
    signal lrclk  : std_logic;
    
    signal dstim  : std_logic_vector(63 downto 0) := x"aaaaeeeebbbb5555";
    
    signal sample : std_logic_vector(DATA_WIDTH - 1 downto 0) := x"fafafa";
    
   	constant period : time := 20 ns;
    constant bclk_period : time := 32552 ns / BITPERFRAME;

	signal zbclk, zzbclk, zzzbclk : std_logic;
    signal neg_edge, pos_edge : std_logic;
    
    signal wdth : integer := DATA_WIDTH;
    signal cnt : integer := 0;

	signal toggle : std_logic := '1';
    signal new_sample : std_logic := '0';
    
    signal sample_out : std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal valid : std_logic;
    
    signal ready : std_logic := '1';
    
    signal rst : std_logic := '0';
    
    component i2s_interface is
    	generic ( DATA_WIDTH : integer range 16 to 32;
        		  BITPERFRAME: integer );
		port (
    	clk 		: in std_logic;
        reset       : in std_logic;
        bclk 		: in std_logic;
        lrclk		: in std_logic;
        sample_out 	: out std_logic_vector(DATA_WIDTH - 1 downto 0);
        sample_in 	: in std_logic_vector(DATA_WIDTH - 1 downto 0);
        dac_data	: out std_logic;
        adc_data 	: in std_logic;
        valid 		: out std_logic;
        ready 		: out std_logic
        );
     end component;
begin
	-- Instantiate
    DUT : i2s_interface
    generic map ( DATA_WIDTH => DATA_WIDTH,
    			  BITPERFRAME => BITPERFRAME )
    port map (
    	clk => clk_50,
        reset => rst,
        bclk => bclk,
        lrclk => lrclk,
        sample_out => sample_out,
        sample_in => sample,
        dac_data => dac_d,
        adc_data => adc_d,
        valid => valid,
        ready => ready
        );
        
	clk_proc : process
    begin
    	clk_50 <= '0';
       	wait for period/2;
        clk_50 <= '1';
        wait for period/2;
    end process;
	
    -- lrclk <= lrstim(lrstim'high);
    
    i2s_bclk : process
    begin
    	bclk <= '0';
        -- lrstim <= lrstim(lrstim'high - 1 downto 0) & lrstim(lrstim'high);
        wait for bclk_period/2;
        -- lrstim <= lrstim(lrstim'high - 1 downto 0) & lrstim(lrstim'high);
        bclk <= '1';
        wait for bclk_period/2;
    end process;
    
	detect : process(clk_50)
    begin
    	if rising_edge(clk_50) then
    		zbclk <= bclk;
        	zzbclk <= zbclk;
        	zzzbclk <= zzbclk;
    		if zzbclk = '1' and zzzbclk = '0' then
        		neg_edge <= '1';
        	elsif zzbclk = '0' and zzzbclk = '1' then
        		pos_edge <= '1';
        	else
        		neg_edge <= '0';
        	    pos_edge <= '0';
        	end if;
        end if;
    end process;

	lrclk <= toggle;
	i2s_lrclk : process(bclk)
  	begin
    	if rising_edge(bclk) then
    		if cnt < BITPERFRAME/2 - 1 then
     			cnt <= cnt + 1;
            elsif cnt = BITPERFRAME/2 - 1 then
        		cnt <= 0;				      
            end if;
        end if;
        if falling_edge(bclk) then
        	if cnt >= BITPERFRAME/2 - 1 then
            	toggle <= not toggle;
            else
            	if cnt = 0 then
            		new_sample <= '1';
       			elsif cnt >= wdth then
                	new_sample <= '0';
                end if;
            end if;
       	end if;
   	end process;

	adc_d <= dstim(dstim'high);
    i2s_data : process(bclk)
	begin
		if falling_edge(bclk) then
        	if new_sample = '1' then
        		dstim <= dstim(dstim'high - 1 downto 0) & dstim(dstim'high);
            end if;
        end if;
        if rising_edge(clk_50) then
        	if ready = '1' then
            	sample <= dstim(dstim'high downto dstim'high - DATA_WIDTH + 1);
            else
            	sample <= (others => '0');
            end if;
        end if;
    end process;
       
end behavioral;
