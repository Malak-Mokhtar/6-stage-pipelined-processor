Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX_DEC_Read_data2 is


PORT(Read_Data2_RF, PC_Added, Imm_Value: IN std_logic_vector(15 downto 0);
Read_Data2: OUT std_logic_vector (15 downto 0);
Immediate_en, CALL_en: in std_logic);

end MUX_DEC_Read_data2;




architecture my_MUX_DEC_Read_data2 of MUX_DEC_Read_data2 is

begin

Read_Data2 <= Read_Data2_RF when Immediate_en = '0' and CALL_en = '0' else
PC_Added when Immediate_en = '0' and CALL_en = '1' else
Imm_Value when Immediate_en = '1' and CALL_en = '0' else
(others => '0');

end architecture;