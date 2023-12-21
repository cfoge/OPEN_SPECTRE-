----------------------------------------------------------------------------------
-- Engineer: Mike Field <hamster@snap.net.nz>
-- 
-- Description: Controller for the OV760 camera - transferes registers to the 
--              camera over an I2C like bus
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ov7670_controller is
    Port ( clk   : in    STD_LOGIC;
			  resend :in    STD_LOGIC;
			  config_finished : out std_logic;
           sioc  : out   STD_LOGIC;
           siod  : inout STD_LOGIC;
           reset : out   STD_LOGIC;
           pwdn  : out   STD_LOGIC;
			  xclk  : out   STD_LOGIC
);
end ov7670_controller;

architecture Behavioral of ov7670_controller is
	COMPONENT i3c2 GENERIC (
		clk_divide  : std_logic_vector(7 downto 0)
   );
	PORT(
		clk : IN std_logic;
		inst_data : IN std_logic_vector(8 downto 0);
		inputs : IN std_logic_vector(15 downto 0);    
		i2c_sda : INOUT std_logic;      
		inst_address : OUT std_logic_vector(9 downto 0);
		i2c_scl : OUT std_logic;
		outputs : OUT std_logic_vector(15 downto 0);
		reg_addr : OUT std_logic_vector(4 downto 0);
		reg_data : OUT std_logic_vector(7 downto 0);
		reg_write : OUT std_logic;
		error : OUT std_logic
		);
	END COMPONENT;

   signal inputs  : std_logic_vector(15 downto 0);
   signal outputs : std_logic_vector(15 downto 0);
   signal data    : std_logic_vector( 8 downto 0);
   signal address : std_logic_vector( 9 downto 0);
   signal sys_clk : std_logic;
