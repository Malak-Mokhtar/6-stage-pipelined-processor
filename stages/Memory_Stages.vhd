LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Memory_Stages IS
    PORT (
        --INPUT PORTS    
        clk, general_rst : IN STD_LOGIC;
        EM_IN_en_out ,
        EM_RegWrite_en_out ,
        EM_Mem_to_Reg_en_out , 
        EM_MemWrite_en_out , 
        EM_MemRead_en_out : IN STD_LOGIC;
        EM_IN_PORT_out,
        EM_ALU_Out_out,
        EM_Read_Data1_out,
        EM_Read_Data2_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        EM_Write_Addr_out : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

        -- OUTPUT PORTS
        MM_IN_en,
        MM_RegWrite_en : OUT STD_LOGIC;
        MM_Write_Addr : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        MM_IN_PORT,
        MM_ALU_Out,
        Read_Data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

    );
END Memory_Stages;

ARCHITECTURE arch OF Memory_Stages IS

    -- Data memory
    COMPONENT Data_Memory IS
    PORT (
        Address, Write_Data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        clk, Rst, MemWrite_en, MemRead_en : IN STD_LOGIC;
        Read_Data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
    END COMPONENT;

    -- Memory memory pipelined register
    COMPONENT MM_Register IS
    PORT (
        clk, en, rst : IN STD_LOGIC;
        EM_IN_en_out : IN STD_LOGIC;
	EM_IN_PORT_out, EM_ALU_Out_out: IN STD_LOGIC_vector (15 DOWNTO 0);
	EM_Write_Addr_out: IN STD_LOGIC_vector (2 downto 0);
	EM_RegWrite_en_out: IN std_logic;

	MM_IN_en_out: OUT std_logic;
	MM_IN_PORT_out, MM_ALU_Out_out: OUT std_logic_vector (15 downto 0);
	MM_Write_Addr_out: OUT std_logic_vector (2 downto 0);
        MM_RegWrite_en_out: OUT std_logic
    );
    END COMPONENT;

    -------------------SIGNALS----------------
    SIGNAL MM_en : STD_LOGIC := '1';

BEGIN

    Data_memory_MAP : Data_Memory PORT MAP(
        Address => EM_Read_Data1_out,
        Write_Data => EM_Read_Data2_out,
        clk => clk,
        Rst => general_rst,
        MemWrite_en => EM_MemWrite_en_out,
        MemRead_en => EM_MemRead_en_out,
        Read_Data => Read_Data
    );

    MM_Reg_MAP : MM_Register PORT MAP(
    clk => clk,
    en => MM_en,
    rst => general_rst,
    EM_IN_en_out => EM_IN_en_out,
	EM_IN_PORT_out => EM_IN_PORT_out,
    EM_ALU_Out_out => EM_ALU_Out_out,
	EM_Write_Addr_out => EM_Write_Addr_out,
	EM_RegWrite_en_out => EM_RegWrite_en_out,
	MM_IN_en_out => MM_IN_en,
	MM_IN_PORT_out => MM_IN_PORT,
    MM_ALU_Out_out => MM_ALU_Out,
	MM_Write_Addr_out => MM_Write_Addr,
    MM_RegWrite_en_out => MM_RegWrite_en 
    );

END ARCHITECTURE;