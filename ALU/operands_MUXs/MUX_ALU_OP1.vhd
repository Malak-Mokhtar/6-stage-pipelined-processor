Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- This is the testbench of Lab1

entity MUX_ALU_OP1 is


PORT(DE_Read_Data1_out, MM_ALU_Out_out, EM_ALU_out, Write_Data: IN std_logic_vector(15 downto 0);
DE_Read_Data1_final_out: OUT std_logic_vector (15 downto 0);
Read_data1_sel: in std_logic_vector(1 downto 0));

end MUX_ALU_OP1;


Architecture my_MUX_ALU_OP1 of MUX_ALU_OP1 is
begin

DE_Read_Data1_final_out <= DE_Read_Data1_out when Read_data1_sel = "00" else
MM_ALU_Out_out when Read_data1_sel = "01" else
EM_ALU_out when Read_data1_sel <= "10" else
Write_Data;



end my_MUX_ALU_OP1;