------------------------------------------------------------------------

-- this module is like a register sniffer, i like to think of it like a dog. it records the writes to both matrixes as ram so that they can be read back, because the way that the matrixes are setup they cant store their state or read it back
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity reg_sniffer is
  Port ( 
    clk     : in std_logic := '0';
    rst     : in std_logic := '0';
    read_ram : in std_logic := '0';
    read_address : in STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    ram_data_out : out STD_LOGIC_VECTOR(63 downto 0);
    matrix_out_addr : in std_logic_vector(5 downto 0) := (others => '0');
    matrix_mask_out : in std_logic_vector(63 downto 0) := (others => '0'); -- the pin settings for a single oputput
    matrix_load     : in std_logic := '0';
    out_addr       : in std_logic_vector(7 downto 0) := (others => '0');
    ch_addr        : in std_logic_vector(7 downto 0) := (others => '0');
    gain_in        : in std_logic_vector(4 downto 0) := (others => '0');
    anna_matrix_wr : in std_logic := '0'
  );
end reg_sniffer;

architecture Behavioral of reg_sniffer is

signal matrix_wr_detected : std_logic := '0';
signal address_i :  STD_LOGIC_VECTOR(7 downto 0);
signal data_in_i :  STD_LOGIC_VECTOR(63 downto 0);
signal data_out_i :  STD_LOGIC_VECTOR(63 downto 0) := (others => '0');
signal address_ann :  integer;


begin

address_ann <= to_integer(unsigned(out_addr(6 downto 0) & ch_addr(4 downto 0))) + 64; -- need to check these widths are correct

 process (clk)
  begin
    if rising_edge(clk) then -- kinda fake state mec, does it need more or a traditional state mec?
      if read_ram = '1' then
       address_i <= read_address;
       ram_data_out <= data_out_i;
       matrix_wr_detected <= '0';
      elsif matrix_load = '1' then
        matrix_wr_detected <= '1';
        address_i <=  "00" & matrix_out_addr;
        data_in_i <= matrix_mask_out;
      elsif anna_matrix_wr = '1' then
        matrix_wr_detected <= '1';
        address_i <= std_logic_vector(to_unsigned(address_ann, address_i'length));
        data_in_i <= x"00000000000000" & "000" & gain_in;
      else
        matrix_wr_detected <= '0';
      end if;
    end if;
  end process;


ram_80x64_i : entity work.ram_80x64  -- its actualy 128 deep
port map (
clk             => clk, --in width = std_logic
reset           => rst, --in width = std_logic
write_enable    => matrix_wr_detected, --in width = std_logic
address         => address_i, --in width = std_logic_vector
data_in         => data_in_i, --in width = std_logic_vector
data_out        => data_out_i --out width = std_logic_vector
);


end Behavioral;
