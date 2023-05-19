library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;



Entity ALU is
	   PORT (Read_Data1, Read_Data2: IN std_logic_vector (15 downto 0); 
	         FUNC: IN std_logic_vector (2 downto 0);
			 ALU_en: IN std_logic;
            ALU_OUT: OUT std_logic_vector (15 downto 0);
		 	ZF_ALU, CF_ALU, NF_ALU: OUT std_logic);
		 

END ALU;


Architecture my_ALU of ALU is

component full_adder is

      port(a,b : IN std_logic_vector (15 downto 0);
		cin: IN std_logic;
		c: out std_logic_vector (15 downto 0);
		cout: out std_logic);
		
end component;



component OR_GATE is
    Port ( input_data : in  STD_LOGIC_VECTOR (15 downto 0);
           output : out  STD_LOGIC);
end component;
		
	 signal comp, operand2_data: std_logic_vector (15 downto 0);
	 signal adder_out:  std_logic_vector (15 downto 0);
	 signal carry_out: std_logic; 
	 signal result: std_logic_vector (15 downto 0);
	 signal result_carry_out, operandcin: std_logic;
	 signal or_result: std_logic;
BEGIN


comp <= not Read_Data2;

-- MUX to choose second operand for FULL ADDER
operand2_data <= Read_Data2 when func = "000" else -- IADD
Read_Data2 when func = "001" else -- ADD
comp when func ="010" else -- SUB
"0000000000000001" when func ="110" else -- INC
x"FFFE"; -- DEC 

-- MUX to choose cin operand for FULL ADDER
operandcin <= '0' when func = "000" else -- IADD
'0' when func = "001" else -- ADD
'1' when func ="010" else -- SUB
'0' when func ="110" else -- INC
'1' when func ="111" -- DEC 
else '0';

adder: full_adder port map (Read_Data1, operand2_data, operandcin, adder_out, carry_out);

-- For zero flag
ORING: OR_GATE port map (result, or_result);

-- MUX to choose result
result <= adder_out when func = "000" else -- IADD
adder_out when func = "001" else -- ADD
adder_out when func = "010" else -- SUB
Read_Data1 and Read_Data2 when func = "011" else -- AND
Read_Data1 OR Read_Data2 when func = "100" else -- OR
not Read_Data1 when func = "101" else -- NOT
adder_out when func = "110" else -- INC
adder_out; -- DEC;


result_carry_out <= carry_out when func = "000" else -- IADD
carry_out when func = "001" else -- ADD
not carry_out when func ="010" else -- SUB
carry_out when func ="110" else -- INC
not carry_out when func ="111" -- DEC 
else '0';


ALU_OUT <= result when ALU_en = '1' else
Read_Data2;

ZF_ALU <= not or_result when ALU_en = '1' else
'0';

CF_ALU <= result_carry_out when ALU_en = '1' else
'0';

NF_ALU <= result(15) when ALU_en = '1' else
'0';



END my_ALU;





		 
