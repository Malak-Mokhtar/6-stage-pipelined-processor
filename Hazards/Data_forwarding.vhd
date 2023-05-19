Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Data_forwarding is


PORT(DE_Read_Address1, DE_Read_Address2, EM_Write_Addr_out, MM_Write_Addr_out, MW_Write_Addr_out: IN std_logic_vector(2 downto 0);
EM_RegWrite_en_out, MM_RegWrite_en_out, MW_RegWrite_en_out, DE_Immediate_en_out: IN std_logic;
Read_data2_sel, Read_data1_sel: out std_logic_vector(1 downto 0));


end Data_forwarding;






Architecture my_Data_forwarding of Data_forwarding is

component XOR_gate is
PORT(in1, in2: in std_logic_vector(2 downto 0);
out1: out std_logic);
end component;


signal xor1, xor2, xor3, xor4, xor5, xor6: std_logic;
signal sig1, sig2, sig3, sig4, sig5, sig6, sig7, sig8: std_logic;

begin


x1: XOR_gate port map(DE_Read_Address1, EM_Write_Addr_out, xor1);
x2: XOR_gate port map(DE_Read_Address1, MM_Write_Addr_out, xor2);
x3: XOR_gate port map(DE_Read_Address1, MW_Write_Addr_out, xor3);

x4: XOR_gate port map(DE_Read_Address2, EM_Write_Addr_out, xor4);
x5: XOR_gate port map(DE_Read_Address2, MM_Write_Addr_out, xor5);
x6: XOR_gate port map(DE_Read_Address2, MW_Write_Addr_out, xor6);




sig1 <= (not xor1) and EM_RegWrite_en_out;
sig2 <= (not xor2) and MM_RegWrite_en_out;
sig3 <= (not xor3) and MW_RegWrite_en_out;
sig4 <= (not sig1) and (not sig2) and sig3;
sig5 <= (not xor4) and EM_RegWrite_en_out;
sig6 <= (not xor5) and MM_RegWrite_en_out;
sig7 <= (not xor6) and MW_RegWrite_en_out;
sig8 <= (not sig5) and (not sig6) and sig7;


Read_data1_sel(0) <= ((not sig1) and sig2) OR sig4;
Read_data1_sel(1) <=  sig1 OR sig4;


Read_data2_sel(0) <= (((not sig5) and sig6) OR sig8) and (not DE_Immediate_en_out);
Read_data2_sel(1) <=  (sig5 OR sig8) and (not DE_Immediate_en_out);








end Architecture;