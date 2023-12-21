library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_biquad_filt_iir is
end tb_biquad_filt_iir;

architecture testbench of tb_biquad_filt_iir is
  -- Constants for coefficients this is a LPF BW = 24.0KHz  Q = 0.8  FS = 384KHz
--  constant coeff_a1_stage1 : std_logic_vector(18 - 1 downto 0) := "11" & x"4123";    --a1  -1.49111777
--  constant coeff_a2_stage1 : std_logic_vector(18 - 1 downto 0) := "00" & x"4e97";    --a2   0.61397425
--  constant coeff_b0_stage1 : std_logic_vector(18 - 1 downto 0) := "00" & x"03ee";    --b0   0.03071412
--  constant coeff_b1_stage1 : std_logic_vector(18 - 1 downto 0) := "00" & x"07dd";    --b1   0.06142824
--  constant coeff_b2_stage1 : std_logic_vector(18 - 1 downto 0) := "00" & x"03ee";    --b2   0.03071412

  constant coeff_a1_stage1 : std_logic_vector(18 - 1 downto 0) := "00" & x"0123";    --a1  -1.49111777
  constant coeff_a2_stage1 : std_logic_vector(18 - 1 downto 0) := "01" & x"0e97";    --a2   0.61397425
  constant coeff_b0_stage1 : std_logic_vector(18 - 1 downto 0) := "00" & x"03ee";    --b0   0.03071412
  constant coeff_b1_stage1 : std_logic_vector(18 - 1 downto 0) := "01" & x"07dd";    --b1   0.06142824
  constant coeff_b2_stage1 : std_logic_vector(18 - 1 downto 0) := "00" & x"50ee";    --b2   0.03071412


  -- Signals
  signal rst_tb, clk_tb, clk_en_tb, freq_count : std_logic := '0';
  signal data_in_tb, data_out_tb : std_logic_vector(23 - 1 downto 0) := (others => '0');
  signal filter_done_tb : std_logic;
  

  -- Clock process
  constant c_CLK_PERIOD : time := 10 ns; -- Assuming a fast clock
  constant c_CLK_EN_PERIOD : time := 100 ns; -- Assuming a 24MHz clock
  constant osc_PERIOD : time := 1500 ns; -- 4x slower than the sample clock

begin
  clk_process: process
  begin
    wait for c_CLK_PERIOD / 2;
    clk_tb <= not clk_tb;
  end process;

  clk_en_proc: process
  begin
    wait for c_CLK_EN_PERIOD / 2;
    clk_en_tb <= not clk_en_tb;
      end process;

    
    audio_sig: process
  begin
    wait for c_CLK_EN_PERIOD * 8;
    freq_count <= not freq_count;

      if freq_count = '1' then
        data_in_tb <= "01111111111111111111111";
        else
        data_in_tb <= "10000000000000000000000";
    end if;  
  end process;




  -- Stimulus process
  stimulus: process
  begin
    -- Initialize signals
    rst_tb <= '1';
    wait for c_CLK_PERIOD;
    rst_tb <= '0';

    -- Apply test cases
    wait for c_CLK_PERIOD;

    wait for 10 * c_CLK_PERIOD; -- Simulate for some cycles

    -- Add more test cases as needed

    -- Stop simulation
    wait;
  end process;

  -- Instantiate the biquad_filt_iir entity
  dut: entity work.biquad_filt_iir
    port map (
      rst => rst_tb,
      clk => clk_tb,
      clk_en => clk_en_tb,
      data_in => data_in_tb,
      coeff_a1 => coeff_a1_stage1,
      coeff_a2 => coeff_a2_stage1,
      coeff_b0 => coeff_b0_stage1,
      coeff_b1 => coeff_b1_stage1,
      coeff_b2 => coeff_b2_stage1,
      filter_done => filter_done_tb,
      data_out => data_out_tb
--      dbg_filt_a => (others => '0') -- assuming you don't need debug signals for the testbench
    );
end architecture testbench;

