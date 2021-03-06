library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ROM is
	port( 
		ROM_Addr: in std_logic_vector( 15 downto 0); 
		ROM_Data_Out: out std_logic_vector (15 downto 0)
	);
end entity;

architecture ROM_arch of ROM is

	type Memory_bytes is array ( 1999 downto 0) of std_logic_vector (15 downto 0);
	signal ROM_Memory: Memory_bytes :=(others => x"0000");

begin
	ROM_Data_Out <= ROM_Memory(to_integer(unsigned(ROM_Addr) ));
end architecture;