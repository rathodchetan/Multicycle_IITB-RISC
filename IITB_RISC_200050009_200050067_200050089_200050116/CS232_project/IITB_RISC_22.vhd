library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use work.array_type.all;

entity IITB_RISC_22 is
	port(
		clk,reset: in std_logic
	);
end entity;

architecture risc_arch of IITB_RISC_22 is
type Reg_bytes is array ( 7 downto 0) of std_logic_vector (15 downto 0);
signal output: Reg_bytes;
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
			C,Z: in std_logic;
			inst: in std_logic_vector(15 downto 0);
			T: out std_logic_vector(40 downto 0)
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
			output: out Reg_bytes
		);
	end component;
	
	component data_memory
		port(
		 RAM_ADDR: in std_logic_vector(15 downto 0);
		 RAM_DATA_IN: in std_logic_vector(15 downto 0); 
		 wr, rd: in std_logic;  
		 RAM_DATA_OUT: out std_logic_vector(15 downto 0) 
		);
	end component;
	
	component alu
		port(
			A, B: in std_logic_vector(15 downto 0);
			result: out std_logic_vector(15 downto 0);
			cin: in std_logic;
			sel: in std_logic_vector(1 downto 0);
			CY, Z: out std_logic
		);
	end component;
	
	signal out_ir,out_LS7,RAM_DATA_OUT: std_logic_vector(15 downto 0):= (others => '0');
	signal to_D3,to_T1,out_T1,to_T2,out_T2,to_T3,out_T3,to_T4,out_T4: std_logic_vector(15 downto 0):= (others => '0'); 
	signal alu2_B,alu2_C,alu3_B,alu3_C,alu4_A,alu4_B,alu4_C: std_logic_vector(15 downto 0):= (others => '0');
	signal zero_vec,to_rom,to_ir,to_pc: std_logic_vector(15 downto 0):= (others => '0');
	signal T: std_logic_vector(40 downto 0):= (others => '0');
	signal to_C,to_Z,C,Z: std_logic:= '0';
	signal alu2_sel,alu3_sel: std_logic_vector(1 downto 0):= (others => '0');
	signal zero,one: std_logic:= '0';
	signal to_A1,to_A2,to_A3: std_logic_vector(2 downto 0);
begin
		
	alu1 : alu
		port map(A => to_rom, B=>(15 downto 0 => '0'),
					result => to_T4, cin=>'1', sel=>"01");
					
	control_path_inst: control_path
		port map(reset=>reset,
					clk=>clk,
					C=>C, Z=>Z,
					inst=>out_ir,
					op_code=>out_ir(15 downto 12),
					T => T);
	
	alu2 : alu
		port map(A=>out_T1, B=>alu2_B,
					result=> alu2_C, cin=>'0', sel=>alu2_sel, CY=>to_C, Z=>to_Z);
alu2_sel <= "11" when(out_ir(15 downto 12) = "0010") else
				"01";
alu2_B <= (15 downto 6 => '0') & out_ir(5 downto 0) when(out_ir(15 downto 12) = "0000") else
			 out_T2 when(out_ir(15 downto 12) = "0010") else
			 std_logic_vector(shift_left(unsigned(out_T2), 1)) when(out_ir(1 downto 0) = "11") else
			 out_T2;
	process(to_C, to_Z)
	begin
		if out_ir(15 downto 12) = "0000" or out_ir(15 downto 12) = "0001" or out_ir(15 downto 12) = "0010" then
			C <= to_C; Z <= to_Z;
		end if;
	end process;
	
	
	alu3 : alu
		port map(A=>out_T1, B=>alu3_B,
					result=> alu3_C, cin=>'0', sel=>alu3_sel);
alu3_B <= out_T2 when(out_ir(15 downto 12) = "1000") else
			 (15 downto 6 => '0') & out_ir(5 downto 0);
alu3_sel <= "10" when(out_ir(15 downto 12) = "1000") else
				"01";
				
	alu4 : alu
		port map(A => alu4_A, B => alu4_B,
					result => alu4_C, cin=>'0', sel=>"01");
alu4_A <= out_T1 when(out_ir(15 downto 12) = "1011") else
			 to_rom; 
alu4_B <= (15 downto 9 => '0') & out_ir(8 downto 0) when(out_ir(15 downto 12) = "1011") else					
			 (15 downto 6 => '0') & out_ir(5 downto 0);
to_pc <= out_T4 when(T(32 downto 31) = "01") else
			to_T2 when(T(32 downto 31) = "11") else
			to_rom when(T(32 downto 31) = "00") else
			alu4_C when(out_ir(15 downto 12) = "1001") else
			alu4_C when(out_ir(15 downto 12) = "1011") else
			alu4_C when(to_integer(unsigned(alu3_C)) = 0) else
			to_rom;

	PC : temp_reg
		port map(dataIn=>to_pc,
					wr_l=>T(1),
					rd_l=>T(0),
					dataOut=>to_rom);					
					
	ROM_inst: ROM
		port map(ROM_Addr=>to_rom,
					ROM_Data_Out=>to_ir);
	IR : temp_reg
		port map(dataIn=>to_ir,
					wr_l=>T(3),
					rd_l=>T(2),
					dataOut=>out_ir);		
					
to_D3 <= out_T3 when(T(17 downto 16) = "10") else
			out_LS7 when(T(17 downto 16) = "01") else
			out_T4;
out_LS7 <= out_ir(8 downto 0) & (6 downto 0 => '0');
to_A1 <= out_ir(11 downto 9) when (T(19 downto 18) = "01") else
			out_ir(8 downto 6);
to_A2 <=	out_ir(8 downto 6) when (T(21 downto 20) = "01") else
			out_ir(11 downto 9);
to_A3 <=	out_ir(5 downto 3) when (T(23 downto 22) = "01") else
			out_ir(8 downto 6) when (T(23 downto 22) = "10") else
			out_ir(11 downto 9);
	RF : reg_file
		port map(D3=>to_D3,
				A1=>to_A1, A2=>to_A2, A3=>to_A3,
				Rd_en=>T(4), 
				Wr_en=>T(5),                                                                                                
				D1=>to_T1, D2=>to_T2,
				output=>output);
  ---- to_T1 and D1 are connected                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
  ---- to_T2 and D2 are connected		
  ---- to_T4 and alu1-C are connected
to_T3 <= alu2_C when(T(30 downto 29) = "01") else
			alu3_C when(T(30 downto 29) = "10") else
			RAM_DATA_OUT;

	T1 : temp_reg	
		port map(dataIn=>to_T1,
					dataOut=>out_T1,
					wr_l=>T(9), 
					rd_l=>T(8));
	T2 : temp_reg	
		port map(dataIn=>to_T2,
					dataOut=>out_T2,
					wr_l=>T(11), 
					rd_l=>T(10));
	T3 : temp_reg	
		port map(dataIn=>to_T3,
					dataOut=>out_T3,
					wr_l=>T(13), 
					rd_l=>T(12));
	T4 : temp_reg	
		port map(dataIn=>to_T4,
					dataOut=>out_T4,
					wr_l=>T(15), 
					rd_l=>T(14));
				------- out_T2 => RAM_DATA_IN
				------- out_T3 => RAM_ADDR
	DATA_MEM : data_memory
		port map(RAM_ADDR =>out_T3 ,
					RAM_DATA_IN =>out_T2 ,
					wr =>T(7) ,
					rd => T(6),
					RAM_DATA_OUT => RAM_DATA_OUT);
					
end architecture;