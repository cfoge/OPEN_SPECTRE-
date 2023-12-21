
-- filter has IIR structure of: y[n] = b[0]*x[n] + b[1]*x[n-1] + b[2]*x[n-2] - a[1]*x[n-1] - a[2]*y[n-2]
---------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------
-- Note: this code uses Q numbers https://en.wikipedia.org/wiki/Q_(number_format)
-- q8.8 for example would mean that the number has 8 digits above the decimal place and 8 below
-- and Sq1.1 would be a signed number with 1 digit above and one below the decimal point using 2's compliment to represetn the negitive valiue
-----------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---------------------------------------------------------------------------
-- Entity Declaration
---------------------------------------------------------------------------
entity biquad_filt_iir is
--   generic
--   (
--     18 : cof_width := 18; -- sq2.15
--     23  : data_width := 23; -- sq0.22
--   )

  port
  (
    -- System signals
    rst    : in std_logic;
    clk    : in std_logic;
    clk_en : in std_logic;
    -- Audio data & Coefficients
    data_in     : in std_logic_vector(23 - 1 downto 0); -- neg values are two's compliment number  expressed as Signed Q number sQ0.22
    coeff_a1    : in std_logic_vector(18 - 1 downto 0); -- neg coefficients are  two's compliment  expressed as Signed Q number sQ2.15
    coeff_a2    : in std_logic_vector(18 - 1 downto 0);
    coeff_b0    : in std_logic_vector(18 - 1 downto 0);
    coeff_b1    : in std_logic_vector(18 - 1 downto 0);
    coeff_b2    : in std_logic_vector(18 - 1 downto 0);
    filter_done : out std_logic;
    data_out    : out std_logic_vector(23 - 1 downto 0); -- neg values are  two's compliment  expressed as Signed Q number sQ22.0
    debug  : out std_logic_vector(127 downto 0)
  );

end biquad_filt_iir;

architecture rtl of biquad_filt_iir is

  constant c_INT_WIDTH    : integer := 18 + 23 - 1; --  sQ2.37    40Bit
  constant c_MULT_B_WIDTH : integer := 18 + 23; -- ssq2.38    41Bit
  constant c_MULT_A_WIDTH : integer := 18 + c_INT_WIDTH; -- ssq4.52    58Bit

  -- IIR_BIQUAD signal delay taps to multipliers
  signal dataa_dly_n1 : std_logic_vector(c_INT_WIDTH - 1 downto 0) := (others => '0'); -- sQ2.37
  signal dataa_dly_n2 : std_logic_vector(c_INT_WIDTH - 1 downto 0) := (others => '0');

  signal datab_dly_n0 : std_logic_vector(23 - 1 downto 0) := (others => '0'); -- sQ0.22
  signal datab_dly_n1 : std_logic_vector(23 - 1 downto 0) := (others => '0');
  signal datab_dly_n2 : std_logic_vector(23 - 1 downto 0) := (others => '0');

  -- Outputs of  Multipliers  
  signal mult_a1 : signed(c_MULT_A_WIDTH - 1 downto 0) := (others => '0'); -- ssQ4.52
  signal mult_a2 : signed(c_MULT_A_WIDTH - 1 downto 0) := (others => '0');

  signal mult_b0 : signed(c_MULT_B_WIDTH - 1 downto 0) := (others => '0'); -- ssQ2.38
  signal mult_b1 : signed(c_MULT_B_WIDTH - 1 downto 0) := (others => '0');
  signal mult_b2 : signed(c_MULT_B_WIDTH - 1 downto 0) := (others => '0');
  -- Truncate Multipliers result for a0,a1 coefficients
  signal mult_a1_int : signed(c_INT_WIDTH - 1 downto 0) := (others => '0'); -- sQ2.37
  signal mult_a2_int : signed(c_INT_WIDTH - 1 downto 0) := (others => '0');

  signal mult_b0_int : signed(c_INT_WIDTH - 1 downto 0) := (others => '0'); -- sQ2.37
  signal mult_b1_int : signed(c_INT_WIDTH - 1 downto 0) := (others => '0');
  signal mult_b2_int : signed(c_INT_WIDTH - 1 downto 0) := (others => '0');

  signal data_ouput : signed(c_INT_WIDTH - 1 downto 0) := (others => '0'); -- sQ2.37
  -- State Machine control flags
  type state_type is (idle, run);
  signal state_reg, state_next : state_type;

  -- State Machine counter
  signal q_reg, q_next  : unsigned(3 downto 0);
  signal q_reset, q_add : std_logic;

  -- data path sequencing flags
  signal mul_coefs, trunc_prods, sum_of_prods, trunc_result, filt_done : std_logic;

