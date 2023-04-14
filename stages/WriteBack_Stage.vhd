LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY WriteBack_Stage IS
    PORT (
        clk, general_rst : IN STD_LOGIC;
        MW_IN_en_out,
        MW_RegWrite_en_out : IN STD_LOGIC;
        MW_IN_PORT_out,
        MW_ALU_Out_out,
        MW_Read_Data_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        MW_Write_Addr_out  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END WriteBack_Stage;

ARCHITECTURE arch OF WriteBack_Stage IS

    --MUX 3X1 in Write Back
    COMPONENT MUX_WB IS 
	PORT ( Read_Data,ALU_out,IN_PORT: IN std_logic_vector (15 DOWNTO 0);
			Mem_to_Reg_en, IN_en : IN  std_logic;
			Write_Data : OUT std_logic_vector (15 DOWNTO 0));
    END COMPONENT;

BEGIN

    MUX_MAP : MUX_WB PORT MAP(
       Read_Data => MW_Read_Data_out,
       ALU_out=> MW_ALU_Out_out,
       IN_PORT => MW_IN_PORT_out,
       Mem_to_Reg_en=> open, 
       IN_en => MW_IN_PORT_out,
       Write_Data=> open
    );

END ARCHITECTURE;