begin
   inputs(0) <= resend;
   config_finished <= outputs(0);
	
	Inst_i3c2: i3c2 GENERIC MAP(
      clk_divide => std_logic_vector(to_unsigned(125,8)) 
   ) PORT MAP(
		clk => clk,
		inst_address => address ,
		inst_data => data,
		i2c_scl => sioc,
		i2c_sda => siod,
		inputs => inputs,
		outputs => outputs,
		reg_addr => open,
		reg_data => open,
		reg_write => open,
		error => open
	);

	reset <= '1'; 						-- Normal mode
	pwdn  <= '0'; 						-- Power device up
	xclk  <= sys_clk;
	
	process(clk)
	begin
		if rising_edge(clk) then
			sys_clk <= not sys_clk;
         
         case address is
           when "0000000000" => data <= "011100100";
           when "0000000001" => data <= "101000010";
           when "0000000010" => data <= "100010010";
           when "0000000011" => data <= "110000000";
           when "0000000100" => data <= "011111111";
           when "0000000101" => data <= "011101001";
           when "0000000110" => data <= "101000010";
           when "0000000111" => data <= "100010010";
           when "0000001000" => data <= "100000100";
           when "0000001001" => data <= "011111111";
           when "0000001010" => data <= "101000010";
           when "0000001011" => data <= "100010001";
           when "0000001100" => data <= "100000000";
           when "0000001101" => data <= "011111111";
           when "0000001110" => data <= "101000010";
           when "0000001111" => data <= "100001100";
           when "0000010000" => data <= "100000000";
           when "0000010001" => data <= "011111111";
           when "0000010010" => data <= "101000010";
           when "0000010011" => data <= "100111110";
           when "0000010100" => data <= "100000000";
           when "0000010101" => data <= "011111111";
           when "0000010110" => data <= "101000010";
           when "0000010111" => data <= "110001100";
           when "0000011000" => data <= "100000000";
           when "0000011001" => data <= "011111111";
           when "0000011010" => data <= "101000010";
           when "0000011011" => data <= "100000100";
           when "0000011100" => data <= "100000000";
           when "0000011101" => data <= "011111111";
           when "0000011110" => data <= "101000010";
           when "0000011111" => data <= "101000000";
           when "0000100000" => data <= "100010000";
           when "0000100001" => data <= "011111111";
           when "0000100010" => data <= "101000010";
           when "0000100011" => data <= "100111010";
           when "0000100100" => data <= "100000100";
           when "0000100101" => data <= "011111111";
           when "0000100110" => data <= "101000010";
           when "0000100111" => data <= "100010100";
           when "0000101000" => data <= "100111000";
           when "0000101001" => data <= "011111111";
           when "0000101010" => data <= "101000010";
           when "0000101011" => data <= "101001111";
           when "0000101100" => data <= "101000000";
           when "0000101101" => data <= "011111111";
           when "0000101110" => data <= "101000010";
           when "0000101111" => data <= "101010000";
           when "0000110000" => data <= "100110100";
           when "0000110001" => data <= "011111111";
           when "0000110010" => data <= "101000010";
           when "0000110011" => data <= "101010001";
           when "0000110100" => data <= "100001100";
           when "0000110101" => data <= "011111111";
           when "0000110110" => data <= "101000010";
           when "0000110111" => data <= "101010010";
           when "0000111000" => data <= "100010111";
           when "0000111001" => data <= "011111111";
           when "0000111010" => data <= "101000010";
           when "0000111011" => data <= "101010011";
           when "0000111100" => data <= "100101001";
           when "0000111101" => data <= "011111111";
           when "0000111110" => data <= "101000010";
           when "0000111111" => data <= "101010100";
           when "0001000000" => data <= "101000000";
           when "0001000001" => data <= "011111111";
           when "0001000010" => data <= "101000010";
           when "0001000011" => data <= "101011000";
           when "0001000100" => data <= "100011110";
           when "0001000101" => data <= "011111111";
           when "0001000110" => data <= "101000010";
           when "0001000111" => data <= "100111101";
           when "0001001000" => data <= "111000000";
           when "0001001001" => data <= "011111111";
           when "0001001010" => data <= "101000010";
           when "0001001011" => data <= "100010001";
           when "0001001100" => data <= "100000000";
           when "0001001101" => data <= "011111111";
           when "0001001110" => data <= "101000010";
           when "0001001111" => data <= "100010111";
           when "0001010000" => data <= "100010001";
           when "0001010001" => data <= "011111111";
           when "0001010010" => data <= "101000010";
           when "0001010011" => data <= "100011000";
           when "0001010100" => data <= "101100001";
           when "0001010101" => data <= "011111111";
           when "0001010110" => data <= "101000010";
           when "0001010111" => data <= "100110010";
           when "0001011000" => data <= "110100100";
           when "0001011001" => data <= "011111111";
           when "0001011010" => data <= "101000010";
           when "0001011011" => data <= "100011001";
           when "0001011100" => data <= "100000011";
           when "0001011101" => data <= "011111111";
           when "0001011110" => data <= "101000010";
           when "0001011111" => data <= "100011010";
           when "0001100000" => data <= "101111011";
           when "0001100001" => data <= "011111111";
           when "0001100010" => data <= "101000010";
           when "0001100011" => data <= "100000011";
           when "0001100100" => data <= "100001010";
           when "0001100101" => data <= "011111111";
           when "0001100110" => data <= "101000010";
           when "0001100111" => data <= "100001110";
           when "0001101000" => data <= "101100001";
           when "0001101001" => data <= "011111111";
           when "0001101010" => data <= "101000010";
           when "0001101011" => data <= "100001111";
           when "0001101100" => data <= "101001011";
           when "0001101101" => data <= "011111111";
           when "0001101110" => data <= "101000010";
           when "0001101111" => data <= "100010110";
           when "0001110000" => data <= "100000010";
           when "0001110001" => data <= "011111111";
           when "0001110010" => data <= "101000010";
           when "0001110011" => data <= "100011110";
           when "0001110100" => data <= "100110111";
           when "0001110101" => data <= "011111111";
           when "0001110110" => data <= "101000010";
           when "0001110111" => data <= "100100001";
           when "0001111000" => data <= "100000010";
           when "0001111001" => data <= "011111111";
           when "0001111010" => data <= "101000010";
           when "0001111011" => data <= "100100010";
           when "0001111100" => data <= "110010001";
           when "0001111101" => data <= "011111111";
           when "0001111110" => data <= "101000010";
           when "0001111111" => data <= "100101001";
           when "0010000000" => data <= "100000111";
           when "0010000001" => data <= "011111111";
           when "0010000010" => data <= "101000010";
           when "0010000011" => data <= "100110011";
           when "0010000100" => data <= "100001011";
           when "0010000101" => data <= "011111111";
           when "0010000110" => data <= "101000010";
           when "0010000111" => data <= "100110101";
           when "0010001000" => data <= "100001011";
           when "0010001001" => data <= "011111111";
           when "0010001010" => data <= "101000010";
           when "0010001011" => data <= "100110111";
           when "0010001100" => data <= "100011101";
           when "0010001101" => data <= "011111111";
           when "0010001110" => data <= "101000010";
           when "0010001111" => data <= "100111000";
           when "0010010000" => data <= "101110001";
           when "0010010001" => data <= "011111111";
           when "0010010010" => data <= "101000010";
           when "0010010011" => data <= "100111001";
           when "0010010100" => data <= "100101010";
           when "0010010101" => data <= "011111111";
           when "0010010110" => data <= "101000010";
           when "0010010111" => data <= "100111100";
           when "0010011000" => data <= "101111000";
           when "0010011001" => data <= "011111111";
           when "0010011010" => data <= "101000010";
           when "0010011011" => data <= "101001101";
           when "0010011100" => data <= "101000000";
           when "0010011101" => data <= "011111111";
           when "0010011110" => data <= "101000010";
           when "0010011111" => data <= "101001110";
           when "0010100000" => data <= "100100000";
           when "0010100001" => data <= "011111111";
           when "0010100010" => data <= "101000010";
           when "0010100011" => data <= "101101001";
           when "0010100100" => data <= "100000000";
           when "0010100101" => data <= "011111111";
           when "0010100110" => data <= "101000010";
           when "0010100111" => data <= "101101011";
           when "0010101000" => data <= "101001010";
           when "0010101001" => data <= "011111111";
           when "0010101010" => data <= "101000010";
           when "0010101011" => data <= "101110100";
           when "0010101100" => data <= "100010000";
           when "0010101101" => data <= "011111111";
           when "0010101110" => data <= "101000010";
           when "0010101111" => data <= "110001101";
           when "0010110000" => data <= "101001111";
           when "0010110001" => data <= "011111111";
           when "0010110010" => data <= "101000010";
           when "0010110011" => data <= "110001110";
           when "0010110100" => data <= "100000000";
           when "0010110101" => data <= "011111111";
           when "0010110110" => data <= "101000010";
           when "0010110111" => data <= "110001111";
           when "0010111000" => data <= "100000000";
           when "0010111001" => data <= "011111111";
           when "0010111010" => data <= "101000010";
           when "0010111011" => data <= "110010000";
           when "0010111100" => data <= "100000000";
           when "0010111101" => data <= "011111111";
           when "0010111110" => data <= "101000010";
           when "0010111111" => data <= "110010001";
           when "0011000000" => data <= "100000000";
           when "0011000001" => data <= "011111111";
           when "0011000010" => data <= "101000010";
           when "0011000011" => data <= "110010110";
           when "0011000100" => data <= "100000000";
           when "0011000101" => data <= "011111111";
           when "0011000110" => data <= "101000010";
           when "0011000111" => data <= "110011010";
           when "0011001000" => data <= "100000000";
           when "0011001001" => data <= "011111111";
           when "0011001010" => data <= "101000010";
           when "0011001011" => data <= "110110000";
           when "0011001100" => data <= "110000100";
           when "0011001101" => data <= "011111111";
           when "0011001110" => data <= "101000010";
           when "0011001111" => data <= "110110001";
           when "0011010000" => data <= "100001100";
           when "0011010001" => data <= "011111111";
           when "0011010010" => data <= "101000010";
           when "0011010011" => data <= "110110010";
           when "0011010100" => data <= "100001110";
           when "0011010101" => data <= "011111111";
           when "0011010110" => data <= "101000010";
           when "0011010111" => data <= "110110011";
           when "0011011000" => data <= "110000010";
           when "0011011001" => data <= "011111111";
           when "0011011010" => data <= "101000010";
           when "0011011011" => data <= "110111000";
           when "0011011100" => data <= "100001010";
           when "0011011101" => data <= "011111111";
           when "0011011110" => data <= "011111110";
           when "0011011111" => data <= "011111110";
           when "0011100000" => data <= "010000000";
           when "0011100001" => data <= "000000000";
           when "0011100010" => data <= "000011100";
           when others => data <= (others =>'0');
        end case;
		end if;
	end process;
end Behavioral;

