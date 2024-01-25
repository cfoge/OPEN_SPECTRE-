----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.03.2023 17:52:29
-- Design Name: 
-- Module Name: test_digital_side - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.math_real.all;
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_digital_side is
  port
  (
    sys_clk   : in std_logic;
    clk_x      : in std_logic;
    clk_y       : in std_logic;
    clk_25_in : in std_logic;
    rst       : in std_logic;
    YCRCB   : out std_logic_vector (23 downto 0);

    --register file controlls
    matrix_in_addr : in std_logic_vector(5 downto 0);
    matrix_load    : in std_logic;
    matrix_mask_in : in std_logic_vector(63 downto 0) := (others => '0'); --controls which inputs are routed to a selected output
    invert_matrix  : in std_logic_vector(63 downto 0):= (others => '0'); --inverts a matrix input globaly
    vid_span       : in std_logic_vector(7 downto 0) := (others => '0');

    -- Shape gens move to anagloge side later?
        sgen_pos_h_0   : in  std_logic_vector(8 downto 0);
        sgen_pos_v_0   : in  std_logic_vector(8 downto 0);
        sgen_zoom_h_0   : in  std_logic_vector(8 downto 0);
        sgen_zoom_v_0   : in  std_logic_vector(8 downto 0);
        sgen_circle_i_0   : in  std_logic_vector(8 downto 0);
        sgen_gear_i_0   : in  std_logic_vector(8 downto 0);
        sgen_lantern_i_0   : in  std_logic_vector(8 downto 0);
        sgen_fizz_i_0   : in  std_logic_vector(8 downto 0);
        
        sgen_pos_h_1   : in  std_logic_vector(8 downto 0);
        sgen_pos_v_1   : in  std_logic_vector(8 downto 0);
        sgen_zoom_h_1   : in  std_logic_vector(8 downto 0);
        sgen_zoom_v_1   : in  std_logic_vector(8 downto 0);
        sgen_circle_i_1   : in  std_logic_vector(8 downto 0);
        sgen_gear_i_1   : in  std_logic_vector(8 downto 0);
        sgen_lantern_i_1   : in  std_logic_vector(8 downto 0);
        sgen_fizz_i_1   : in  std_logic_vector(8 downto 0);

    clk_x_out : out std_logic;
    clk_y_out : out std_logic;
    video_on  : out std_logic;

    -- inputs form analoge side
    osc1_sqr : in std_logic := '0';
    osc2_sqr : in std_logic := '0';
    random1  : in std_logic := '0';
    random2  : in std_logic := '0';
    audio_T  : in std_logic := '0';
    audio_B  : in std_logic := '0';
    extinput : in std_logic := '0';
   -- outputs to analoge side
    shape_a_analog : out std_logic_vector(7 downto 0);
    shape_b_analog : out std_logic_vector(7 downto 0);
    acm_out1_o : out std_logic;
    acm_out2_o : out std_logic
  );
end test_digital_side;

architecture Behavioral of test_digital_side is
  --Global Signals
--  signal clk_x : std_logic;
--  signal clk_y : std_logic;
  --Matrix Out to module in
  signal inv_in           : std_logic_vector(3 downto 0);
  signal xy_inv_in        : std_logic_vector(17 downto 0);
  signal delay_in         : std_logic;
  signal edge_detector_in : std_logic;
  signal colour_swap      : std_logic;
  signal luma_in1         : std_logic_vector(3 downto 0);
  signal luma_in2         : std_logic_vector(3 downto 0);
  signal overlay_gate1 : std_logic_vector(3 downto 0);
  signal overlay_gate2 : std_logic_vector(3 downto 0);
  signal ff_in_a       : std_logic;
  signal ff_in_b       : std_logic;
  --Matrix Out to global
  signal luma_out : std_logic_vector(3 downto 0);
  signal luma_fb  : std_logic_vector(3 downto 0); --luma feedback path to comparitor
  -- Chroma Mux input/output signals
  signal chroma_mux_in1 : std_logic_vector(5 downto 0);
  signal chroma_mux_in2 : std_logic_vector(5 downto 0);
  signal chroma_mux_out : std_logic_vector(5 downto 0);
  -- Overlay Gates Signals
  signal not_overlay_gate2 : std_logic_vector(3 downto 0);
  --Matrix In from module out
  signal inv_out        : std_logic_vector(3 downto 0);
  signal x_count        : std_logic_vector(8 downto 0);
  signal y_count        : std_logic_vector(8 downto 0);
  signal x_count_low_hi : std_logic_vector(8 downto 0);
  signal y_count_low_hi : std_logic_vector(8 downto 0);
  signal xy_count       : std_logic_vector(17 downto 0);
  signal xy_inv_out     : std_logic_vector(17 downto 0);
  signal delay_out      : std_logic;
  signal delay_in_vec   : std_logic_vector(0 downto 0);
  signal delay_out_vec  : std_logic_vector(0 downto 0);
  signal slow_cnt_6     : std_logic;
  signal slow_cnt_3     : std_logic;
  signal slow_cnt_1_5   : std_logic;
  signal slow_cnt_0_6   : std_logic;
  signal slow_cnt_0_4   : std_logic;
  signal slow_cnt_0_2   : std_logic;
  signal edge_detector_out : std_logic_vector(3 downto 0);
  signal overlay_gate_out  : std_logic_vector(3 downto 0);
  signal ff_out_a          : std_logic;
  signal ff_out_b          : std_logic;

  signal comp_output : std_logic_vector (6 downto 0);

