Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY loaduse IS
PORT( Read_Address1, Read_Address2, DE_Write_Addr_out, EM_Write_Addr_out: IN std_logic_vector(2 DOWNTO 0);
DE_MemRead_en_out,EM_MemRead_en_out, R1_en, R2_en : IN std_logic;
en_load_use: out std_logic
);
END loaduse;


ARCHITECTURE my_loaduse OF loaduse IS




component XOR_gate is
    PORT(in1, in2: in std_logic_vector(2 downto 0);
    out1: out std_logic);
end component;

signal xor1, xor2, xor3, xor4 : std_logic;

BEGIN



my_xor_gate1 : XOR_gate port map(Read_Address1, DE_Write_Addr_out, xor1);
my_xor_gate2 : XOR_gate port map(Read_Address2, DE_Write_Addr_out, xor2);


my_xor_gate3 : XOR_gate port map(Read_Address1, EM_Write_Addr_out, xor3);
my_xor_gate4 : XOR_gate port map(Read_Address2, EM_Write_Addr_out, xor4);







en_load_use <= ((not xor1 and DE_MemRead_en_out) and R1_en) or ((not xor2 and DE_MemRead_en_out) and R2_en) or ((not xor3 and EM_MemRead_en_out) and R1_en) or ((not xor4 and EM_MemRead_en_out) and R2_en);



end architecture;