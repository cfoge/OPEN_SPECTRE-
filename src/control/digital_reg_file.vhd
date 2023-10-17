

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.vcomponents.all;

entity digital_reg_file is
  port
  (
    -- CPU interface
    regs_clk     : in std_logic;
    regs_rst     : in std_logic;
    regs_en      : in std_logic;
    regs_wen     : in std_logic_vector(3 downto 0);
    regs_addr    : in std_logic_vector(12 downto 0);
    regs_wr_data : in std_logic_vector(31 downto 0);
    regs_rd_data : out std_logic_vector(31 downto 0);
    -- outptus
    -- Pinmatrix
    matrix_out_addr : out std_logic_vector(5 downto 0);
    matrix_mask_out : out std_logic_vector(63 downto 0); -- the pin settings for a single oputput
    matrix_load     : out std_logic;
    invert_matrix   : out std_logic_vector(63 downto 0); -- inverts matrix inputs before they go into the 'patch pannel'
    -- Comparitor
    vid_span : out std_logic_vector(7 downto 0);
    --analoge side
    out_addr       : out std_logic_vector(3 downto 0);
    ch_addr        : out std_logic_vector(3 downto 0);
    gain_in        : out std_logic_vector(4 downto 0);
    anna_matrix_wr : out std_logic;

    pos_h_1   : out std_logic_vector(8 downto 0);
    pos_v_1   : out std_logic_vector(8 downto 0);
    zoom_h_1  : out std_logic_vector(8 downto 0);
    zoom_v_1  : out std_logic_vector(8 downto 0);
    circle_1  : out std_logic_vector(8 downto 0);
    gear_1    : out std_logic_vector(8 downto 0);
    lantern_1 : out std_logic_vector(8 downto 0);
    fizz_1    : out std_logic_vector(8 downto 0);

    pos_h_2   : out std_logic_vector(8 downto 0);
    pos_v_2   : out std_logic_vector(8 downto 0);
    zoom_h_2  : out std_logic_vector(8 downto 0);
    zoom_v_2  : out std_logic_vector(8 downto 0);
    circle_2  : out std_logic_vector(8 downto 0);
    gear_2    : out std_logic_vector(8 downto 0);
    lantern_2 : out std_logic_vector(8 downto 0);
    fizz_2    : out std_logic_vector(8 downto 0);

    noise_freq    : out std_logic_vector(9 downto 0);
    slew_in       : out std_logic_vector(2 downto 0);
    cycle_recycle : out std_logic;

    y_level  : out std_logic_vector(11 downto 0);
    cr_level : out std_logic_vector(11 downto 0);
    cb_level : out std_logic_vector(11 downto 0);

    -- debug
    debug : out std_logic_vector(127 downto 0)
  );
end entity digital_reg_file;

architecture RTL of digital_reg_file is

  type regs32 is array (natural range <>) of std_logic_vector(31 downto 0);
  signal regs : regs32(31 downto 0)
  := (others => (others => '0'));

  -- Function for converting byte adresses to an index
  -- into the 32 bit register array.
  function ra (
    byte_addr : std_logic_vector(7 downto 0)
  ) return natural is
    variable ret : natural;
  begin
    ret := to_integer(unsigned(byte_addr(7 downto 2)));
    return ret;
  end ra;

  signal addr_reg  : std_logic_vector(12 downto 0);
  signal read_reg  : std_logic_vector(31 downto 0);
  signal write_reg : std_logic_vector(31 downto 0);
  signal write_en  : std_logic;

  --digital side
  signal matrix_out_addr_int : std_logic_vector(5 downto 0);
  signal matrix_load_int     : std_logic;
  signal mask_lower          : std_logic_vector(31 downto 0);
  signal mask_upper          : std_logic_vector(31 downto 0);
  signal inv_lower           : std_logic_vector(31 downto 0);
  signal inv_upper           : std_logic_vector(31 downto 0);
  signal vid_span_int        : std_logic_vector(7 downto 0);
  -- analoge side
  signal out_addr_int       : std_logic_vector(3 downto 0);
  signal ch_addr_int        : std_logic_vector(3 downto 0);
  signal gain_in_int        : std_logic_vector(4 downto 0);
  signal anna_matrix_wr_int : std_logic;

  --Shape gen 1 & 2
  signal pos_h_i_1   : std_logic_vector(8 downto 0);
  signal pos_v_i_1   : std_logic_vector(8 downto 0);
  signal zoom_h_i_1  : std_logic_vector(8 downto 0);
  signal zoom_v_i_1  : std_logic_vector(8 downto 0);
  signal circle_i_1  : std_logic_vector(8 downto 0);
  signal gear_i_1    : std_logic_vector(8 downto 0);
  signal lantern_i_1 : std_logic_vector(8 downto 0);
  signal fizz_i_1    : std_logic_vector(8 downto 0);
  signal pos_h_i_2   : std_logic_vector(8 downto 0);
  signal pos_v_i_2   : std_logic_vector(8 downto 0);
  signal zoom_h_i_2  : std_logic_vector(8 downto 0);
  signal zoom_v_i_2  : std_logic_vector(8 downto 0);
  signal circle_i_2  : std_logic_vector(8 downto 0);
  signal gear_i_2    : std_logic_vector(8 downto 0);
  signal lantern_i_2 : std_logic_vector(8 downto 0);
  signal fizz_i_2    : std_logic_vector(8 downto 0);
  -- noise gen
  signal noise_freq_i    : std_logic_vector(9 downto 0);
  signal slew_in_i       : std_logic_vector(2 downto 0);
  signal cycle_recycle_i : std_logic;
  -- color output levels
  signal y_level_i  : std_logic_vector(11 downto 0);
  signal cr_level_i : std_logic_vector(11 downto 0);
  signal cb_level_i : std_logic_vector(11 downto 0);

