library IEEE;
use IEEE.std_logic_1164.all;

entity IITB-RISC-22 is
	port(
		clk,rst: in std_logic;
		output: out array ( 7 downto 0) of std_logic_vector (15 downto 0)
	);
end entity;

architecture risc_arch of IITB-RISC-22 is
	
	component temp_reg
		port(
			dataIn: in std_logic_vector (15 downto 0);
         data: inout std_logic_vector (15 downto 0);
         dataOut: out std_logic_vector (15 downto 0);
         wr_l, rd_l: in std_logic
		);
	end component;
	
	component control_path
		port(
			reset, clk: in std_logic; 
			op_code: in std_logic_vector(3 downto 0);
			T: out std_logic_vector(15 downto 0);
		);
	end component;
	
	component ROM
		port(
			ROM_Addr: in std_logic_vector( 15 downto 0); 
			ROM_Data_Out: out std_logic_vector (15 downto 0)
		);
	end component;
	
	component reg_file
		port(
			D3: in std_logic_vector( 15 downto 0); 
			A1, A2, A3: in std_logic_vector( 2 downto 0);
			Rd_en, Wr_en: in std_logic; 
			D1, D2: out std_logic_vector (15 downto 0);
			output: out array ( 7 downto 0) of std_logic_vector (15 downto 0)
		);
	end component;
	
	signal T,to_T1,out_T1, to_T2,out_T2, out_ir,to_pc,to_rom,to_ir: std_logic_vector(15 downto 0);
	signal T1_w,T1_r, T2_w,T2_r, pc_w,pc_r, ir_w,ir_r, rf_w,rf_r: std_logic;

begin

to_pc <= 

	PC : temp_reg
		port map(to_pc=>dataIn,
					T(1)=>wr_l,
					T(0)=>rd_l,
					dataOut=>to_rom);
	ROM_inst: ROM
		port map(to_rom=>ROM_Addr,
					ROM_Data_Out=>to_ir);
	IR : temp_reg
		port map(to_ir=>dataIn,
					T(3)=>wr_l,
					T(2)=>rd_l,
					dataOut=>out_ir);	
					
	control_path_inst: control_path
		port map(reset=>reset,
					clk=>clk,
					out_ir(15 downto 12)=>op_code,
					T => T);	
					
to_D3 <= out_T3 when(T(17 downto 16) = "10") else
			out_LS7 when(T(17 downto 16) = "01") else
			out_T4 when(T(17 downto 16) = "11");
			
to_A1 <= out_ir(11 downto 9) when (T(19 downto 18) = "01") else
			out_ir(8 downto 6) when (T(19 downto 18) = "10"); 
			
to_A2 <= out_ir(8 downto 6) when (T(21 downto 20) = "01") else
			out_ir(11 downto 9) when (T(21 downto 20) = "10");
			
to_A3 <= out_ir(5 downto 3) when (T(23 downto 22) = "01") else
			out_ir(8 downto 6) when (T(23 downto 22) = "10") else
			out_ir(11 downto 9) when (T(23 downto 22) = "11");
			
	RF : reg_file
		port map(to_D3=>D3,
				to_A1=>A1, to_A2=>A2, to_A3=>A3,
				T(4)=>Re_en, T(5)=>Wr_en,                                                                                                
				D1=>to_T1, D2=>to_T2
				output=>output);
	T1 : temp_reg	
		port map(to_T1=>dataIn,
					dataOut=>out_T1,
					T(9)=>wr_l, 
					T(8)=>rd_l);
	T2 : temp_reg	
		port map(to_T2=>dataIn,
					dataOut=>out_T2,
					T(11)=>wr_l, 
					T(10)=>rd_l);
	T3 : temp_reg	
		port map(to_T3=>dataIn,
					dataOut=>out_T3,
					T(13)=>wr_l, 
					T(12)=>rd_l);
	T4 : temp_reg	
		port map(to_T4=>dataIn,
					dataOut=>out_T4,
					T(15)=>wr_l, 
					T(14)=>rd_l);
	
	

end architecture;