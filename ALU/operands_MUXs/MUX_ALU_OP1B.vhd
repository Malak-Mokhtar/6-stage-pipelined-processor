Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- This is the testbench of Lab1

entity MUX_ALU_OP1B is

PORT(MM_ALU_Out_out, Read_Data : IN std_logic_vector(15 downto 0);
MM_ALU_or_Mem_Out_out: OUT std_logic_vector (15 downto 0);
EM_en_load_use_out: in std_logic);

end MUX_ALU_OP1B;


Architecture my_MUX_ALU_OP1B of MUX_ALU_OP1B is
begin

MM_ALU_or_Mem_Out_out <= MM_ALU_Out_out when EM_en_load_use_out = '0'
else Read_Data;

end my_MUX_ALU_OP1B;