begin

  ---------------------------------------------------------------------------
  -- Register reads
  ---------------------------------------------------------------------------
  process (regs_clk)
  begin
    if rising_edge(regs_clk) then
      if regs_en = '0' then
        read_reg <= x"00000000";
      else
        read_reg <= regs(ra(regs_addr(7 downto 0)));
      end if;
    end if;
  end process;

  regs_rd_data <= read_reg;

  ---------------------------------------------------------------------------
  -- Register writes
  ---------------------------------------------------------------------------
  process (regs_clk)
  begin
    if rising_edge(regs_clk) then
      addr_reg  <= regs_addr;
      write_reg <= regs_wr_data;
      write_en  <= '0';
      if (regs_en = '1' and regs_wen(0) = '1') then
        write_en <= '1';
      end if;
    end if;
  end process;

  ---------------------------------------------------------------------------
  -- Assemble the register read array
  ---------------------------------------------------------------------------
  -- outgoing, so inputs to this block
  -- regs(ra(x"00")) <= xxxxxxxxxxxxxxxxxxxxx;  -- read only reg with the FPGA build number

  -- digital side
  regs(ra(x"04")) <= x"000000" & "00" & matrix_out_addr_int; -- this is the matrix output
  regs(ra(x"08")) <= x"000000" & "0000000" & matrix_load_int; -- load flag
  regs(ra(x"10")) <= mask_lower;
  regs(ra(x"14")) <= mask_upper;
  -- regs(ra(x"18")) <= xxxxxxxxxxxx; saved for future matrix expantion
  regs(ra(x"1C")) <= inv_lower; -- inverts the matrix inputs, lower 32
  regs(ra(x"20")) <= inv_upper; -- inverts the matrix inputs, upper 32
  regs(ra(x"24")) <= x"000000" & vid_span_int;

  -- analoge side matrix
  regs(ra(x"28")) <= x"000000" & "0000" & out_addr_int;
  regs(ra(x"2C")) <= x"000000" & "0000" & ch_addr_int;
  regs(ra(x"30")) <= x"000000" & "000" & gain_in_int;
  regs(ra(x"34")) <= x"000000" & "0000000" & anna_matrix_wr_int;

  -- shape gen 1 & 2
  regs(ra(x"3C")) <= x"0000" & pos_h_i_2 & pos_h_i_1;
  regs(ra(x"40")) <= x"0000" & pos_v_i_2 & pos_v_i_1;
  regs(ra(x"44")) <= x"0000" & zoom_h_i_2 & zoom_h_i_1;
  regs(ra(x"48")) <= x"0000" & zoom_v_i_2 & zoom_v_i_1;
  regs(ra(x"4C")) <= x"0000" & circle_i_2 & circle_i_1;
  regs(ra(x"50")) <= x"0000" & gear_i_2 & gear_i_1;
  regs(ra(x"54")) <= x"0000" & lantern_i_2 & lantern_i_1;
  regs(ra(x"5C")) <= x"0000" & fizz_i_2 & fizz_i_1;

  -- random gen
  regs(ra(x"60")) <= x"0000" & "00" & cycle_recycle_i & slew_in_i & noise_freq_i;

  -- output y,cr,cb levels
  regs(ra(x"64")) <= x"00" & cr_level_i & y_level_i;
  regs(ra(x"68")) <= x"00000" & cb_level_i;
  -- osc 1 & 2 (put side by side in reg like shape gen)
