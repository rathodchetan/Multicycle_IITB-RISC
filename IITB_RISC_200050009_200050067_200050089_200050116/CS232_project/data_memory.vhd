library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

-- A 65536x16 single-port RAM in VHDL
entity data_memory is
	port(
	 RAM_ADDR: in std_logic_vector(15 downto 0);
	 RAM_DATA_IN: in std_logic_vector(15 downto 0); 
	 wr, rd: in std_logic;  
	 RAM_DATA_OUT: out std_logic_vector(15 downto 0) 
	);
end entity;

architecture data_mem_arch of data_memory is
	type RAM_ARRAY is array (0 to 65535 ) of std_logic_vector (15 downto 0);
	signal RAM: RAM_ARRAY :=( others => x"0000" ); 
begin
	process(wr,rd)
		begin
		 if(rd='1') then
			RAM_DATA_OUT <= RAM(to_integer(unsigned(RAM_ADDR)));
		 end if;
		 if(wr='1') then
			RAM(to_integer(unsigned(RAM_ADDR))) <= RAM_DATA_IN;
		 end if;		 
	end process;
end architecture;