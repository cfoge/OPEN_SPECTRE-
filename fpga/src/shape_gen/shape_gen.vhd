
--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|                                               
-- Module Name: shape_gen by RD Jordan
-- Created: Early 2023
-- Description: 
-- Dependencies: 
-- Additional Comments: You can view the project here: https://github.com/cfoge/OPEN_SPECTRE-

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity shape_gen is
  Port ( 
        clk          : in  std_logic;
        counter_x          : in  std_logic_vector(8 downto 0);
        counter_y          : in  std_logic_vector(8 downto 0);
        rst          : in  std_logic;
        pos_h   : in  std_logic_vector(8 downto 0);
        pos_v   : in  std_logic_vector(8 downto 0);
        zoom_h   : in  std_logic_vector(8 downto 0);
        zoom_v   : in  std_logic_vector(8 downto 0);
        circle_i   : in  std_logic_vector(8 downto 0);
        gear_i   : in  std_logic_vector(8 downto 0);
        lantern_i   : in  std_logic_vector(8 downto 0);
        fizz_i   : in  std_logic_vector(8 downto 0);

        shape_a    : out std_logic;
        shape_b    : out std_logic
  
  
  );
end shape_gen;

architecture Behavioral of shape_gen is

    signal pulse_x           : std_logic;
    signal ramp_x           : std_logic_vector(8 downto 0);
    signal parab_x           : std_logic_vector(8 downto 0);
    signal reset_ramp_x           : std_logic_vector(8 downto 0);
    signal reset_ramp_x_length           : unsigned(8 downto 0);
    signal noise_x           : std_logic_vector(8 downto 0);
    
    signal pulse_y           : std_logic;
    signal ramp_y           : std_logic_vector(8 downto 0);
    signal parab_y           : std_logic_vector(8 downto 0);
    signal reset_ramp_y           : std_logic_vector(8 downto 0);
    signal reset_ramp_y_length           : unsigned(8 downto 0);
    signal noise_y           : std_logic_vector(8 downto 0);
    
    signal mixed_parab        : std_logic_vector(8 downto 0);
    signal mixed_parab_i        : std_logic_vector(18 downto 0);
    signal mixed_parab_t2        : std_logic_vector(18 downto 0);    
    signal mixed_parab_t1        : integer; 
    
    signal moonlignt           : std_logic;
    signal criscross_inverted           : std_logic;
    signal lantern_behind_cutout           : std_logic;
    signal ring           : std_logic;
    signal amazon           : std_logic;
    signal cutout           : std_logic;
    signal criss_cross           : std_logic;
    signal gear_circle           : std_logic;
    signal hoz_seg           : std_logic;
    signal vert_seg          : std_logic;
    signal palm_leaves           : std_logic;
    signal triangles           : std_logic;
    signal frizz           : std_logic;
    signal lantern           : std_logic;
    signal gear           : std_logic;
    signal circle           : std_logic;
    
    signal shape_bus        : std_logic_vector(15 downto 0);
    signal shape_a_sel        : std_logic_vector(2 downto 0) := "110";
    signal shape_b_sel        : std_logic_vector(2 downto 0) := "000";
    
    --mux function
 function multi321 (A,B: in std_logic_vector) return std_logic is
  begin
      return A(to_integer(unsigned(B)));
  end multi321;

begin

reset_ramp_x_length <= shift_right(unsigned(zoom_h), 2);  -- zoom value x 4 so that the reset ram runs faster then h zoom but has a relation to it
reset_ramp_y_length <= shift_right(unsigned(zoom_v), 2); 

x_pulse_gen : entity work.shapes_pulse_gen_x
port map(
        clk          => clk,
        rst           => rst,
        counter_in    => counter_x,
        pulse_start   => pos_h,
        pulse_len     => zoom_h,
        zoom          => std_logic_vector(reset_ramp_x_length),
        pulse_out     => pulse_x,
        ramp_out      => ramp_x,
        parab_out    => parab_x,
        reset_ramp    => reset_ramp_x,
        noise_out     => noise_x
        );
        
y_pulse_gen : entity work.shapes_pulse_gen
port map(
        clk          => clk,
        rst           => rst,
        counter_in    => counter_y,
        pulse_start   => pos_v,
        pulse_len     => zoom_v,
        zoom          => std_logic_vector(reset_ramp_y_length),
        pulse_out     => pulse_y,
        ramp_out      => ramp_y,
        parab_out    => parab_y,
        reset_ramp    => reset_ramp_y,
        noise_out     => noise_y
        );


process (clk) 
    begin
        if rising_edge(clk) then
        mixed_parab_t1 <=(to_integer(unsigned(parab_x) * unsigned(parab_x)) + to_integer(unsigned(parab_y) * unsigned(parab_y)));
        if (mixed_parab_t1 > 524287) then
            mixed_parab_t2 <= (others => '1');
        else     
            if pulse_y = '1' then
                mixed_parab_t2 <= std_logic_vector(to_unsigned(mixed_parab_t1, mixed_parab_t2'length));
            else
                mixed_parab_t2 <= "1111111111111111111";
            end if;
        end if;

        
    end if;
    end process;

sqrt_parab : entity work.SQRT
port map(
       value => mixed_parab_t2,
       result => mixed_parab_i
        );

mixed_parab <= mixed_parab_i(9 downto 1);

shape_logic : process (clk)
begin

--amazon
amazon <= cutout xor palm_leaves;
--cutout
cutout <= criss_cross xor triangles;
-- criss_cross
criss_cross <= vert_seg xor hoz_seg;
-- gear+circle
gear_circle <= gear xor circle;
-- palm leaves ???? check this logic, it seems wrong
if ((triangles = '1') and (vert_seg = '0')) then
palm_leaves <= '1';
else
palm_leaves <= '0';
end if;
-- vert_seg
if (unsigned(reset_ramp_y) > unsigned(mixed_parab)) then
vert_seg <= '1';
else
vert_seg <= '0';
end if;
-- hoz_seg
if (unsigned(reset_ramp_x) > unsigned(mixed_parab)) then
hoz_seg <= '1';
else
hoz_seg <= '0';
end if;
-- triangles
if (unsigned(reset_ramp_x) > unsigned(reset_ramp_y)) then
triangles <= '1';
else
triangles <= '0';
end if;
-- circle
if (unsigned(circle_i) > unsigned(mixed_parab)) then
circle <= '1';
else
circle <= '0';
end if;

end process;
    
shape_bus <= lantern_behind_cutout & moonlignt & amazon & cutout & palm_leaves & triangles & not criss_cross & criss_cross & hoz_seg & vert_seg & gear_circle & gear & lantern & frizz & ring & circle;


shape_a <= multi321(shape_bus, shape_a_sel);
shape_b <= multi321(shape_bus, shape_b_sel);


end Behavioral;


