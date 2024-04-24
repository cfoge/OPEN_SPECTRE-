----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.01.2023 16:26:53
-- Design Name: 
-- Module Name: digital_side - Behavioral
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

entity digital_side is
  Port ( 
      sys_clk      :in    STD_LOGIC;
      clk_25_in      :in    STD_LOGIC;
      clk_x      :in    STD_LOGIC;
      clk_y      :in    STD_LOGIC;
      rst      :in    STD_LOGIC;
      video_in_ext : in STD_LOGIC_VECTOR (7 downto 0);
      RBG_out       : out STD_LOGIC_VECTOR (23 downto 0)
  );
end digital_side;

architecture Behavioral of digital_side is


--Global Signals

--Matrix Out to module in
signal ff_d : STD_LOGIC;
signal ff_clk : STD_LOGIC;
signal inv_in : std_logic_vector(3 downto 0);
signal xy_inv_in : std_logic_vector(17 downto 0);
signal delay_in : STD_LOGIC;
signal edge_detector_in : STD_LOGIC;
signal colour_swap : STD_LOGIC;
signal luma_in1 : std_logic_vector(3 downto 0);
signal luma_in2 : std_logic_vector(3 downto 0);
signal chroma_in1 : std_logic_vector(5 downto 0);
signal chroma_in2 : std_logic_vector(5 downto 0);
signal overlay_gate1 : std_logic_vector(3 downto 0);
signal overlay_gate2 : std_logic_vector(3 downto 0);


--Matrix Out to global
signal luma_out : std_logic_vector(3 downto 0);
--signal chroma_out1 : std_logic_vector(2 downto 0);
--signal chroma_out2 : std_logic_vector(2 downto 0);

-- Chroma Mux input/output signals
signal chroma_xor_1   : std_logic_vector(5 downto 0);
signal chroma_mux_in1 : std_logic_vector(5 downto 0);
signal chroma_mux_in2 : std_logic_vector(5 downto 0);
signal chroma_mux_out : std_logic_vector(5 downto 0);

-- Overlay Gates Signals
signal not_overlay_gate2 : std_logic_vector(3 downto 0);

--Matrix In from module out
signal ff_q : STD_LOGIC;
signal ff_nq : STD_LOGIC;
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
signal ext_vid_out : std_logic_vector(6 downto 0);
signal edge_detector_out : std_logic_vector(3 downto 0);
signal overlay_gate_out : std_logic_vector(3 downto 0);

--Matrix Module controls
signal vid_span : std_logic_vector(7 downto 0);


--To analog side
signal acm_out1 : STD_LOGIC;
signal acm_out2 : STD_LOGIC;

-- Matrix control signals
-- Matrix full
 constant x_in : integer := 8;
 constant y_out : integer := 8;
 signal clk       : STD_LOGIC;
 signal wr        : STD_LOGIC;
 signal  Data_In  :    std_logic_vector((x_in * 8) - 1 downto 0);
 signal  en       :    std_logic_vector(x_in -1 downto 0);
 signal  mux_sel  :    std_logic_vector((x_in * 3)-1 downto 0);
 signal  dmux_sel  :    std_logic_vector((y_out * 3)-1 downto 0);
 signal  en_sel   :    std_logic_vector(positive(ceil(log2(real(x_in)))) downto 0); --this is ugly, i should fix it
 signal  Data_out :   std_logic_vector((y_out * 8)-1 downto 0);
-- bus overlap and interleaver
signal  interleaver_in  :    std_logic_vector((x_in * 8) - 1 downto 0);
signal  interleaver_out  :    std_logic_vector((x_in * 8) - 1 downto 0);
signal  overlap_in  :    std_logic_vector((x_in * 8) - 1 downto 0);
signal  overlap_out  :    std_logic_vector((x_in * 8) - 1 downto 0);

-- Colour Output
signal luma_vid_out : std_logic_vector(3 downto 0);
signal chroma_vid_out : std_logic_vector(5 downto 0);

signal Y : std_logic_vector(7 downto 0);
signal U : std_logic_vector(7 downto 0);
signal V : std_logic_vector(7 downto 0);
signal R : std_logic_vector(7 downto 0);
signal G : std_logic_vector(7 downto 0);
signal B : std_logic_vector(7 downto 0);