-- pitch
-- deviation
--amplitude/sync (concatinated)



  -- other
  regs(ra(x"90")) <= x"DEADBEEF"; --test reg 1
  -- ---------------------------------------------------------------------------
  -- Write MUX
  ---------------------------------------------------------------------------
  process (regs_clk)
  begin
    if rising_edge(regs_clk) then
      if (write_en = '1') then
        case addr_reg(7 downto 0) is
          when x"04" =>
            matrix_out_addr_int <= write_reg(5 downto 0);
          when x"08" =>
            matrix_load_int <= write_reg(0);
          when x"10" =>
            mask_lower <= write_reg;
          when x"14" =>
            mask_upper <= write_reg;
          when x"1C" =>
            inv_lower <= write_reg;
          when x"20" =>
            inv_lower <= write_reg;
          when x"24" =>
            vid_span_int <= write_reg(7 downto 0);
          when x"28" =>
            out_addr_int <= write_reg(3 downto 0);
          when x"2C" =>
            ch_addr_int <= write_reg(3 downto 0);
          when x"30" =>
            gain_in_int <= write_reg(4 downto 0);
          when x"34" =>
            anna_matrix_wr_int <= write_reg(0);
          when x"38" =>
            pos_h_i_1 <= write_reg(8 downto 0);
            pos_h_i_2 <= write_reg(17 downto 9);
          when x"3C" =>
            pos_v_i_1 <= write_reg(8 downto 0);
            pos_v_i_2 <= write_reg(17 downto 9);
          when x"40" =>
            pos_h_i_1 <= write_reg(8 downto 0);
            pos_h_i_2 <= write_reg(17 downto 9);
          when x"44" =>
            zoom_h_i_1 <= write_reg(8 downto 0);
            zoom_h_i_2 <= write_reg(17 downto 9);
          when x"48" =>
            zoom_v_i_1 <= write_reg(8 downto 0);
            zoom_v_i_2 <= write_reg(17 downto 9);
          when x"4C" =>
            circle_i_1 <= write_reg(8 downto 0);
            circle_i_2 <= write_reg(17 downto 9);
          when x"50" =>
            gear_i_1 <= write_reg(8 downto 0);
            gear_i_2 <= write_reg(17 downto 9);
          when x"54" =>
            lantern_i_1 <= write_reg(8 downto 0);
            lantern_i_2 <= write_reg(17 downto 9);
          when x"58" =>
            fizz_i_1 <= write_reg(8 downto 0);
            fizz_i_2 <= write_reg(17 downto 9);
          when x"60" =>
            noise_freq_i    <= write_reg(9 downto 0);
            slew_in_i       <= write_reg(12 downto 10);
            cycle_recycle_i <= write_reg(13);

            when x"64" =>
            y_level_i <= write_reg(11 downto 0);
            cr_level_i <= write_reg(23 downto 12);
            when x"68" =>
            cb_level_i <= write_reg(12 downto 0);



            -- do nothing
        end case;
      end if;
    end if;
  end process;

  ---------------------------------------------------------------------------
  -- Output signals
  ---------------------------------------------------------------------------
  matrix_out_addr <= matrix_out_addr_int;
  matrix_load     <= matrix_load_int;
  matrix_mask_out <= mask_upper & mask_lower;
  invert_matrix   <= inv_upper & inv_lower;
  vid_span        <= vid_span_int;
  out_addr        <= out_addr_int;
  ch_addr         <= ch_addr_int;
  gain_in         <= gain_in_int;

  anna_matrix_wr <= anna_matrix_wr_int;

  pos_h_1   <= pos_h_i_1;
  pos_v_1   <= pos_v_i_1;
  zoom_h_1  <= zoom_h_i_1;
  zoom_v_1  <= zoom_v_i_1;
  circle_1  <= circle_i_1;
  gear_1    <= gear_i_1;
  lantern_1 <= lantern_i_1;
  fizz_1    <= fizz_i_1;

  pos_h_2   <= pos_h_i_2;
  pos_v_2   <= pos_v_i_2;
  zoom_h_2  <= zoom_h_i_2;
  zoom_v_2  <= zoom_v_i_2;
  circle_2  <= circle_i_2;
  gear_2    <= gear_i_2;
  lantern_2 <= lantern_i_2;
  fizz_2    <= fizz_i_2;

  noise_freq    <= noise_freq_i;
  slew_in       <= slew_in_i;
  cycle_recycle <= cycle_recycle_i;

  y_level  <= y_level_i;
  cr_level <= cr_level_i;
  cb_level <= cb_level_i;

end RTL;