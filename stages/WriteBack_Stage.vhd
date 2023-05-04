LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY WriteBack_Stage IS
    PORT (
        -- Inputs:
        clk, general_rst : IN STD_LOGIC;
        MW_IN_en_out,
        MW_RegWrite_en_out,
        MW_Mem_to_Reg_en_out,
        -- Phase 2
        MW_OUT_en_OUT : IN STD_LOGIC;
        --
        MW_IN_PORT_out,
        MW_ALU_Out_out,
        MW_Read_Data_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        MW_Write_Addr_out : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        
        -- Outputs:
        Write_Data,
        --Phase 2:
        OUT_Port : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        --
        MW_RegWrite_en : OUT STD_LOGIC;
        MW_Write_Addr  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) 
    );
END WriteBack_Stage;

ARCHITECTURE arch OF WriteBack_Stage IS

    --MUX 3X1 in Write Back
    COMPONENT MUX_WB IS 
	PORT ( Read_Data,ALU_out,IN_PORT: IN std_logic_vector (15 DOWNTO 0);
			Mem_to_Reg_en, IN_en : IN  std_logic;
			Write_Data : OUT std_logic_vector (15 DOWNTO 0));
    END COMPONENT;

    -- Phase 2:
    -- Sign Extend
    COMPONENT Sign_Extend IS 
	PORT ( OUT_en : IN  std_logic;
			OUT_en_extended : OUT std_logic_vector (15 DOWNTO 0));
    END COMPONENT;

    -- AND GATE
    COMPONENT OUT_AND_GATE IS 
	PORT ( OUT_en_extended, MW_ALU_Out_out : IN  std_logic_vector (15 DOWNTO 0);
			OUT_Port : OUT std_logic_vector (15 DOWNTO 0));
    END COMPONENT;

    -- Signals:
    -- Phase 2:
    SIGNAL OUT_en_extended: std_logic_vector (15 DOWNTO 0);

BEGIN

    MUX_MAP : MUX_WB PORT MAP(
       Read_Data => MW_Read_Data_out,
       ALU_out=> MW_ALU_Out_out,
       IN_PORT => MW_IN_PORT_out,
       Mem_to_Reg_en=> MW_Mem_to_Reg_en_out, 
       IN_en => MW_IN_en_out,
       Write_Data=> Write_Data -- Forwarded back to register file
    );

    MW_RegWrite_en <= MW_RegWrite_en_out;
    MW_Write_Addr <= MW_Write_Addr_out;

    Sign_Extend_MAP : Sign_Extend PORT MAP(
        OUT_en => MW_OUT_en_OUT,
        OUT_en_extended => OUT_en_extended
    );

    OUT_AND_GATE_MAP: OUT_AND_GATE PORT MAP(
        OUT_en_extended => OUT_en_extended,
        MW_ALU_Out_out => MW_ALU_Out_out,
        OUT_Port => OUT_Port
    );

END ARCHITECTURE;