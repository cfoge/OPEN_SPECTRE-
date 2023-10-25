--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|                                               
-- Module Name: AudioMixer by RD Jordan
-- Created: Early 2023
-- Description: 
-- Dependencies: 
-- Additional Comments: You can view the project here: https://github.com/cfoge/OPEN_SPECTRE-
-- mixer to use as each colum in the analoge matrix
-- needs

-- library ieee;
-- use ieee.std_logic_1164.all;
-- use ieee.std_logic_arith.all;

-- package array_pck is

--   type array_int is array (natural range <>) of integer;

--   type array_2    is array (natural range <>) of std_logic_vector(  2-1 downto 0);
--   type array_3    is array (natural range <>) of std_logic_vector(  3-1 downto 0);
--   type array_4    is array (natural range <>) of std_logic_vector(  4-1 downto 0);
--   type array_5    is array (natural range <>) of std_logic_vector(  5-1 downto 0);
--   type array_6    is array (natural range <>) of std_logic_vector(  6-1 downto 0);
--   type array_7    is array (natural range <>) of std_logic_vector(  7-1 downto 0);
--   type array_8    is array (natural range <>) of std_logic_vector(  8-1 downto 0);
--   type array_11    is array (natural range <>) of std_logic_vector(  11-1 downto 0);
--   type array_12    is array (natural range <>) of std_logic_vector(  12-1 downto 0);

-- end array_pck;

-- package body array_pck is

-- end package body array_pck;
library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.numeric_std.all;
library work;
use work.array_pck.all;

entity AudioMixer is
  generic
  (
    NO_DSP : boolean := TRUE
  );
  port
  (
    clk    : in std_logic;
    reset  : in std_logic;
    inputs : in array_12(10 downto 0); -- 12-bit wide inputs
    gains  : in array_5(10 downto 0); -- 5-bit gain control for each input 32 levels
    output : out std_logic_vector(11 downto 0) -- 12-bit wide output
  );
end AudioMixer;

architecture Behavioral of AudioMixer is
  signal accumulator    : unsigned(16 downto 0) := (others => '0');
  signal accumulator_2  : unsigned(16 downto 0) := (others => '0');
  signal clamped_output : unsigned(11 downto 0);

  signal mask_0                                       : std_logic_vector(16 downto 0) := (others => '0');
  signal inputs_0                                     : std_logic_vector(16 downto 0) := (others => '0');
  signal mask_1                                       : std_logic_vector(16 downto 0) := (others => '0');
  signal inputs_1                                     : std_logic_vector(16 downto 0) := (others => '0');
  signal mask_2                                       : std_logic_vector(16 downto 0) := (others => '0');
  signal inputs_2                                     : std_logic_vector(16 downto 0) := (others => '0');
  signal mask_3                                       : std_logic_vector(16 downto 0) := (others => '0');
  signal inputs_3                                     : std_logic_vector(16 downto 0) := (others => '0');
  signal mask_4                                       : std_logic_vector(16 downto 0) := (others => '0');
  signal inputs_4                                     : std_logic_vector(16 downto 0) := (others => '0');
  signal mask_5                                       : std_logic_vector(16 downto 0) := (others => '0');
  signal inputs_5                                     : std_logic_vector(16 downto 0) := (others => '0');
  signal mask_6                                       : std_logic_vector(16 downto 0) := (others => '0');
  signal inputs_6                                     : std_logic_vector(16 downto 0) := (others => '0');
  signal mask_7                                       : std_logic_vector(16 downto 0) := (others => '0');
  signal inputs_7                                     : std_logic_vector(16 downto 0) := (others => '0');
  signal mask_8                                       : std_logic_vector(16 downto 0) := (others => '0');
  signal inputs_8                                     : std_logic_vector(16 downto 0) := (others => '0');
  signal mask_9                                       : std_logic_vector(16 downto 0) := (others => '0');
  signal inputs_9                                     : std_logic_vector(16 downto 0) := (others => '0');
  signal mask_10                                      : std_logic_vector(16 downto 0) := (others => '0');
  signal inputs_10                                    : std_logic_vector(16 downto 0) := (others => '0');


  function concatenate_signal12(signal_to_concatenate : std_logic) return std_logic_vector is
    variable result                                     : std_logic_vector(16 downto 0);
  begin
    result := (others => '0');
    for i in result'range loop
      result(i) := signal_to_concatenate;
    end loop;
    return result;
  end function;