begin

  -- process to delay samples (n+0),(n+1),(n+2) 
  process (clk, rst, data_ouput, clk_en)
  begin
    if (rst = '1') then
      datab_dly_n0 <= (others => '0');
      datab_dly_n1 <= (others => '0');
      datab_dly_n2 <= (others => '0');
      dataa_dly_n1 <= (others => '0');
      dataa_dly_n2 <= (others => '0');

    elsif (rising_edge(clk)) then
      if (clk_en = '1') then
        --Feed forward
        datab_dly_n0 <= data_in; -- sQ0.22
        datab_dly_n1 <= datab_dly_n0;
        datab_dly_n2 <= datab_dly_n1;
        --Feed back
        dataa_dly_n1 <= std_logic_vector(data_ouput); -- sQ2.37
        dataa_dly_n2 <= dataa_dly_n1;
      end if;
    end if;
  end process;
  
  
  -- State mec and timing
  process (clk, rst)
  begin
    if (rst = '1') then
      state_reg <= idle;
      q_reg     <= (others => '0'); -- reset counter
    elsif (rising_edge(clk)) then
      state_reg <= state_next; -- Change state
      q_reg     <= q_next;
    end if;
  end process;
  -- Incr counter for  State mec sequencing
  q_next <= (others => '0') when q_reset = '1' else -- reset counter 
    q_reg + 1 when q_add = '1' else -- increment count
    q_reg;
  -- State mec sequencing of data path 
  process (q_reg, state_reg, clk_en)
  begin

    -- defaults
    q_reset      <= '0';
    q_add        <= '0';
    mul_coefs    <= '0';
    trunc_prods  <= '0';
    sum_of_prods <= '0';
    trunc_result <= '0';
    filter_done  <= '0';
    filt_done    <= '0';
    case state_reg is

      when idle =>
        if (clk_en = '1') then
          state_next <= run;
        else
          state_next <= idle;
        end if;

      when run =>
        if (q_reg < "0001") then
          q_add      <= '1';
          state_next <= run;
        elsif (q_reg < "0011") then
          mul_coefs  <= '1';
          q_add      <= '1';
          state_next <= run;
        elsif (q_reg < "0101") then
          trunc_prods <= '1';
          q_add       <= '1';
          state_next  <= run;
        elsif (q_reg < "0111") then
          sum_of_prods <= '1';
          q_add        <= '1';
          state_next   <= run;
        elsif (q_reg < "1001") then
          trunc_result <= '1';
          q_add        <= '1';
          state_next   <= run;
        else
          q_reset     <= '1';
          filter_done <= '1';
          filt_done   <= '1';
          state_next  <= idle;
        end if;

    end case;
  end process;

  -- MULTIPLY DELAYED DATA WITH THE FILTER COEFFICIENTS 
  --This is the IIR Feed back path
  process (clk, sum_of_prods)
  begin
    if (rising_edge(clk)) then
      if (mul_coefs = '1') then
        mult_a1 <= signed(coeff_a1) * signed(dataa_dly_n1); -- a[1]*x[n-1]   --> ssQ39.0 =41Bit
        mult_a2 <= signed(coeff_a2) * signed(dataa_dly_n2); -- a[2]*x[n-2]

        --Feed forward path
        mult_b0 <= signed(coeff_b0) * signed(datab_dly_n0); -- b[0]*x[n-0]  --> ssQ39.0 =41Bit
        mult_b1 <= signed(coeff_b1) * signed(datab_dly_n1); -- b[1]*x[n-1] 
        mult_b2 <= signed(coeff_b2) * signed(datab_dly_n2); -- b[2]*x[n-2]
      end if;
    end if;
  end process;
  -- NOTE: WE MUST!! Truncate Multipliers result for a0,a1,b0,b1,b2 coefficients to common Qx.xx format prior to summing results
  process (clk, trunc_prods, mult_b0, mult_b1, mult_b2, mult_a1, mult_a2)
  begin
    if rising_edge(clk) then
      if (trunc_prods = '1') then
        mult_a1_int <= mult_a1(((c_MULT_A_WIDTH - 1) - 3) downto 18 - 3); -- ssQ4.52 -> sQ2.37
        mult_a2_int <= mult_a2(((c_MULT_A_WIDTH - 1) - 3) downto 18 - 3);

        mult_b0_int <= mult_b0(((c_MULT_B_WIDTH - 1) - 1) downto 0); -- ssQ2.37 -> sQ2.37
        mult_b2_int <= mult_b2(((c_MULT_B_WIDTH - 1) - 1) downto 0);
        mult_b1_int <= mult_b1(((c_MULT_B_WIDTH - 1) - 1) downto 0);
      end if;
    end if;
  end process;
  --  Accumulate results from Multipliers:-  y[n] = b[0]*x[n] + b[1]*x[n-1] + b[2]*x[n-2] - a[1]*x[n-1] - a[2]*y[n-2] 
  process (clk, sum_of_prods)
  begin
    if (rising_edge(clk)) then
      if (sum_of_prods = '1') then
        data_ouput <= (mult_b0_int + mult_b1_int + mult_b2_int - mult_a1_int - mult_a2_int); -- sQ2.37
      end if;
    end if;
  end process;
  -- Output results from Accumulator
  -- Note: Result is scaled back to signed Q22.0 format to remove original signed Q2.15 scaling by Coefficients and through multiplication chain.
  process (clk, trunc_result)
  begin
    if rising_edge(clk) then
      if (trunc_result = '1') then
        data_out <= std_logic_vector(data_ouput(c_INT_WIDTH - 3 downto 18 - 3)); -- sQ2.37 -> sQ0.22
      end if;
    end if;
  end process;


-- OUTPUT ASSIGNMENTS
  debug(c_INT_WIDTH - 1 downto 0) <= std_logic_vector(data_ouput);
--  debug(23 - 1 downto 69) <= std_logic_vector(data_ouput(c_INT_WIDTH - 3 downto 18 - 3)); -- sQ2.37 -> sQ0.22

  debug(120) <= clk_en;
  debug(121) <= mul_coefs;
  debug(122) <= trunc_prods;
  debug(123) <= sum_of_prods;
  debug(124) <= trunc_result;
  debug(125) <= filt_done;
  debug(126) <= q_add;
  -- debug(127 downto 0)  <= (others => '0');

end rtl;