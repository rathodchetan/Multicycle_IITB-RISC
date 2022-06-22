library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity control_path is
	port(
			reset, clk: in std_logic; 
			op_code: in std_logic_vector(3 downto 0);
			C,Z: in std_logic;
			inst: in std_logic_vector(15 downto 0);
			T: out std_logic_vector(40 downto 0)
	);
end entity;

architecture fsm of control_path is
	type fsm_state is (S0,S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16,S17,S18,S19,S20,S21);
	signal Q, nQ: fsm_state := S0;
begin
	
	process(clk, nQ)
	begin
		if rising_edge(clk) then
			Q <= nQ;
		end if;
	end process;		
	
	process(op_code, Q)
	begin
		T <= (others => '0');
		case Q is
			when S0 =>
				T(0) <= '1';
				T(3) <= '1';
				T(15) <= '1';
				
			when S1 =>
				T(2) <= '1';
				
			when S2 =>
				T(1) <= '1';
				T(2) <= '1';
				T(4) <= '1';
				T(9) <= '1';
				T(11) <= '1';
				T(14) <= '1';
				T(18) <= '1';
				T(20) <= '1';
				T(31) <= '1';
				
			when S3 =>
				T(2) <= '1';
				T(8) <= '1';
				T(10) <= '1';
				T(13) <= '1';
				T(24) <= '1';	T(26) <= '1';
				T(28) <= '1';
				T(29) <= '1';
			
			when S4 =>
				T(2) <= '1';
				T(5) <= '1';
				T(12) <= '1';
				T(17) <= '1';
				T(22) <= '1';
				T(25) <= '1'; T(27) <= '1';
				
			when S5 =>
			
				T(1) <= '1';
				T(2) <= '1';
				T(4) <= '1';
				T(9) <= '1';
				T(14) <= '1';
				T(18) <= '1';
				T(31) <= '1';
			
			when S6 =>
				T(2) <= '1';
				T(8) <= '1';
				T(13) <= '1';
				T(24) <= '1';	T(26) <= '1';
				T(28) <= '1';
				T(29) <= '1';
				
			when S7 =>
				T(2) <= '1';
				T(5) <= '1';
				T(12) <= '1';
				T(17) <= '1';
				T(23) <= '1';
				T(25) <= '1'; T(27) <= '1';
				
			when S8 =>
				T(1) <= '1';
				T(2) <= '1';
				T(4) <= '1';
				T(9) <= '1';
				T(14) <= '1';
				T(19) <= '1';
				T(31) <= '1';
			
			when S9 =>
				T(2) <= '1';
				T(8) <= '1';
				T(13) <= '1';
				T(30) <= '1';
			
			when S10 =>
				T(6) <= '1';
				T(12) <= '1';
				T(13) <= '1';
				T(29) <= '1';
				T(30) <= '1';
			
			when S11 =>
				T(2) <= '1';
				T(5) <= '1';
				T(12) <= '1';
				T(17) <= '1';
				T(23) <= '1'; T(22) <= '1';
			
			when S12 =>
				T(2) <= '1';
				T(11) <= '1';
				T(21) <= '1';
			
			when S13 =>
				T(7) <= '1';
				T(10) <= '1';
				T(12) <= '1';
			
			when S14 =>
				T(1) <= '1';
				T(2) <= '1';
				T(5) <= '1';
				T(14) <= '1';
				T(16) <= '1';
				T(23) <= '1'; T(22) <= '1';
				T(31) <= '1';
				
			when S15 =>
				T(0) <= '1';
				T(1) <= '1';
				T(2) <= '1';
				T(5) <= '1';
				T(14) <= '1';
				T(16) <= '1'; T(17) <= '1';
				T(23) <= '1'; T(22) <= '1';
				T(32) <= '1';
			
			when S16 =>
				T(2) <= '1';
				T(5) <= '1';
				T(1) <= '1';
				T(4) <= '1';
				T(14) <= '1';
				T(16) <= '1'; T(17) <= '1';
				T(20) <= '1';
				T(23) <= '1'; T(22) <= '1';
				T(31) <= '1'; T(32) <= '1';
			
			when S17 =>	
				T(2) <= '1';
				T(4) <= '1';
				T(9) <= '1';
				T(18) <= '1';
				
			when S18 =>
				T(1) <= '1';
				T(2) <= '1';
				T(8) <= '1';
				T(32) <= '1';
				
			when S19 =>
				T(2) <= '1';
				T(4) <= '1';
				T(9) <= '1';
				T(11) <= '1';
				T(18) <= '1';
				T(20) <= '1';
			
			when S20 =>
				T(2) <= '1';
				T(8) <= '1';
				T(10) <= '1';
				T(13) <= '1';
				T(30) <= '1';
			
			when S21 =>
				T(0) <= '1';
				T(2) <= '1';
				T(12) <= '1';
				T(32) <= '1';
			
			when others =>
			
		end case;
	end process;
	
	process(op_code, reset, Q)
	begin
		if (reset = '1') then
			nQ <= S0;
		else
			case Q is
				when S0 => 
					nQ <= S1;
				
				when S1 => 
					case op_code is
						when "0001" => nQ <= S2;
						when "0000" => nQ <= S5;
						when "0010" => nQ <= S2;
						when "0100" =>	nQ <= S14;
						when "0101" => nQ <= S8;
						when "0111" => nQ <= S8;
						when "1001" => nQ <= S15;
						when "1010" => nQ <= S16;
						when "1011" => nQ <= S17;
						when "1000" => nQ <= S19;
						
						when others =>	
					end case;
				
				when S2 => 
					if inst(1 downto 0) = "10" then
						if C='1' then
							nQ <= S3;
						else
							nQ <= S0;
						end if;
					elsif inst(1 downto 0) = "01" then
						if Z='1' then
							nQ <= S3;
						else
							nQ <= S0;
						end if;
					else
						nQ <= S3;
					end if;
					
				when S3 => nQ <= S4;
				when S4 => nQ <= S0;
				
				when S5 => nQ <= S6;
				when S6 => nQ <= S7;
				when S7 => nQ <= S0;
				
				when S8 => nQ <= S9;
				when S9 => 
						case op_code is
						when "0111" => nQ <= S12;
						when "0101" => nQ <= S10;
						
						when others =>	
					end case;
				when S10 => nQ <= S11;
				when S11 => nQ <= S0;
				
				when S12 => nQ <= S13;
				when S13 => nQ <= S0;
				
				when S14 => nQ <= S0;
				
				when S15 => nQ <= S0;
				
				when S16 => nQ <= S0;
				
				when S17 => nQ <= S18;
				when S18 => nQ <= S0;
				
				when S19 => nQ <= S20;
				when S20 => nQ <= S21;
				when S21 => nQ <= S0;
			end case;
				
		end if;
	end process;
	
end architecture;