signal shape_a_0 : STD_LOGIC;
signal shape_b_0 : STD_LOGIC;
signal shape_a_1 : STD_LOGIC;
signal shape_b_1 : STD_LOGIC;

  --To analog side
  signal acm_out1 : std_logic;
  signal acm_out2 : std_logic;

  -- Matrix control signals
  -- Matrix full
  signal clk           : std_logic;
  signal matrix_in     : std_logic_vector (63 downto 0) := (others => '0');
  signal matrix_in_inv : std_logic_vector (63 downto 0) := (others => '0'); -- matrix input after it has passed through the inverters
  signal matrix_out_e1 : std_logic_vector (63 downto 0) := (others => '0');
  signal matrix_out    : std_logic_vector (63 downto 0) := (others => '0');
  -- Colour Output
  signal luma_vid_out   : std_logic_vector(3 downto 0);
  signal chroma_vid_out : std_logic_vector(5 downto 0);
  signal chrom_swap : std_logic;

  signal Y  : std_logic_vector(7 downto 0);
  signal Cr : std_logic_vector(7 downto 0);
  signal Cb : std_logic_vector(7 downto 0);
  signal R  : std_logic_vector(7 downto 0);
  signal G  : std_logic_vector(7 downto 0);
  signal B  : std_logic_vector(7 downto 0);
  --External signals
  signal clk_25      : std_logic;
  signal ff_clr      : std_logic;

  -- comparitor input
  signal comp_luma_i : std_logic_vector (7 downto 0);

  --mux function
  function multi321 (A, B : in std_logic_vector) return std_logic is
  begin
    return A(to_integer(unsigned(B)));
  end multi321;

  function rev_v (a : in std_logic_vector)
    return std_logic_vector is
    variable result : std_logic_vector(a'range);
    alias aa        : std_logic_vector(a'REVERSE_RANGE) is a;
  begin
    for i in aa'range loop
      result(i) := aa(i);
    end loop;
    return result;
  end; -- function reverse_any_vector

begin

  --assignemt from external in
  clk            <= sys_clk;
  clk_25         <= clk_25_in;
  luma_vid_out   <= luma_out;
  chroma_vid_out <= chroma_mux_out;
  clk_x_out      <= clk_x;
  clk_y_out      <= clk_y;

--  vga_trimming_signals : entity work.vga_trimming_signals
--    port map
--    (
--      clk_25mhz => clk_25,
--      h_sync    => clk_x,
--      v_sync    => clk_y,
--      video_on  => video_on
--    );

  x_counter : entity work.counter
    port
    map (
    clk    => clk_25_in, -- check what it is actualy driven by, pixel clk right?
    rst    => clk_x, --rst, -- x needs to be reset by hs otherwise some bits out run over and get out of sync on the next line
    enable => '1',
    count  => x_count_low_hi
    );

  x_count <= rev_v(x_count_low_hi);

  y_counter : entity work.counter
    port
    map (
    clk    => clk_x, -- check what it is actualy driven by, hoz sync right
    rst    => clk_y, --vsync reset to stop rolling
    enable => '1',
    count  => y_count_low_hi
    );

  y_count <= rev_v(y_count_low_hi);

  xy_count <= (y_count & x_count); -- concat x & y
  xy_invert_logic : entity work.xor18
    port
    map (
    a => xy_count,
    b => xy_inv_in,
    y => xy_inv_out
    );

  slow_counter : entity work.slow_counter ------needs correct clock to have valid timings
    port
    map (
    clk   => clk_25,
    hz6   => slow_cnt_6,
    hz3   => slow_cnt_3,
    hz1_5 => slow_cnt_1_5,
    hz_6  => slow_cnt_0_6,
    hz_4  => slow_cnt_0_4,
    hz_2  => slow_cnt_0_2
    );

  not_overlay_gate2 <= not overlay_gate2;
  overlay_gates : entity work.nand4
    port
    map (
    a => overlay_gate1,
    b => not_overlay_gate2,
    y => overlay_gate_out
    );

  inverters : entity work.invert_4 --inverters
    port
    map (
    input  => inv_in,
    output => inv_out
    );

  edge : entity work.monstable_4
    port
    map(
    input  => edge_detector_in,
    clk    => clk,
    output => edge_detector_out
    );

  delay_in_vec(0) <= delay_in;
  delay_out       <= delay_out_vec(0);
  delay_800 : entity work.delay_800us
    port
    map(
    i_rst_sync => rst,
    i_clk      => clk,

    -- FIFO Write Interface
    i_wr_en   => '1',
    i_wr_data => delay_in_vec,
    o_full    => open,

    -- FIFO Read Interface
    i_rd_en   => '1',
    o_rd_data => delay_out_vec,
    o_empty   => open

    );

  flip_flop1 : entity work.D_flipflop_ext
    port
    map (
    clk    => clk_25,
    trig   => ff_in_a,
    rst    => clk_y,
    ff_out => ff_out_a
    );
  flip_flop2 : entity work.D_flipflop_ext
    port
    map (
    clk    => clk_25,
    trig   => ff_in_b,
    rst    => clk_y,
    ff_out => ff_out_b
    );

  comparitor : entity work.compare_7
    port
    map(
    clk    => clk,
    luma_i => comp_luma_i, -- set to feedback mode at present
    output => comp_output,
    span   => vid_span
    );

  ----------------------------------------------------------------
  -- Matrix input inverters, driven from reg file       
  matrix_input_inverters : entity work.xor_n
    generic
    map (
    n => 64
    )
    port
    map (
    a => matrix_in,
    b => invert_matrix,
    y => matrix_in_inv
    );


shape_gen_0 : entity work.shape_gen -- move to analoge side later!!!! just for organisational clarity
    port map (
        clk      => clk    ,
        counter_x  => x_count    ,
        counter_y  => y_count       ,
        rst      => rst   ,
        pos_h  => sgen_pos_h_0 ,
        pos_v    =>  sgen_pos_v_0,
        zoom_h    => sgen_zoom_h_0 ,
        zoom_v    =>  sgen_zoom_v_0,
        circle_i   => sgen_circle_i_0 ,
        gear_i   =>  sgen_gear_i_0 ,
        lantern_i   =>  sgen_lantern_i_0 ,
        fizz_i   =>  sgen_fizz_i_0 ,

        shape_a    => shape_a_0 ,
        shape_b     => shape_b_0
    );
    
    shape_gen_1 : entity work.shape_gen
    port map (
        clk      => clk    ,
        counter_x  => x_count    ,
        counter_y  => y_count       ,
        rst      => rst   ,
        pos_h  => sgen_pos_h_1 ,
        pos_v    =>  sgen_pos_v_1,
        zoom_h    => sgen_zoom_h_1 ,
        zoom_v    =>  sgen_zoom_v_1,
        circle_i   => sgen_circle_i_1 ,
        gear_i   =>  sgen_gear_i_1 ,
        lantern_i   =>  sgen_lantern_i_1 ,
        fizz_i   =>  sgen_fizz_i_1 ,

        shape_a    => shape_a_1 ,
        shape_b     => shape_b_1
    );
                                       
  ---------------------------------------------------------------
  -- HUGE MULTIPLEXER 
  pin_matrix : entity work.or_matrix_full
    port
    map (
    input     => matrix_in_inv,
    mask_addr => matrix_in_addr,
    mask      => matrix_mask_in,
    clk       => clk,
    --           rst       => rst,
    mask_en => matrix_load,
    --           latch      =>matrix_latch,
    output => matrix_out
    );
  -- need to work out what needs feedback protection and what doesnt, invert doesnt
  --    MATRIX_FEEDBACK : process (clk) is -- 2 clock delay in feedback path,lukely needs to be much longer 
  --      begin
  --        if rising_edge(clk) then
  --                matrix_out <= matrix_out_e1; -- 1 clock delay to avoid combinatory feedback paths when matrix out goes to matrix in
  --            end if;        
  --      end process;
  ----------------------------------------asignments
  -- MAtrix IN
  matrix_in(17 downto 0)  <= xy_inv_out; -- the 0 at the start is a place holder for no pins
  matrix_in(18)           <= slow_cnt_6;
  matrix_in(19)           <= slow_cnt_3;
  matrix_in(20)           <= slow_cnt_1_5;
  matrix_in(21)           <= slow_cnt_0_6;
  matrix_in(22)           <= slow_cnt_0_4;
  matrix_in(23)           <= slow_cnt_0_2;
  matrix_in(27 downto 24) <= overlay_gate_out;
  matrix_in(31 downto 28) <= inv_out;
  matrix_in(35 downto 32) <= edge_detector_out;
  matrix_in(36)           <= delay_out;
  matrix_in(37)           <= ff_out_a;
  matrix_in(38)           <= ff_out_b;

      matrix_in(40) <= shape_a_0;
       matrix_in(41) <= shape_b_0;
       matrix_in(42) <= shape_a_1;
       matrix_in(43) <= shape_b_1;
  --shapes1 a&b
  --shapes2 a&b
  matrix_in(49 downto 43) <= comp_output; -- migh tneed to be reveresed to match the pinout on the moriginal
  matrix_in(50)           <= '0'; -- gnd
  -- matrix in from analoge side
  matrix_in(51)           <= osc1_sqr ; -- 
  matrix_in(52)           <= osc2_sqr ; -- 
  matrix_in(53)           <= random1  ; -- 
  matrix_in(54)           <= random2  ; -- 
  matrix_in(55)           <= audio_T  ; -- 
  matrix_in(56)           <= audio_B  ; -- 
  matrix_in(57)           <= extinput ; -- 

  --matrix in extras add later
  -- special x/y counter 1?
  -- celular automita
  -- sequancer???

  -- MATRIX OUT
  xy_inv_in(17 downto 0) <= matrix_out(17 downto 0);
  overlay_gate1(0)       <= matrix_out(18);
  overlay_gate2(0)       <= matrix_out(19);
  overlay_gate1(1)       <= matrix_out(20);
  overlay_gate2(1)       <= matrix_out(21);
  overlay_gate1(2)       <= matrix_out(22);
  overlay_gate2(2)       <= matrix_out(23);
  overlay_gate1(3)       <= matrix_out(24);
  overlay_gate2(3)       <= matrix_out(25);
  inv_in                 <= matrix_out(29 downto 26);
  edge_detector_in       <= matrix_out(30);
  delay_in               <= matrix_out(31);
  ff_in_a                <= matrix_out(32);
  ff_in_b                <= matrix_out(33);

  acm_out1 <= matrix_out(34);
  acm_out2 <= matrix_out(35);
  acm_out1_o <= acm_out1;
  acm_out2_o <= acm_out2;

  luma_in1(3 downto 0)       <= matrix_out(39 downto 36);
  chroma_mux_in1(2 downto 0) <= matrix_out(42 downto 40);
  chroma_mux_in1(5 downto 3) <= matrix_out(45 downto 43);
  luma_in2(3 downto 0)       <= matrix_out(49 downto 46);
  chroma_mux_in2(2 downto 0) <= matrix_out(52 downto 50);
  chroma_mux_in2(5 downto 3) <= matrix_out(55 downto 53);
  chrom_swap                 <= matrix_out(56);

  -- Extra outs to analoge side
  -- shape_a_analog <= matrix_out(64 downto 57);
  -- shape_b_analog <= matrix_out(72 downto 65);
  -------------------------------------- output
  luma_output : entity work.xor_n
    generic
    map (
    n => 4
    )
    port
    map (
    a => luma_in1,
    b => luma_in2,
    y => luma_out
    );

  chroma_output : entity work.mux_5
    port
    map (
    sel => chrom_swap, -- temp val was colour swap
    a   => chroma_mux_in1,
    b   => chroma_mux_in2,
    c   => chroma_mux_out
    );

  -----------------------------------------

  -- -- Pack chroma and luma into YUV converter
  Y  <= (luma_vid_out) & "0000";
  Cr <= chroma_vid_out(5 downto 3) & "00000";
  Cb <= chroma_vid_out(2 downto 0) & "00000";
  YCRCB <= Y & Cr & Cb;
  -- -- Luma feedback path to comparitor in
  LUMA_FEEDBACK : process (clk) is -- 2 clock delay in feedback path,lukely needs to be much longer 
  begin
    if rising_edge(clk) then
      luma_fb     <= (luma_vid_out);
      comp_luma_i <= luma_fb & "0000";
    end if;
  end process;

end Behavioral;
