library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;



Entity ALU is
	   PORT (DE_Read_Data1_out, DE_Read_Data2_final_out: IN std_logic_vector (15 downto 0); 
	         FUNC: IN std_logic_vector (2 downto 0);
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
		
	 signal comp: std_logic_vector (15 downto 0);
	 signal sum, subb,sum2, subb2:  std_logic_vector (15 downto 0);
	 signal carry_out1, carry_out2,carry_out3, carry_out4, nf: std_logic; 
	 signal result: std_logic_vector (15 downto 0);
	 signal result_carry_out: std_logic;
	 signal or_result: std_logic;
BEGIN


comp <= not DE_Read_Data2_final_out;


adder: full_adder port map (DE_Read_Data1_out, DE_Read_Data2_final_out, '0', sum, carry_out1);
adder2: full_adder port map (DE_Read_Data1_out, comp, '1', subb, carry_out2);
adder3: full_adder port map (DE_Read_Data1_out, "0000000000000001", '0', sum2, carry_out3);
adder4: full_adder port map (DE_Read_Data1_out, x"FFFE", '1', subb2, carry_out4);
ORING: OR_GATE port map (result, or_result);





result <= DE_Read_Data1_out when func = "000" else
sum when func = "001" else
subb when func = "010" else
DE_Read_Data1_out and DE_Read_Data2_final_out when func = "011" else
DE_Read_Data1_out OR DE_Read_Data2_final_out when func = "100" else
sum2 when func = "101" else
subb2 when func = "110";










result_carry_out <= carry_out1 when func = "001" else
carry_out2 when func ="010" else
carry_out3 when func ="101" else
carry_out4 when func ="110" else
'0';












ALU_OUT <= result;





ZF_ALU <= not or_result;
CF_ALU <= result_carry_out;
NF_ALU <= result(15);




											
														




END my_ALU;





		 
