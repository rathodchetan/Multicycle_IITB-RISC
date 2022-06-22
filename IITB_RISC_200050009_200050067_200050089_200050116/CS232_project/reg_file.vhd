library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

package array_type is
type Reg_bytes is array ( 7 downto 0) of std_logic_vector (15 downto 0);
end package array_type;

library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.array_type.all;

entity Reg_file is
	port( 
		D3: in std_logic_vector( 15 downto 0); 
		A1, A2, A3: in std_logic_vector( 2 downto 0);
		Rd_en, Wr_en: in std_logic; 
		D1, D2: out std_logic_vector (15 downto 0);
		output: out Reg_bytes
	);
end entity;

architecture Reg_file_arch of Reg_file is

	--type Reg_bytes is array ( 7 downto 0) of std_logic_vector (15 downto 0);
	signal Regs: Reg_bytes :=(others => x"0000");

begin
output <= Regs;
   process (Rd_en, Wr_en) is
	begin
		if Rd_en = '1' then
			D1 <= Regs(to_integer(unsigned(A1)));
			D2 <= Regs(to_integer(unsigned(A2)));
		end if;
		if Wr_en = '1' then
			Regs(to_integer(unsigned(A3))) <= D3; 
		end if;
    end process;

end architecture;