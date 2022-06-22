library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--library work;
--use work.add.all;

entity alu is
		port(
			A, B: in std_logic_vector(15 downto 0);
			result: out std_logic_vector(15 downto 0);
			cin: in std_logic;
			sel: in std_logic_vector(1 downto 0);
			CY, Z: out std_logic
		);
end entity;

architecture alu_arch of alu is
	component adder
		port(
			x_in : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			y_in : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			carry_in : IN STD_LOGIC;
			sum : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			carry_out : OUT STD_LOGIC
		);
	 end component;
	
	signal carry1,carry2: std_logic;
	signal ans,res1,res2,res3,flipB: std_logic_vector(15 downto 0);
	
begin
flipB <= not B;
	instadd: adder
		port map(x_in=>A,y_in=>B,carry_in=>cin,sum=>res1,carry_out=>carry1);
	instSub: adder
		port map(x_in=>A,y_in=>flipB,carry_in=>cin,sum=>res2,carry_out=>carry2);
res3 <= A nand B;		

----- 1:add, 2:sub, 3:nand
ans <= res1 when(sel = "01") else
			 res2 when(sel = "10") else
			 res3;
result <= ans;
Z <= '1' when(to_integer(unsigned(ans)) = 0) else '0';

	process(sel,A,B,cin)
	begin
		if (sel = "01") then
			CY <= carry1;
		end if;
	end process;
	
end architecture;	