--External signals
signal clk_25 : STD_LOGIC;
signal ff_clr : STD_LOGIC;


attribute dont_touch : string;
attribute dont_touch of ff_d : signal is "true";
attribute dont_touch of ff_clk : signal is "true";
attribute dont_touch of inv_in : signal is "true";
attribute dont_touch of xy_inv_in : signal is "true";
attribute dont_touch of delay_in : signal is "true";
attribute dont_touch of edge_detector_in : signal is "true";
attribute dont_touch of colour_swap : signal is "true";
attribute dont_touch of luma_in1 : signal is "true";
attribute dont_touch of luma_in2 : signal is "true";
attribute dont_touch of chroma_in1 : signal is "true";
attribute dont_touch of chroma_in2 : signal is "true";
attribute dont_touch of overlay_gate1 : signal is "true";
attribute dont_touch of overlay_gate2 : signal is "true";



attribute dont_touch of ff_q : signal is "true";
attribute dont_touch of ff_nq : signal is "true";
attribute dont_touch of inv_out : signal is "true";
attribute dont_touch of x_count : signal is "true";
attribute dont_touch of y_count : signal is "true";


--signal xy_count : std_logic_vector(17 downto 0);
--signal xy_inv_out : std_logic_vector(17 downto 0);
--signal delay_out : STD_LOGIC;
--signal slow_cnt_6 : STD_LOGIC;
--signal slow_cnt_3 : STD_LOGIC;
--signal slow_cnt_1_5 : STD_LOGIC;
--signal slow_cnt_0_6 : STD_LOGIC;
--signal slow_cnt_0_4 : STD_LOGIC;
--signal slow_cnt_0_2 : STD_LOGIC;
--signal ext_vid_out : std_logic_vector(6 downto 0);
--signal edge_detector_out : std_logic_vector(3 downto 0);
--signal overlay_gate_out : std_logic_vector(3 downto 0);

begin

--assignemt from external in
  clk    <= sys_clk;
  clk_25    <= clk_25_in;
  luma_vid_out <= luma_out;
  chroma_vid_out <= chroma_mux_out;

