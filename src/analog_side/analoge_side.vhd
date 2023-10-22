library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library work;
use work.array_pck.all;

entity analoge_side is
  Port ( 
    clk      : in  STD_LOGIC;
    rst      : in  STD_LOGIC;
    wr       : in  STD_LOGIC;
    out_addr : in  INTEGER;
    ch_addr  : in  INTEGER;
    gain_in  : in  STD_LOGIC_VECTOR(4 downto 0);
--    mixer_inputs : in  array_12(10 downto 0);
--    outputs : out  array_12(19 downto 0);
    
    counter_x   : in std_logic_vector(8 downto 0);
    counter_y   : in std_logic_vector(8 downto 0);

    shapegen1_pos_h   : in std_logic_vector(8 downto 0);
    shapegen1_pos_v   : in std_logic_vector(8 downto 0);
    shapegen1_zoom_h  : in std_logic_vector(8 downto 0);
    shapegen1_zoom_v  : in std_logic_vector(8 downto 0);
    shapegen1_circle_i  : in std_logic_vector(8 downto 0);
    shapegen1_gear_i    : in std_logic_vector(8 downto 0);
    shapegen1_lantern_i : in std_logic_vector(8 downto 0);
    shapegen1_fizz_i    : in std_logic_vector(8 downto 0);

    shapegen2_pos_h   : in std_logic_vector(8 downto 0);
    shapegen2_pos_v   : in std_logic_vector(8 downto 0);
    shapegen2_zoom_h  : in std_logic_vector(8 downto 0);
    shapegen2_zoom_v  : in std_logic_vector(8 downto 0);
    shapegen2_circle_i  : in std_logic_vector(8 downto 0);
    shapegen2_gear_i    : in std_logic_vector(8 downto 0);
    shapegen2_lantern_i : in std_logic_vector(8 downto 0);
    shapegen2_fizz_i    : in std_logic_vector(8 downto 0);

    noise_freq    : in std_logic_vector(9 downto 0);
    slew_in       : in std_logic_vector(2 downto 0);
    cycle_recycle : in std_logic;
    
    shapegen1_shape_a      : out STD_LOGIC;
    shapegen1_shape_b      : out STD_LOGIC;
    shapegen2_shape_a      : out STD_LOGIC;
    shapegen2_shape_b      : out STD_LOGIC
    -- add y,r,b and cmparitor (spead)
  );
end analoge_side;

architecture Behavioral of analoge_side is

signal    mixer_inputs :  array_12(10 downto 0);
signal    matrix_outputs :  array_12(19 downto 0);
signal    outputs :  array_12(19 downto 0);

signal    Adder_A :  array_12(19 downto 0);
signal    Adder_B :  array_12(19 downto 0);

begin
Adder_A(0) <= shapegen1_pos_h & "000";
Adder_A(1) <= shapegen1_pos_v & "000";
Adder_A(2) <= shapegen1_zoom_h & "000";
Adder_A(3) <= shapegen1_zoom_v & "000";
Adder_A(4) <= shapegen1_circle_i & "000";
Adder_A(5) <= shapegen1_gear_i & "000";
Adder_A(6) <= shapegen1_lantern_i & "000";
Adder_A(7) <= shapegen1_fizz_i & "000";
Adder_A(8) <= shapegen2_pos_h & "000";
Adder_A(9) <= shapegen2_pos_v & "000";
Adder_A(10) <= shapegen2_zoom_h & "000";
Adder_A(11) <= shapegen2_zoom_v & "000";
Adder_A(12) <= shapegen2_circle_i & "000";
Adder_A(13) <= shapegen2_gear_i & "000";
Adder_A(14) <= shapegen2_lantern_i & "000";
Adder_A(15) <= shapegen2_fizz_i & "000";
--Adder_A(16) <= ;
--Adder_A(17) <= ;
--Adder_A(18) <= ;
--Adder_A(19) <= ;
-- create an adder for each matrix output to combine constants and 
  gen_adders: for i in 0 to 20 - 1 generate
    -- Instantiate Adder_9bit_NoOverflow module
    Adder_inst : entity work.Adder_12bit_NoOverflow
      port map (
        A => Adder_A(i),
        B => matrix_outputs(i),
        Sum => outputs(i),
        Overflow => open
      );
  end generate gen_adders;
  -- Instantiate mixer_interface
  mixer_instance: entity work.mixer_interface
    port map (
      clk           => clk,
      rst           => rst,
      wr            => wr,
      out_addr      => out_addr,
      ch_addr       => ch_addr,
      gain_in       => gain_in,
      mixer_inputs  => mixer_inputs,
      outputs       => matrix_outputs
    );

  -- Instantiate shape_gen (shapegen1)
  shapegen1_instance: entity work.shape_gen
    port map (
      clk          => clk,
      counter_x    => counter_x,
      counter_y    => counter_y,
      rst          => rst,
      pos_h        => outputs(0)(11 downto 3),
      pos_v        => outputs(1)(11 downto 3),
      zoom_h       => outputs(2)(11 downto 3),
      zoom_v       => outputs(3)(11 downto 3),
      circle_i     => outputs(4)(11 downto 3),
      gear_i       => outputs(5)(11 downto 3),
      lantern_i    => outputs(6)(11 downto 3),
      fizz_i       => outputs(7)(11 downto 3),
      shape_a      => shapegen1_shape_a,
      shape_b      => shapegen1_shape_b
    );

  -- Instantiate shape_gen (shapegen2)
  shapegen2_instance: entity work.shape_gen
    port map (
      clk          => clk,
      counter_x    => counter_x,
      counter_y    => counter_y,
      rst          => rst,
      pos_h        => outputs(8)(11 downto 3),
      pos_v        => outputs(9)(11 downto 3),
      zoom_h       => outputs(10)(11 downto 3),
      zoom_v       => outputs(11)(11 downto 3),
      circle_i     => outputs(12)(11 downto 3),
      gear_i       => outputs(13)(11 downto 3),
      lantern_i    => outputs(14)(11 downto 3),
      fizz_i       => outputs(15)(11 downto 3),
      shape_a      => shapegen2_shape_a,
      shape_b      => shapegen2_shape_b
    );

  -- Instantiate random_voltage
  random_voltage_instance: entity work.random_voltage
    port map (
      Clock        => clk,
      recycle      => cycle_recycle,
      rst          => rst,
      noise_freq   => noise_freq,
      slew_in      => slew_in,
      noise_1      => open,
      noise_2      => open
    );


  
end Behavioral;
