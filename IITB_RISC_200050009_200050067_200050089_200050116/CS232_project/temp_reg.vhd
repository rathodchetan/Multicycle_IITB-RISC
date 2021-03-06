library ieee;
use ieee.std_logic_1164.all;

entity temp_reg is
     port (dataIn: in std_logic_vector (15 downto 0);
           data: inout std_logic_vector (15 downto 0);
           dataOut: out std_logic_vector (15 downto 0);
           wr_l, rd_l: in std_logic);
end entity;

architecture temp_reg_arch of temp_reg is
begin
    process (wr_l, rd_l) is
     begin
			if rd_l='1' then dataOut<=data;
			end if;
			if wr_l='1' then data<=dataIn;
         end if; 
         
    end process;
end architecture;