--logic to set pin matrix enable needed
-- add shape gen
-- add acm filters to analog side?? or just use the tbar rolling average ciode for the lpf??
--add video comparitor

    flip_flops: entity work.D_flipflop_ext
      port map (
           D => ff_d,
           clk => ff_clk,
           clear => ff_clr,
           preset => '1',
           Q => ff_q,
           Q_not => ff_nq
        );
    inverters: entity work.invert_4
       port map (
        input => inv_in,
        output =>  inv_out   
       );
       
    x_counter : entity work.counter
        port map (

         clk => clk_x, -- check what it is actualy driven by, pixel clk right?
        rst => rst,
        
        enable => '1',
        count => x_count
        );
        
    y_counter : entity work.counter
        port map (

         clk => clk_y, -- check what it is actualy driven by, hoz sync right
        rst => rst,

        enable => '1',
        count => y_count
        );
       
    xy_count <= (y_count & x_count); -- concat x & y 
    xy_invert_logic: entity work.xor18
       port map (
        a => xy_count, -- comes from the x/y counters !! change it!!
        b => xy_inv_in,
        y =>  xy_inv_out   
       );
       
    delay_dig : entity work.delay_800us
        port map (
            clk => clk_25,
            input => delay_in,
            output => delay_out
        );
        
    slow_counter : entity work.pulse_generator
        port map (
            clk => clk_25,
            pulse_6hz => slow_cnt_6,
            pulse_3hz => slow_cnt_3,
            pulse_1_5hz => slow_cnt_1_5,
            pulse_0_6hz => slow_cnt_0_6,
            pulse_0_4hz => slow_cnt_0_4,
            pulse_0_2hz => slow_cnt_0_2
        
        );
        
    video_in : entity work.compare_7
        Port map ( 
           clk => clk_25,
           luma_i => video_in_ext,
           output => ext_vid_out,
           span => vid_span
         );
         
    edge_detector : entity work.monstable_4
        Port map ( 
            clk => clk_25,
            input => edge_detector_in,
            output => edge_detector_out
         );
         
    edge_detector : entity work.monstable_4
        Port map ( 
            clk => clk_25,
            input => edge_detector_in,
            output => edge_detector_out
         );

    luma_output: entity work.xor_n
       generic map (
        n => 4
       )
       port map (
        a => luma_in1,
        b =>  luma_in2,
        y =>  luma_out  
       );
    
    not_overlay_gate2 <= NOT overlay_gate2;
    
    overlay_gates: entity work.nand4
       port map (
        a => overlay_gate1,
        b =>  not_overlay_gate2,
        y =>  overlay_gate_out  
       );
       
    chroma_xor: entity work.xor_n
       generic map (
        n => 6
       )
       port map (
        a => chroma_in1,
        b =>  chroma_in2,
        y =>  chroma_xor_1  
       );
       
    -- split xor chrma siognals to mux inputs
    chroma_mux_in1 <= (chroma_xor_1(5) & chroma_xor_1(2) & chroma_xor_1(4) & chroma_xor_1(3) & chroma_xor_1(0) & chroma_xor_1(1));
    chroma_mux_in2 <= (chroma_xor_1(2) & chroma_xor_1(5) & chroma_xor_1(1) & chroma_xor_1(0) & chroma_xor_1(3) & chroma_xor_1(4));
    
    chroma_output : entity work.mux_5 
        Port map ( 
            sel => colour_swap,
            a => chroma_mux_in1,
            b => chroma_mux_in2,
            c => chroma_mux_out
         );
         
     interleaver_in <=  x_count & y_count & slow_cnt_6 & slow_cnt_3 & slow_cnt_1_5 & slow_cnt_0_6 & slow_cnt_0_4 & slow_cnt_0_2 & overlay_gate_out & inv_out & edge_detector_out & '0' & ff_nq & "00" & "00" & "0000000" & "000000000000000";
         
     interleaver_matrix_in : entity work.interleaver
        generic map (
            n => 8,
            p => 64
        )
        Port map ( 
            a => interleaver_in,
            y => interleaver_out
         );         
     
     overlap_in <= interleaver_out;    
         
     bus_overlap : entity work.bus_ovrlap
        generic map (
            n => 2,
            k => 8,
            p => 64 -- was 70
        )
        Port map ( 
            a => overlap_in,
            y => overlap_out
         );     
         
         Data_In <= overlap_out;
         
    pin_matrix : entity work.pin_matrix_full
        generic map (
            x_in => 8,
            y_out => 8
        )
        Port map ( 
            clk => clk,
            wr => wr,
            Data_In => Data_In,
            en => en,
            mux_sel_t => mux_sel,
            dmux_sel_t => dmux_sel,
            en_sel => en_sel,
            Data_out => Data_out
         );

         -- Split data_out into individual bits and assign them to signals
        ff_d <= data_out(0);
        ff_clk <= data_out(1);
        inv_in <= data_out(5 downto 2);
        xy_inv_in <= data_out(23 downto 6);
        delay_in <= data_out(24);
        edge_detector_in <= data_out(25);
        colour_swap <= data_out(26);
        luma_in1 <= data_out(30 downto 27);
        luma_in2 <= data_out(34 downto 31);
        chroma_in1 <= data_out(40 downto 35);
        chroma_in2 <= data_out(46 downto 41);
        overlay_gate1 <= data_out(50 downto 47);
        overlay_gate2 <= data_out(54 downto 51);
--     interleaver_matrix_out : entity work.interleaver
--        generic map (
--            n => 8,
--            p => 64
--        )
--        Port map ( 
--            a => interleaver_B_in,
--            y => interleaver_B_out
--         );   

    -- Pack chroma and luma into YUV converter
    Y <= std_logic_vector(shift_left(unsigned(luma_vid_out), 4));  
    U <= std_logic_vector(shift_left(unsigned(chroma_vid_out(5 downto 3)), 6));  
    V <= std_logic_vector(shift_left(unsigned(chroma_vid_out(2 downto 0)), 6));  
    -- YUV to RGB converter
    YUV_to_RGB_i : entity work.YUV_to_RGB
        Port map (
            Y => Y,
            U => U,
            V => V,
            R => R,
            G => G,
            B => B
        );
     -- Pack rgb output into output bus
     RBG_out <= R & g & B;
        


end Behavioral;
