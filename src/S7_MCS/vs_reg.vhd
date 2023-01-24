
---------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vs_reg is
  port (
    -- clock/reset
    regs_rst         : in  std_logic;
    regs_clk         : in  std_logic;
    -- RAM interface
    regs_addr        : in  std_logic_vector(15 downto 0);
    regs_en          : in  std_logic;
    regs_we          : in  std_logic_vector(3 downto 0);
    regs_wr_data     : in  std_logic_vector(31 downto 0);
    regs_rd_data     : out std_logic_vector(31 downto 0);
    -- HW signals
    video_format     : in  std_logic_vector(4 downto 0);
    revid            : in  std_logic_vector(7 downto 0);
    revid_valid      : in  std_logic;
    temp             : in  std_logic_vector(11 downto 0);
    ddr_calib        : in  std_logic_vector(7 downto 0);
    pll_calib        : in  std_logic_vector(7 downto 0);
    clk_sel          : in  std_logic_vector(3 downto 0);
    frequency        : in  std_logic_vector(23 downto 0);
    
    freq_1           : out  std_logic_vector(9 downto 0);
    phase_1           : out  std_logic_vector(9 downto 0);
    amp_1            : out  std_logic_vector(9 downto 0)
   
    );
end entity vs_reg;

architecture RTL of vs_reg is

  type regs32 is array (natural range <>) of std_logic_vector(31 downto 0);
  signal regs                           : regs32(63 downto 0) := (others => (others => '0'));
  signal addr_reg                       : std_logic_vector(11 downto 0);
  signal read_reg                       : std_logic_vector(31 downto 0);
  signal write_reg                      : std_logic_vector(31 downto 0);
  signal write_en                       : std_logic;

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

  signal test_data_int        : std_logic_vector(31 downto 0) := x"DEADBEEF";


begin

  ---------------------------------------------------------------------------
  -- Register reads
  ---------------------------------------------------------------------------
  process(regs_clk)
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

  regs(ra(x"00")) <= x"000000"  & "000" & video_format;
  regs(ra(x"04")) <= x"00000" & "000" & revid_valid & revid;
  regs(ra(x"08")) <= x"00000" & temp;
  regs(ra(x"0C")) <= x"0000" & pll_calib & ddr_calib;
  regs(ra(x"10")) <= x"0" & clk_sel & frequency;
  regs(ra(x"14")) <= (others => '0');
  

  ---------------------------------------------------------------------------
  -- Register writes
  ---------------------------------------------------------------------------
  process(regs_clk)
  begin
    if rising_edge(regs_clk) then
      addr_reg   <= regs_addr(11 downto 0);
      write_reg  <= regs_wr_data;
      write_en   <= '0';
      if (regs_en = '1' and regs_we(0) = '1') then
        write_en   <= '1';
      end if;
    end if;
  end process;

  process(regs_clk)
  begin
    if rising_edge(regs_clk) then
      if write_en='1' then
        case addr_reg(7 downto 0) is
          when x"20"  => freq_1       <= write_reg(31 downto 0); -- use range to fit data size
          when x"24"  => phase_1      <= write_reg(31 downto 0); -- use range to fit data size
          when x"28"  => amp_1        <= write_reg(31 downto 0); -- use range to fit data size

          when others =>
        end case;
      end if;
    end if;
  end process;

  ---------------------------------------------------------------------------


end RTL;


