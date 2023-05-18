LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY MUX_DEC_PC IS 
	PORT ( PC_Added,DE_Read_Data1_out,Read_Data1,MW_Read_Data_out: IN std_logic_vector (15 DOWNTO 0);
			MW_RET_en_out,DE_JMP_en_out,DE_CALL_en_out,DE_JZ_en_out,ZF_OUT,DE_JC_en_out, CF_OUT,MW_PC_or_addrs1_en_out,MW_RTI_en_out : IN  std_logic;
			IN_PC : OUT std_logic_vector (15 DOWNTO 0));
END MUX_DEC_PC;


ARCHITECTURE when_else_mux OF MUX_DEC_PC is

    signal sel1: std_logic;
    signal sel0: std_logic;
    signal branch: std_logic;
    signal selReturns: std_logic;
    signal NOTselReturns: std_logic;
	BEGIN

    branch <= ( DE_JZ_en_out and ZF_OUT ) or ( DE_JC_en_out and CF_OUT);
	selReturns <= MW_RTI_en_out or MW_RET_en_out or MW_PC_or_addrs1_en_out;
    NOTselReturns<= NOT selReturns;

    sel0 <= (branch AND NOTselReturns) or selReturns;
    sel1 <= ((DE_CALL_en_out or DE_JMP_en_out) AND NOTselReturns ) or selReturns;

    IN_PC <= 	PC_Added when sel1 = '0' and sel0 = '0'
	else	DE_Read_Data1_out when sel1 = '0' and sel0 = '1'
	else	Read_Data1 when sel1 = '1' and sel0= '0'
    else	MW_Read_Data_out; 
END when_else_mux;