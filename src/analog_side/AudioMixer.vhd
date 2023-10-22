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
begin
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

  output <= std_logic_vector(clamped_output);
end Behavioral;