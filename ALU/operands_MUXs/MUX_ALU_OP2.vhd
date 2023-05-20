Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity MUX_ALU_OP2 is


PORT(DE_Read_Data2_out, MM_ALU_or_Mem_Out_out, EM_ALU_or_IN_out, Write_Data: IN std_logic_vector(15 downto 0);
DE_Read_Data2_final_out: OUT std_logic_vector (15 downto 0);
Read_data2_sel: in std_logic_vector(1 downto 0));

end MUX_ALU_OP2;


Architecture my_MUX_ALU_OP2 of MUX_ALU_OP2 is
begin

DE_Read_Data2_final_out <= DE_Read_Data2_out when Read_data2_sel = "00" else
MM_ALU_or_Mem_Out_out when Read_data2_sel = "01" else
EM_ALU_or_IN_out when Read_data2_sel <= "10" else
Write_Data;



end my_MUX_ALU_OP2;