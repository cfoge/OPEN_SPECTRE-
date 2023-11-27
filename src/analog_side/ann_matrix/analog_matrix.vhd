
--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|                                               
-- Module Name: analog_matrix by RD Jordan
-- Created: Early 2023
-- Description: 
-- Dependencies: 
-- Additional Comments: You can view the project here: https://github.com/cfoge/OPEN_SPECTRE-
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;
library work;
use work.array_pck.all;

entity analog_matrix is
    Port (
         clk : in STD_LOGIC;
         reset : in STD_LOGIC;
         mixer_inputs : in array_12(10 downto 0);
         mixer_gains_0 : in array_5(10 downto 0);
         mixer_gains_1 : in array_5(10 downto 0);
         mixer_gains_2 : in array_5(10 downto 0);
         mixer_gains_3 : in array_5(10 downto 0);
         mixer_gains_4 : in array_5(10 downto 0);
         mixer_gains_5 : in array_5(10 downto 0);
         mixer_gains_6 : in array_5(10 downto 0);
         mixer_gains_7 : in array_5(10 downto 0);
         mixer_gains_8 : in array_5(10 downto 0);
         mixer_gains_9 : in array_5(10 downto 0);
         mixer_gains_10 : in array_5(10 downto 0);
         mixer_gains_11 : in array_5(10 downto 0);
         mixer_gains_12 : in array_5(10 downto 0);
         mixer_gains_13 : in array_5(10 downto 0);
         mixer_gains_14 : in array_5(10 downto 0);
         mixer_gains_15 : in array_5(10 downto 0);
         mixer_gains_16 : in array_5(10 downto 0);
         mixer_gains_17 : in array_5(10 downto 0);
         mixer_gains_18 : in array_5(10 downto 0);
         mixer_gains_19 : in array_5(10 downto 0);
        outputs : out array_12(19 downto 0)  
    );
end analog_matrix;

architecture Behavioral of analog_matrix is
    component AudioMixer
        Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            inputs : in array_12(10 downto 0);
            gains : in array_5(10 downto 0);
            output : out STD_LOGIC_VECTOR(11 downto 0)
        );
    end component;


begin
    -- Instantiate 10 instances of the AudioMixer module
    Mixer0: AudioMixer port map (
        clk => clk,
        reset => reset,
        inputs => mixer_inputs,
        gains => mixer_gains_0,
        output => outputs(0)
    );
    
    Mixer1: AudioMixer port map (
        clk => clk,
        reset => reset,
        inputs => mixer_inputs,
        gains => mixer_gains_1,
        output => outputs(1)
    );
    
    Mixer2: AudioMixer port map (
        clk => clk,
        reset => reset,
        inputs => mixer_inputs,
        gains => mixer_gains_2,
        output => outputs(2)
    );
    
    Mixer3: AudioMixer port map (
        clk => clk,
        reset => reset,
        inputs => mixer_inputs,
        gains => mixer_gains_3,
        output => outputs(3)
    );
    
    Mixer4: AudioMixer port map (
        clk => clk,
        reset => reset,
        inputs => mixer_inputs,
        gains => mixer_gains_4,
        output => outputs(4)
    );
    
    Mixer5: AudioMixer port map (
        clk => clk,
        reset => reset,
        inputs => mixer_inputs,
        gains => mixer_gains_5,
        output => outputs(5)
    );
    
    Mixer6: AudioMixer port map (
        clk => clk,
        reset => reset,
        inputs => mixer_inputs,
        gains => mixer_gains_6,
        output => outputs(6)
    );
    
    Mixer7: AudioMixer port map (
        clk => clk,
        reset => reset,
        inputs => mixer_inputs,
        gains => mixer_gains_7,
        output => outputs(7)
    );
    
    Mixer8: AudioMixer port map (
        clk => clk,
        reset => reset,
        inputs => mixer_inputs,
        gains => mixer_gains_8,
        output => outputs(8)
    );
    
    Mixer9: AudioMixer port map (
        clk => clk,
        reset => reset,
        inputs => mixer_inputs,
        gains => mixer_gains_9,
        output => outputs(9)
    );

    Mixer10: AudioMixer port map (
        clk => clk,
        reset => reset,
        inputs => mixer_inputs,
        gains => mixer_gains_10,
        output => outputs(10)
    );

    Mixer11: AudioMixer port map (
        clk => clk,
        reset => reset,
        inputs => mixer_inputs,
        gains => mixer_gains_11,
        output => outputs(11)
    );

    Mixer12: AudioMixer port map (
        clk => clk,
        reset => reset,
        inputs => mixer_inputs,
        gains => mixer_gains_12,
        output => outputs(12)
    );

    Mixer13: AudioMixer port map (
        clk => clk,
        reset => reset,
        inputs => mixer_inputs,
        gains => mixer_gains_13,
        output => outputs(13)
    );

    Mixer14: AudioMixer port map (
        clk => clk,
        reset => reset,
        inputs => mixer_inputs,
        gains => mixer_gains_14,
        output => outputs(14)
    );

    Mixer15: AudioMixer port map (
        clk => clk,
        reset => reset,
        inputs => mixer_inputs,
        gains => mixer_gains_15,
        output => outputs(15)
    );



    Mixer16: AudioMixer port map (
        clk => clk,
        reset => reset,
        inputs => mixer_inputs,
        gains => mixer_gains_16,
        output => outputs(16)
    );


    Mixer17: AudioMixer port map (
        clk => clk,
        reset => reset,
        inputs => mixer_inputs,
        gains => mixer_gains_17,
        output => outputs(17)
    );


    Mixer18: AudioMixer port map (
        clk => clk,
        reset => reset,
        inputs => mixer_inputs,
        gains => mixer_gains_18,
        output => outputs(18)
    );


    Mixer19: AudioMixer port map (
        clk => clk,
        reset => reset,
        inputs => mixer_inputs,
        gains => mixer_gains_19,
        output => outputs(19)
    );






end Behavioral;
