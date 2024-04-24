library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_Std.ALL;

entity tb_test_digital_side is
end tb_test_digital_side;

architecture behavior of tb_test_digital_side is
    component test_digital_side is
        port ( 
            sys_clk: in std_logic;
            clk_25_in: in std_logic;
            rst: in std_logic;
            RBG_out: out std_logic_vector(23 downto 0);
            matrix_in_addr: in std_logic_vector(5 downto 0);
            matrix_load: in STD_LOGIC;
            clk_x_out  : out STD_LOGIC;
            clk_y_out  : out STD_LOGIC
        );
    end component;
    
    component write_file_ex is
       port (
            clk    : in  std_logic;   
            hs    : in  std_logic;   
            vs    : in  std_logic;   
            r    : in  std_logic_vector(7 downto 0);  
            g    : in  std_logic_vector(7 downto 0);   
            b    : in  std_logic_vector(7 downto 0)   
    
        );
    end component;

    signal sys_clk: std_logic := '0';
    signal clk_25_in: std_logic := '0';
    signal rst: std_logic := '0';
    signal RBG_out: std_logic_vector(23 downto 0);
    signal RBG: std_logic_vector(23 downto 0);
    signal matrix_in_addr:  std_logic_vector(5 downto 0);
    signal matrix_in_mux:  std_logic_vector(5 downto 0);
    signal matrix_load:  STD_LOGIC;
    signal matrix_latch: STD_LOGIC;
    signal matrix_cs:  std_logic_vector(3 downto 0);
    signal clk_x_out: std_logic := '0';
    signal clk_Y_out: std_logic := '0';
    
  

begin
    RBG<= RBG_out;

    DUT: test_digital_side
        port map (
            sys_clk => sys_clk,
            clk_25_in => clk_25_in,
            rst => rst,
            RBG_out => RBG_out,
            matrix_in_addr => matrix_in_addr,
            matrix_load => matrix_load,
            clk_x_out => clk_x_out,
            clk_Y_out => clk_Y_out
        );
        
        -- logging
    logger : write_file_ex
        port map (
            clk  => clk_25_in,
            hs   => clk_x_out,   
            vs   => clk_y_out,  
            r    => RBG(7 downto 0),
            g    => RBG(15 downto 8),
            b    => RBG(23 downto 16)
            
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
        -- Reset
        rst <= '0';
        wait for 100 ns;
        rst <= '1';
        matrix_load <= '0';
        matrix_latch <= '0';
        matrix_cs <= "0000";
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;
        -- Test case 1
        
        ---------------------------------------------------------MUX WR COMAND -- 
        matrix_in_addr <= std_logic_vector(to_unsigned(17, 6)); -- this is the output
        matrix_in_mux  <= std_logic_vector(to_unsigned(5, 6)); -- ithis is the input
        matrix_cs <= "0001";   
        wait for 50 ns;
        matrix_load <= '1';
        matrix_latch <= '1';
        wait for 50 ns;
        matrix_load <= '0';
        matrix_latch <= '0';
        ---------------------------------------------------------
        ---------------------------------------------------------MUX WR COMAND -- 
        matrix_in_addr <=std_logic_vector(to_unsigned(6, 6)); -- this is the output
        matrix_in_mux  <= std_logic_vector(to_unsigned(16, 6)); -- ithis is the input
        matrix_cs <= "0001";   
        wait for 50 ns;
        matrix_load <= '1';
        matrix_latch <= '1';
        wait for 50 ns;
        matrix_load <= '0';
        matrix_latch <= '0';
        ---------------------------------------------------------
        ---------------------------------------------------------
        matrix_in_addr <= std_logic_vector(to_unsigned(43, 6)); -- this is the output
        matrix_in_mux  <= std_logic_vector(to_unsigned(6, 6)); -- ithis is the input
        matrix_cs <= "0001";   
        wait for 50 ns;
        matrix_load <= '1';
        matrix_latch <= '1';
        wait for 50 ns;
        matrix_load <= '0';
        matrix_latch <= '0';
        ---------------------------------------------------------
                ---------------------------------------------------------
        matrix_in_addr <= std_logic_vector(to_unsigned(46, 6)); -- this is the output
        matrix_in_mux  <= std_logic_vector(to_unsigned(16, 6)); -- ithis is the input
        matrix_cs <= "0001";   
        wait for 50 ns;
        matrix_load <= '1';
        matrix_latch <= '1';
        wait for 50 ns;
        matrix_load <= '0';
        matrix_latch <= '0';
        ---------------------------------------------------------
        matrix_in_addr <= std_logic_vector(to_unsigned(30, 6)); -- this is the output
        matrix_in_mux  <= std_logic_vector(to_unsigned(3, 6)); -- ithis is the input
        matrix_cs <= "0001";   
        wait for 50 ns;
        matrix_load <= '1';
        matrix_latch <= '1';
        wait for 50 ns;
        matrix_load <= '0';
        matrix_latch <= '0';
        ---------------------------------------------------------
        ---------------------------------------------------------
        matrix_in_addr <= std_logic_vector(to_unsigned(3, 6)); -- this is the output
        matrix_in_mux  <= std_logic_vector(to_unsigned(6, 6)); -- ithis is the input
        matrix_cs <= "0001";   
        wait for 50 ns;
        matrix_load <= '1';
        matrix_latch <= '1';
        wait for 50 ns;
        matrix_load <= '0';
        matrix_latch <= '0';
        ---------------------------------------------------------
                ---------------------------------------------------------
        matrix_in_addr <= std_logic_vector(to_unsigned(40, 6)); -- this is the output
        matrix_in_mux  <= std_logic_vector(to_unsigned(33, 6)); -- ithis is the input
        matrix_cs <= "0001";   
        wait for 50 ns;
        matrix_load <= '1';
        matrix_latch <= '1';
        wait for 50 ns;
        matrix_load <= '0';
        matrix_latch <= '0';
        ---------------------------------------------------------
        


        -- End simulation
       -- wait for 10 ns;
      --  assert false report "End of simulation" severity failure;
        wait;
    end process simulation;
    

    

end behavior;
