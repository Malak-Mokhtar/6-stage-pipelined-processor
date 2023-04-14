LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Execute_Stage IS
    PORT (
        --INPUT PORTS    
        clk, Reg_File_rst, general_rst : IN STD_LOGIC;
        DE_IN_en_out,
        DE_RegWrite_en_out,
        DE_Carry_en_out, 
        DE_ALU_en_out, 
        DE_Mem_to_Reg_en_out, 
        DE_MemWrite_en_out, 
        DE_MemRead_en_out : IN STD_LOGIC;
        DE_IN_PORT_out, 
        DE_Read_Data1_out,
        DE_Read_Data2_out  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        DE_Write_Addr_out: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        DE_OPCODE_out : IN STD_LOGIC_VECTOR(4 DOWNTO 0);

        -- OUTPUT PORTS
        DE_IN_en,
        DE_Mem_to_Reg_en,
        DE_RegWrite_en,
        DE_MemWrite_en,
        DE_MemRead_en : OUT STD_LOGIC;
        DE_Write_Addr : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        DE_IN_PORT,
        ALU_Out,
        DE_Read_Data1,
        DE_Read_Data2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

    );
END Execute_Stage;

ARCHITECTURE arch OF Execute_Stage IS

    --ALU component
    Component ALU is
        PORT (Read_Data1, Read_Data2: IN std_logic_vector (15 downto 0); 
              FUNC: IN std_logic_vector (2 downto 0);
              ALU_en: IN std_logic;
             ALU_OUT: OUT std_logic_vector (15 downto 0);
              ZF_ALU, CF_ALU, NF_ALU: OUT std_logic);
    END Component;

    --Carry flag register
    Component CF IS
    PORT (
        CF_ALU, clk, rst, DE_Carry_en_out : IN STD_LOGIC;
        CF_OUT : OUT STD_LOGIC);
    END Component;

    -- Negative flag register
    Component NF IS
    PORT (
        NF_ALU, clk, rst, DE_ALU_en_out : IN STD_LOGIC;
        NF_OUT : OUT STD_LOGIC);
    END Component;

    -- Zero flag register
    Component ZF IS
    PORT (
        ZF_ALU, clk, rst, DE_ALU_en_out : IN STD_LOGIC;
        ZF_OUT : OUT STD_LOGIC);
    END Component;

    -------------------SIGNALS----------------
    SIGNAL ZF_SIG,NF_SIG, CF_SIG: STD_LOGIC;


BEGIN

    ALU_MAP : ALU PORT MAP(
        Read_Data1 => DE_Read_Data1_out,
        Read_Data2 => DE_Read_Data2_out, 
        FUNC => DE_OPCODE_out(2 downto 0),
        ALU_en => DE_ALU_en_out,
        ALU_OUT => ALU_Out,
        ZF_ALU => ZF_SIG,
        CF_ALU => CF_SIG,
        NF_ALU => NF_SIG
    );

    ZF_MAP : ZF PORT MAP(
        ZF_ALU => ZF_SIG, 
        clk => clk, 
        rst => general_rst, 
        DE_ALU_en_out => DE_ALU_en_out,
        ZF_OUT => open
    );

    CF_MAP : CF PORT MAP(
        CF_ALU => CF_SIG,
        clk => clk,
        rst => general_rst, 
        DE_Carry_en_out => DE_Carry_en_out,
        CF_OUT => open
    );

    NF_MAP : NF PORT MAP(
        NF_ALU => NF_SIG,
        clk => clk,
        rst => general_rst,
        DE_ALU_en_out => DE_ALU_en_out,
        NF_OUT => open
    );

    --Remaining Output Signals
    DE_IN_en <= DE_IN_en_out;
    DE_Mem_to_Reg_en <= DE_RegWrite_en_out;
    DE_RegWrite_en <= DE_RegWrite_en_out;
    DE_MemWrite_en <= DE_MemWrite_en_out;
    DE_MemRead_en <= DE_MemRead_en_out;
    DE_Write_Addr <= DE_Write_Addr_out;
    DE_IN_PORT <= DE_IN_PORT_out;
    DE_Read_Data1 <= DE_Read_Data1_out;
    DE_Read_Data2 <= DE_Read_Data2_out;


END ARCHITECTURE;