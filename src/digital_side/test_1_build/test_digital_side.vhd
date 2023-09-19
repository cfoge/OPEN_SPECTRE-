
--   ____  _____  ______ _   _         _____ _____  ______ _____ _______ _____  ______ 
--  / __ \|  __ \|  ____| \ | |       / ____|  __ \|  ____/ ____|__   __|  __ \|  ____|
-- | |  | | |__) | |__  |  \| |      | (___ | |__) | |__ | |       | |  | |__) | |__   
-- | |  | |  ___/|  __| | . ` |       \___ \|  ___/|  __|| |       | |  |  _  /|  __|  
-- | |__| | |    | |____| |\  |       ____) | |    | |___| |____   | |  | | \ \| |____ 
--  \____/|_|    |______|_| \_|      |_____/|_|    |______\_____|  |_|  |_|  \_\______|
--                               ______                                                
--                              |______|                                               
-- Module Name: test_digital_side by RD Jordan
-- Created: Early 2023
-- Description: 
-- Dependencies: 
-- Additional Comments: You can view the project here: https://github.com/cfoge/OPEN_SPECTRE-
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
use IEEE.STD_LOGIC_1164.ALL;
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
  Port ( 
      sys_clk      :in    STD_LOGIC;
      clk_25_in      :in    STD_LOGIC;
      rst      :in    STD_LOGIC;
      RBG_out       : out STD_LOGIC_VECTOR (23 downto 0);
    
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
      
    -- signals to drive the mux's
    matrix_in_addr: in std_logic_vector(5 downto 0);
    matrix_in_mux   : in STD_LOGIC_VECTOR (5 downto 0);
    matrix_load: in STD_LOGIC;
    matrix_latch: in STD_LOGIC;
    matrix_cs: in std_logic_vector(3 downto 0);
         
     clk_x_out  : out STD_LOGIC;
     clk_y_out  : out STD_LOGIC;
     video_on   : out STD_LOGIC
  );
end test_digital_side;

architecture Behavioral of test_digital_side is
--Global Signals
signal clk_x : STD_LOGIC;
signal clk_y : STD_LOGIC;

   
--Matrix Out to module in
--signal ff_d : STD_LOGIC;
--signal ff_clk : STD_LOGIC;
signal inv_in : std_logic_vector(3 downto 0);
signal xy_inv_in : std_logic_vector(17 downto 0);
signal delay_in : STD_LOGIC;
signal edge_detector_in : STD_LOGIC;
signal colour_swap : STD_LOGIC;
signal luma_in1 : std_logic_vector(3 downto 0);
signal luma_in2 : std_logic_vector(3 downto 0);
--signal chroma_in1 : std_logic_vector(5 downto 0);
--signal chroma_in2 : std_logic_vector(5 downto 0);
signal overlay_gate1 : std_logic_vector(3 downto 0);
signal overlay_gate2 : std_logic_vector(3 downto 0);
signal ff_in_a : STD_LOGIC;
signal ff_in_b : STD_LOGIC;

--Matrix Out to global
signal luma_out : std_logic_vector(3 downto 0);

-- Chroma Mux input/output signals
--signal chroma_xor_1   : std_logic_vector(5 downto 0);
signal chroma_mux_in1 : std_logic_vector(5 downto 0);
signal chroma_mux_in2 : std_logic_vector(5 downto 0);
signal chroma_mux_out : std_logic_vector(5 downto 0);

-- Overlay Gates Signals
signal not_overlay_gate2 : std_logic_vector(3 downto 0);

--Matrix In from module out
--signal ff_q : STD_LOGIC;
--signal ff_nq : STD_LOGIC;
signal inv_out : std_logic_vector(3 downto 0);
signal x_count : std_logic_vector(8 downto 0);
signal y_count : std_logic_vector(8 downto 0);
signal xy_count : std_logic_vector(17 downto 0);
signal xy_inv_out : std_logic_vector(17 downto 0);
signal delay_out : STD_LOGIC;
signal slow_cnt_6 : STD_LOGIC;
signal slow_cnt_3 : STD_LOGIC;
signal slow_cnt_1_5 : STD_LOGIC;
signal slow_cnt_0_6 : STD_LOGIC;
signal slow_cnt_0_4 : STD_LOGIC;
signal slow_cnt_0_2 : STD_LOGIC;
--signal ext_vid_out : std_logic_vector(6 downto 0);
signal edge_detector_out : std_logic_vector(3 downto 0);
signal overlay_gate_out : std_logic_vector(3 downto 0);
signal ff_out_a : STD_LOGIC;
signal ff_out_b : STD_LOGIC;
signal shape_a_0 : STD_LOGIC;
signal shape_b_0 : STD_LOGIC;
signal shape_a_1 : STD_LOGIC;
signal shape_b_1 : STD_LOGIC;

  signal comp_output : STD_LOGIC_VECTOR (6 downto 0);

--Matrix Module controls
signal vid_span : std_logic_vector(7 downto 0);


--To analog side
signal acm_out1 : STD_LOGIC;
signal acm_out2 : STD_LOGIC;

-- Matrix control signals
-- Matrix full
 signal clk       : STD_LOGIC;
 signal matrix_in : STD_LOGIC_VECTOR (64 downto 0) := (others => '0');
-- signal matrix_in_addr  : STD_LOGIC_VECTOR (5 downto 0);
-- signal matrix_load        : std_logic ;
-- signal matrix_latch        :  std_logic ;
-- signal matrix_cs        :  STD_LOGIC_VECTOR(3 downto 0) ;
 signal matrix_out :  STD_LOGIC_VECTOR (64 downto 0):= (others => '0');


-- Colour Output
signal luma_vid_out : std_logic_vector(3 downto 0);
signal chroma_vid_out : std_logic_vector(5 downto 0);

signal Y : std_logic_vector(7 downto 0);
signal Cr : std_logic_vector(7 downto 0);
signal Cb : std_logic_vector(7 downto 0);
signal R : std_logic_vector(7 downto 0);
signal G : std_logic_vector(7 downto 0);
signal B : std_logic_vector(7 downto 0);


-- mux test sigs
signal mux_in : std_logic_vector(31 downto 0);
signal mux_selB : std_logic_vector(16 downto 0) := (others => '0');
signal mux_selC : std_logic_vector(16 downto 0) := (others => '0');
signal mux_selD : std_logic_vector(31 downto 0) := (others => '0');
signal mux_selE : std_logic_vector(31 downto 0) := (others => '0');
signal chrom_swap : STD_LOGIC;


--External signals
signal clk_25 : STD_LOGIC;
signal ff_clr : STD_LOGIC;
signal comp_luma_i : STD_LOGIC_VECTOR (7 downto 0);

--mux function
 function multi321 (A,B: in std_logic_vector) return std_logic is
  begin
      return A(to_integer(unsigned(B)));
  end multi321;

begin

    --assignemt from external in
      clk    <= sys_clk;
      clk_25    <= clk_25_in;
      luma_vid_out <= luma_out;
      chroma_vid_out <= chroma_mux_out;
      clk_x_out <= clk_x;
      clk_y_out <= clk_y;

     vga_trimming_signals : entity work.vga_trimming_signals
        port map (
      clk_25mhz   => clk_25, 
        h_sync => clk_x,      
        v_sync  => clk_y,     
        video_on  => video_on
        );

    x_counter : entity work.counter
        port map (
         clk => clk_25_in, -- check what it is actualy driven by, pixel clk right?
        rst => clk_x,--rst, -- x needs to be reset by hs otherwise some bits out run over and get out of sync on the next line
        enable => '1',
        count => x_count
        );
        
    y_counter : entity work.counter
        port map (
         clk => clk_x, -- check what it is actualy driven by, hoz sync right
        rst => clk_y, --vsync reset to stop rolling
        enable => '1',
        count => y_count
        );
       
    xy_count <= (y_count & x_count); -- concat x & y
    xy_invert_logic: entity work.xor18
       port map (
        a => xy_count, 
        b => xy_inv_in,
        y =>  xy_inv_out   
       );
       
   slow_counter : entity work.slow_counter ------get it working
        port map (
            clk => clk_25,
            hz6 => slow_cnt_6,
            hz3 => slow_cnt_3,
            hz1_5 => slow_cnt_1_5,
            hz_6 => slow_cnt_0_6,
            hz_4 => slow_cnt_0_4,
            hz_2 => slow_cnt_0_2 
        );

    not_overlay_gate2 <= NOT overlay_gate2; 
    overlay_gates: entity work.nand4
       port map (
        a => overlay_gate1,
        b =>  not_overlay_gate2,
        y =>  overlay_gate_out  
       ); 
       
    inverters: entity work.invert_4
       port map (
        input => inv_in,
        output =>  inv_out   
       );
       
    edge : entity work.monstable_4
      Port map( 
            input => edge_detector_in,
            clk  => clk,
            output => edge_detector_out 
      );
      
--   

       
    
    comparitor : entity work.compare_7 
    Port map( 
       clk   => clk,
       luma_i => comp_luma_i,
       output => comp_output,
       span => "00000000"
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
    pin_matrix : entity work.huge_crospoint_wraper
    Port map ( 
           matrix_in => matrix_in,
           in_addr => matrix_in_addr,
           in_mux => matrix_in_mux,
           clk        => clk,
           rst       => rst,
           load       =>matrix_load,
           latch      =>matrix_latch,
           cs        => matrix_cs,
           matrix_out  => matrix_out
           );

       
       ----------------------------------------asignments
       -- MAtrix IN
       matrix_in(0) <= '0';
       matrix_in(18 downto 1) <= xy_inv_out;  -- the 0 at the start is a place holder for no pins
       matrix_in(19) <= slow_cnt_6;
       matrix_in(20) <= slow_cnt_3;
       matrix_in(21) <= slow_cnt_1_5;
       matrix_in(22) <= slow_cnt_0_6;
       matrix_in(23) <= slow_cnt_0_4;
       matrix_in(24) <= slow_cnt_0_2;
       matrix_in(28 downto 25) <= overlay_gate_out;
       matrix_in(32 downto 29) <= inv_out;
       matrix_in(36 downto 33) <= edge_detector_out;
       matrix_in(37) <= delay_out;
       matrix_in(38) <= ff_out_a;
       matrix_in(39) <= ff_out_b;
       matrix_in(40) <= shape_a_0;
       matrix_in(41) <= shape_b_0;
       matrix_in(40) <= shape_a_1;
       matrix_in(41) <= shape_b_1;
       --matrix_in(50 downto 46) <= comp_output; -- migh tneed to be reveresed to match the pinout on the moriginal
       
       
       -- MATRIX OUT
       xy_inv_in(17 downto 0)       <= matrix_out(17 downto 0);
       overlay_gate1(0) <= matrix_out(18);
       overlay_gate2(0) <= matrix_out(19);
       overlay_gate1(1) <= matrix_out(20);
       overlay_gate2(1) <= matrix_out(21);
       overlay_gate1(2) <= matrix_out(22);
       overlay_gate2(2) <= matrix_out(23);
       overlay_gate1(3) <= matrix_out(24);
       overlay_gate2(3) <= matrix_out(25);
       inv_in           <= matrix_out(29 downto 26);
       edge_detector_in <= matrix_out(30);
       delay_in         <= matrix_out(31);
       ff_out_a         <= matrix_out(32);
       ff_out_b         <= matrix_out(33);
       
       acm_out1                   <= matrix_out(35);
       acm_out1                   <= matrix_out(36);
       
       luma_in1(3 downto 0)       <= matrix_out(40 downto 37);
       chroma_mux_in1(2 downto 0) <= matrix_out(43 downto 41);
       chroma_mux_in1(5 downto 3) <= matrix_out(46 downto 44);
       luma_in2(3 downto 0)       <= matrix_out(50 downto 47);
       chroma_mux_in2(2 downto 0) <= matrix_out(53 downto 51); 
       chroma_mux_in2(5 downto 3) <= matrix_out(56 downto 54);
       chrom_swap                 <= matrix_out(57);

      
       -------------------------------------- output
       
       
       luma_output: entity work.xor_n
       generic map (
        n => 4
       )
       port map (
        a => luma_in1,
        b => luma_in2,
        y => luma_out  
       );
       
     chroma_output : entity work.mux_5 
        Port map ( 
            sel => chrom_swap, -- temp val was colour swap
            a => chroma_mux_in1,
            b => chroma_mux_in2,
            c => chroma_mux_out
         );
       
       -----------------------------------------

   -- -- Pack chroma and luma into YUV converter
    Y <= (luma_vid_out) & "0000";  
    Cr <= chroma_vid_out(5 downto 3) & "00000";  
    Cb <= chroma_vid_out(2 downto 0) & "00000";  
    -- YCrCb to RGB converter
    colour_space_conv : entity work.ycrcr2rgb_simple
      Port map( 
            y => y,
            Cr => Cr,
            Cb => Cb,
            R => R,
            G => G,
            B => B
      );
    -- Pack rgb output into output bus
    RBG_out <= R & G & B;

end Behavioral;
