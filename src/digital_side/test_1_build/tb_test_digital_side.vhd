library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.ALL;

entity tb_test_digital_side is
end tb_test_digital_side;

architecture behavior of tb_test_digital_side is
    component test_digital_side is
        port ( 
    sys_clk   : in std_logic;
    clk_x      : in std_logic;
    clk_y       : in std_logic;
    clk_25_in : in std_logic;
    rst       : in std_logic;
    YCRCB   : out std_logic_vector (23 downto 0);

    --register file controlls
    matrix_in_addr : in std_logic_vector(5 downto 0);
    matrix_load    : in std_logic;
    matrix_mask_in : in std_logic_vector(63 downto 0); --controls which inputs are routed to a selected output
    invert_matrix  : in std_logic_vector(63 downto 0); --inverts a matrix input globaly
    vid_span       : in std_logic_vector(7 downto 0);

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
    end component;
    
    component write_file_ex is
       port (
            clk    : in  std_logic;   
            hs    : in  std_logic;   
            vs    : in  std_logic;   
            r    : in  std_logic_vector(7 downto 0);  
            g    : in  std_logic_vector(7 downto 0);   
            b    : in  std_logic_vector(7 downto 0);
            vid_active : in    std_logic 
    
        );
    end component;
    
    component vga_trimming_signals is
    port (
        clk_25mhz    : in  std_logic;    -- 40mhz clock input SVGA 800x600
        h_sync       : out std_logic;    -- horizontal sync output
        v_sync       : out std_logic;    -- vertical sync output
        video_on     : out std_logic     -- video on/off output
    );
end component vga_trimming_signals;

    signal vid_active: std_logic := '0';

    signal sys_clk: std_logic := '0';
    signal clk_25_in: std_logic := '0';
    signal rst: std_logic := '0';
    signal RBG_out: std_logic_vector(23 downto 0);
    signal RBG: std_logic_vector(23 downto 0);
    
    signal matrix_in_addr :  std_logic_vector(5 downto 0) := (others => '0');
    signal matrix_load    :  std_logic;
    signal matrix_mask_in :  std_logic_vector(63 downto 0) := (others => '0'); --controls which inputs are routed to a selected output
    signal invert_matrix  :  std_logic_vector(63 downto 0) := (others => '0'); --inverts a matrix input globaly
    signal vid_span       :  std_logic_vector(7 downto 0) := (others => '0');
    
    signal matrix_cs:  std_logic_vector(3 downto 0);
    signal clk_x_out: std_logic := '0';
    signal clk_Y_out: std_logic := '0';
    
    signal clk_x: std_logic := '0';
    signal clk_Y: std_logic := '0';

    signal    sgen_pos_h_0   :   std_logic_vector(8 downto 0);
    signal    sgen_pos_v_0   :   std_logic_vector(8 downto 0);
     signal   sgen_zoom_h_0   :   std_logic_vector(8 downto 0);
    signal    sgen_zoom_v_0   :   std_logic_vector(8 downto 0);
    signal    sgen_circle_i_0   :   std_logic_vector(8 downto 0);
    signal    sgen_gear_i_0   :   std_logic_vector(8 downto 0);
    signal    sgen_lantern_i_0   :   std_logic_vector(8 downto 0);
    signal    sgen_fizz_i_0   :   std_logic_vector(8 downto 0);   
    signal    sgen_pos_h_1   :   std_logic_vector(8 downto 0);
    signal    sgen_pos_v_1   :   std_logic_vector(8 downto 0);
    signal    sgen_zoom_h_1   :   std_logic_vector(8 downto 0);
    signal    sgen_zoom_v_1   :   std_logic_vector(8 downto 0);
    signal    sgen_circle_i_1   :   std_logic_vector(8 downto 0);
    signal   sgen_gear_i_1   :   std_logic_vector(8 downto 0);
    signal   sgen_lantern_i_1   :   std_logic_vector(8 downto 0);
    signal    sgen_fizz_i_1   :   std_logic_vector(8 downto 0);
    
    function left_shift_by_decimal(input_val : natural) return std_logic_vector is
        variable result : std_logic_vector(63 downto 0) := (others => '0');
    begin
        result := "0000000000000000000000000000000000000000000000000000000000000001"; -- Binary representation of 1
        for i in 1 to input_val loop
            result :=  result(62 downto 0) & '0'; -- Left shift by 1 position
        end loop;
        return result;
    end left_shift_by_decimal;

begin
    RBG<= RBG_out;
    
    timing: vga_trimming_signals
    port map(
        clk_25mhz    => sys_clk ,
        h_sync      => clk_x,
        v_sync      => clk_y,
        video_on     => vid_active
    );

    DUT: test_digital_side
        port map (
            sys_clk => sys_clk,
            clk_25_in => clk_25_in,
            clk_x => clk_x,
            clk_y => clk_y,
            rst => rst,
            YCRCB => RBG_out,
         
         matrix_in_addr => matrix_in_addr,
         
    matrix_load   => matrix_load,
    matrix_mask_in => matrix_mask_in,
    invert_matrix => invert_matrix,
    vid_span     =>   vid_span,
         
         
            clk_x_out => clk_x_out,
            clk_Y_out => clk_Y_out,
                    sgen_pos_h_0 => sgen_pos_h_0,
        sgen_pos_v_0 =>  sgen_pos_v_0,
        sgen_zoom_h_0 =>  sgen_zoom_h_0,
        sgen_zoom_v_0 => sgen_zoom_v_0 ,
        sgen_circle_i_0  => sgen_circle_i_0,
        sgen_gear_i_0 => sgen_gear_i_0,
        sgen_lantern_i_0 => sgen_lantern_i_0,
        sgen_fizz_i_0  =>sgen_fizz_i_0,
        
        sgen_pos_h_1 =>  sgen_pos_h_1,
        sgen_pos_v_1 =>  sgen_pos_v_1,
        sgen_zoom_h_1 => sgen_zoom_h_1,
        sgen_zoom_v_1  => sgen_zoom_v_1,
        sgen_circle_i_1 => sgen_circle_i_1,
        sgen_gear_i_1  => sgen_gear_i_1,
        sgen_lantern_i_1 => sgen_lantern_i_1,
        sgen_fizz_i_1   => sgen_fizz_i_1
        );
        
        -- logging
    logger : write_file_ex
        port map (
            clk  => clk_25_in,
            hs   => clk_x_out,   
            vs   => clk_y_out,  
            r    => RBG(7 downto 0),
            g    => RBG(15 downto 8),
            b    => RBG(23 downto 16),
            vid_active => vid_active
            
        );

    clk_process: process
    begin
        sys_clk <= '0';
        clk_25_in <= '0';
        wait for 10 ns;
        sys_clk <= '1';
        clk_25_in <= '1';
        wait for 10 ns;
    end process clk_process;

    simulation: process
    begin


        sgen_pos_h_0 <= "111000000";
        sgen_pos_v_0 <= "100000000";
        sgen_zoom_h_0 <= "000000000";
        sgen_zoom_v_0 <= "000000000";
        sgen_circle_i_0  <= "010011000";
        
        
        
        
        sgen_gear_i_0 <= "011100000";
        sgen_lantern_i_0 <= "000100110";
        sgen_fizz_i_0 <= "000101000";
        -- Reset
        rst <= '0';
        wait for 100 ns;
        rst <= '1';
        matrix_load <= '0';
--        matrix_latch <= '0';
        matrix_cs <= "0000";
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;
        
        -- Set all the outputs to gnd
         for i in 0 to 63 loop
            matrix_in_addr <= std_logic_vector(to_unsigned(i, 6));
            matrix_mask_in <= left_shift_by_decimal(50);
            wait for 50 ns;
            matrix_load <= '1';
            wait for 50 ns;
            matrix_load <= '0';
        end loop;
        
        -- Test case 1 (route shape 0A to some luma outs
        wait for 500 ns;
        
        
--        ---------------------------------------------------------MUX WR COMAND -- 
        matrix_in_addr <= std_logic_vector(to_unsigned(49, 6)); -- this is the output
        matrix_mask_in  <= left_shift_by_decimal(40);

--        matrix_mask_in  <= std_logic_vector(to_unsigned(8, 64)); -- ithis is the input
        wait for 50 ns;
        matrix_load <= '1';
--        matrix_latch <= '1';
        wait for 50 ns;
        matrix_load <= '0';
--        matrix_latch <= '0';
        ---------------------------------------------------------
        
        --        ---------------------------------------------------------MUX WR COMAND -- 
        matrix_in_addr <= std_logic_vector(to_unsigned(48, 6)); -- this is the output
        matrix_mask_in  <= left_shift_by_decimal(40);

--        matrix_mask_in  <= std_logic_vector(to_unsigned(8, 64)); -- ithis is the input
        wait for 50 ns;
        matrix_load <= '1';
--        matrix_latch <= '1';
        wait for 50 ns;
        matrix_load <= '0';
--        matrix_latch <= '0';
        ---------------------------------------------------------
        
                --        ---------------------------------------------------------MUX WR COMAND -- 
        matrix_in_addr <= std_logic_vector(to_unsigned(47, 6)); -- this is the output
        matrix_mask_in  <= left_shift_by_decimal(40);

--        matrix_mask_in  <= std_logic_vector(to_unsigned(8, 64)); -- ithis is the input
        wait for 50 ns;
        matrix_load <= '1';
--        matrix_latch <= '1';
        wait for 50 ns;
        matrix_load <= '0';
--        matrix_latch <= '0';
        ---------------------------------------------------------



        -- End simulation
       -- wait for 10 ns;
      --  assert false report "End of simulation" severity failure;
        wait;
    end process simulation;
    

    

end behavior;