begin
  GEN_DSP_MIX : if NO_DSP = FALSE generate

    process (clk)
    begin
      if rising_edge(clk) then
        if reset = '1' then
          accumulator <= (others => '0');
        else
          accumulator <= (unsigned(inputs(0)) * unsigned(gains(0))) +
            (unsigned(inputs(1)) * unsigned(gains(1))) +
            (unsigned(inputs(2)) * unsigned(gains(2))) +
            (unsigned(inputs(3)) * unsigned(gains(3))) +
            (unsigned(inputs(4)) * unsigned(gains(4))) +
            (unsigned(inputs(5)) * unsigned(gains(5))) +
            (unsigned(inputs(6)) * unsigned(gains(6))) +
            (unsigned(inputs(7)) * unsigned(gains(7))) +
            (unsigned(inputs(8)) * unsigned(gains(8))) +
            (unsigned(inputs(9)) * unsigned(gains(9))) +
            (unsigned(inputs(10)) * unsigned(gains(10)))

            ;
          accumulator_2 <= accumulator / 32;

        end if;

        -- Clamp the output to prevent overflows and underflows
        if accumulator_2 > 4094 then -- Maximum value for 12-bit unsigned
          clamped_output <= (others => '1');
          --                elsif accumulator_2 < 1 then  -- Minimum value for 12-bit signed
          --                    clamped_output <= (others => '0');
        else
          clamped_output <= accumulator_2(11 downto 0);
        end if;
      end if;

    end process;
  end generate GEN_DSP_MIX;
  GEN_NO_DSP : if NO_DSP = TRUE generate -- creates a masking element insted of a mix element, should eleminate DSP useage for low dsp devices/ untill we get dsp pipelining wokring.
  begin
    inputs_0 <= ("00000" & inputs(0));
    mask_0   <= concatenate_signal12(gains(0)(0));
    inputs_1 <= ("00000" & inputs(1));
    mask_1   <= concatenate_signal12(gains(1)(0));
    inputs_2 <= ("00000" & inputs(2));
    mask_2   <= concatenate_signal12(gains(2)(0));

    inputs_3 <= ("00000" & inputs(3));
    mask_3   <= concatenate_signal12(gains(3)(0));
    inputs_4 <= ("00000" & inputs(4));
    mask_4   <= concatenate_signal12(gains(4)(0));
    inputs_5 <= ("00000" & inputs(5));
    mask_5   <= concatenate_signal12(gains(5)(0));

    inputs_6 <= ("00000" & inputs(6));
    mask_6   <= concatenate_signal12(gains(6)(0));
    inputs_7 <= ("00000" & inputs(7));
    mask_7   <= concatenate_signal12(gains(7)(0));
    inputs_8 <= ("00000" & inputs(8));
    mask_8   <= concatenate_signal12(gains(8)(0));

    inputs_9 <= ("00000" & inputs(9));
    mask_9   <= concatenate_signal12(gains(9)(0));
    inputs_10 <= ("00000" & inputs(10));
    mask_10   <= concatenate_signal12(gains(10)(0));

    process (clk)
    begin
      if rising_edge(clk) then
        if reset = '1' then
          accumulator <= (others => '0');
        else

          accumulator <= 
            unsigned(inputs_0 and  mask_0) +
            unsigned(inputs_1 and  mask_1) +
            unsigned(inputs_2 and  mask_2) +
            unsigned(inputs_3 and  mask_3) +
            unsigned(inputs_4 and  mask_4) +
            unsigned(inputs_5 and  mask_5) +
            unsigned(inputs_6 and  mask_6) +
            unsigned(inputs_7 and  mask_7) +
            unsigned(inputs_8 and  mask_8) +
            unsigned(inputs_9 and  mask_9) +
            unsigned(inputs_10 and mask_10) 
            ;

          accumulator_2 <= accumulator;

        end if;

        -- Clamp the output to prevent overflows and underflows
        if accumulator_2 > 4094 then -- Maximum value for 12-bit unsigned
          clamped_output <= (others => '1');
          --                elsif accumulator_2 < 1 then  -- Minimum value for 12-bit signed
          --                    clamped_output <= (others => '0');
        else
          clamped_output <= accumulator_2(11 downto 0);
        end if;
      end if;

    end process;
  end generate GEN_NO_DSP;
  output <= std_logic_vector(clamped_output);
end Behavioral;