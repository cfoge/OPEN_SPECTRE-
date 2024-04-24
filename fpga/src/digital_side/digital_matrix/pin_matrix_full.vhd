----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.01.2023 15:46:15
-- Design Name: 
-- Module Name: pin_matrix_full - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pin_matrix_full is
generic (
    x_in : integer :=8;
    y_out : integer := 8
);
port
(
    clk      :in    STD_LOGIC;
    wr       :in    STD_LOGIC;
    Data_In  :in    std_logic_vector((x_in * 8) - 1 downto 0);
    en       :in    std_logic_vector(x_in -1 downto 0);
    mux_sel_t  :in    std_logic_vector((x_in * 3)-1 downto 0); -- remove t
    dmux_sel_t :in    std_logic_vector((y_out * 3)-1 downto 0); --remve t
    en_sel   :in    std_logic_vector(positive(ceil(log2(real(x_in)))) downto 0); --this is ugly, i should fix it
    Data_out :out   std_logic_vector((y_out * 8)-1 downto 0)
    
);
end pin_matrix_full;

architecture Behavioral of pin_matrix_full is

type en_array is array (0 to y_out-1) of std_logic_vector(x_in-1 downto 0);
signal en_arr_data : en_array;


signal matrix_in : std_logic_vector (x_in -1 downto 0);
signal matrix_out : std_logic_vector (y_out -1 downto 0);

------ vio signal
    signal mux_sel  :   std_logic_vector((x_in * 3)-1 downto 0);
    signal dmux_sel :   std_logic_vector((y_out * 3)-1 downto 0);
    signal probe_in0 :  STD_LOGIC_VECTOR(0 DOWNTO 0);
    signal probe_out0 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal probe_out1 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal   probe_out2 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal   probe_out3 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal   probe_out4 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal   probe_out5 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal   probe_out6 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal   probe_out7 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal   probe_out8 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal   probe_out9 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal  probe_out10 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal   probe_out11 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal   probe_out12 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal   probe_out13 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal   probe_out14 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal  probe_out15 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal  probe_out16 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal  probe_out17 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal   probe_out18 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal  probe_out19 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal    probe_out20 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal  probe_out21 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal  probe_out22 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal   probe_out23 :  STD_LOGIC_VECTOR(7 DOWNTO 0);

COMPONENT vio_0
  PORT (
    clk : IN STD_LOGIC;
    probe_in0 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe_out0 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    probe_out1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    probe_out2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    probe_out3 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    probe_out4 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    probe_out5 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    probe_out6 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    probe_out7 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    probe_out8 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    probe_out9 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    probe_out10 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    probe_out11 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    probe_out12 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    probe_out13 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    probe_out14 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    probe_out15 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    probe_out16 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_out17 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_out18 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_out19 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_out20 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_out21 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_out22 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_out23 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------


begin

--------------------vio to test drive matix

vio_matrix : vio_0
  PORT MAP (
    clk => clk,
    probe_in0 => probe_in0,
    probe_out0 => probe_out0,
    probe_out1 => probe_out1,
    probe_out2 => probe_out2,
    probe_out3 => probe_out3,
    probe_out4 => probe_out4,
    probe_out5 => probe_out5,
    probe_out6 => probe_out6,
    probe_out7 => probe_out7,
    probe_out8 => probe_out8,
    probe_out9 => probe_out9,
    probe_out10 => probe_out10,
    probe_out11 => probe_out11,
    probe_out12 => probe_out12,
    probe_out13 => probe_out13,
    probe_out14 => probe_out14,
    probe_out15 => probe_out15,
    probe_out16 => probe_out16,
    probe_out17 => probe_out17,
    probe_out18 => probe_out18,
    probe_out19 => probe_out19,
    probe_out20 => probe_out20,
    probe_out21 => probe_out21,
    probe_out22 => probe_out22,
    probe_out23 => probe_out23
  );

    mux_sel <= probe_out0 & probe_out1 & probe_out2 & probe_out3 & probe_out4 & probe_out5 & probe_out6 & probe_out7;
    dmux_sel <= probe_out8 & probe_out9 & probe_out10 & probe_out11 & probe_out12 & probe_out13 & probe_out14 & probe_out15;
              en_arr_data(0) <= probe_out16;
             en_arr_data(1) <= probe_out16;
              en_arr_data(2) <= probe_out17;
               en_arr_data(3) <= probe_out18;
             en_arr_data(4) <= probe_out19;
              en_arr_data(5) <= probe_out20;
             en_arr_data(6) <= probe_out21;
              en_arr_data(7) <= probe_out22;

----------------------------------------

  gen_code_matrix:
  for index in 0 to y_out-1 generate
    begin
      row_inst : entity work.pin_matrix_n
      generic map ( width=>x_in-1)
      port map (Data_In=>matrix_in, en=>en_arr_data(index), Data_out => matrix_out(index));
  end generate;
  
    gen_code_mux:
  for index in 0 to (x_in-1) generate
    begin
      mux_inst : entity work.mux_8_to_1
      port map (data=>Data_In(((index + 1) * 8)-1 downto (index * 8)), sel=>mux_sel(((index+1) * 3)-1 downto (index * 3)), mux_out => matrix_in(index));  

      end generate;
  
    gen_code_demux:
  for index in 0 to (y_out-1) generate
    begin
      demux_inst : entity work.demux_1_to_8
      port map (data=>matrix_out(index), sel=>dmux_sel(((index+1) * 3)-1 downto (index * 3)), demux_out => Data_out( ((index + 1) * 8)-1 downto (index * 8) ));
  end generate;

--need logic for seting the enable signals
--process(clk)
--    begin
--        if rising_edge(clk) then
--            if wr = '1' then
--                case en_sel is
--                when "000" => en_arr_data(0) <= en;
--                when "001" => en_arr_data(1) <= en;
--                when "010" => en_arr_data(2) <= en;
--                when "011" => en_arr_data(3) <= en;
--                when "100" => en_arr_data(4) <= en;
--                when "101" => en_arr_data(5) <= en;
--                when "110" => en_arr_data(6) <= en;
--                when "111" => en_arr_data(7) <= en;
--                end case;
--           end if;
--        end if;
--    end process;

end Behavioral;
