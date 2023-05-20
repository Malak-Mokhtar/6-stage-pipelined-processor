Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- This is the testbench of Lab1

entity MUX_ALU_OP2B is

PORT(EM_ALU_out, EM_IN_PORT_out : IN std_logic_vector(15 downto 0);
EM_ALU_or_IN_out: OUT std_logic_vector (15 downto 0);
EM_IN_en_out: in std_logic);

end MUX_ALU_OP2B;


Architecture my_MUX_ALU_OP2B of MUX_ALU_OP2B is
begin

    EM_ALU_or_IN_out <= EM_ALU_out when EM_IN_en_out = '0'
else EM_IN_PORT_out;

end my_MUX_ALU_OP2B;