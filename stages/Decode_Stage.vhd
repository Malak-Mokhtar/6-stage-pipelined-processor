LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Decode_Stage IS
    PORT (
        --INPUT PORTS    
        clk, Reg_File_rst : IN STD_LOGIC;
        FD_Inst : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        FD_Read_Address, FD_IN_PORT : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        MW_Write_Data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        -- OUTPUT PORTS
        IN_PC : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        IN_en : OUT STD_LOGIC;
        FD_IN_PORT_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Write_address_RD : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        RegWrite_en : OUT STD_LOGIC;
        Carry_en : OUT STD_LOGIC;
        ALU_en : OUT STD_LOGIC;
        OPCODE : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
        Read_Data1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Read_Data2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Mem_to_Reg_en : OUT STD_LOGIC;
        MemWrite_en : OUT STD_LOGIC;
        MemRead_en : OUT STD_LOGIC
    );
END Decode_Stage;

ARCHITECTURE arch OF Decode_Stage IS

    -------------------COMPONENTS----------------
    -- adder for PC
    COMPONENT adder IS
        PORT (
            FD_Read_Address_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            IN_PC : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
        );
    END COMPONENT;

    --Control Unit
    COMPONENT Control_Unit IS
        PORT (
            OPCODE : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            IN_en, Carry_en, ALU_en, RegWrite_en, Mem_to_Reg_en, MemWrite_en, MemRead_en : OUT STD_LOGIC
        );
    END COMPONENT;
    --Register File
    COMPONENT Reg_file IS
        PORT (
            clk, Rst, write_en : IN STD_LOGIC;
            Read_Address1, Read_Address2, Write_Addesss : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Read_Data1, Read_Data2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            Write_Data : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    -------------------SIGNALS----------------
    SIGNAL Internal_Reg_Write_en : STD_LOGIC;

BEGIN

    --adder initialization
    Internal_adder : adder PORT MAP(
        FD_Read_Address_out => FD_Read_Address,
        IN_PC => IN_PC
    );

    -- control unit initalization
    Internal_Control_Unit : Control_Unit PORT MAP(
        OPCODE => FD_Inst(31 DOWNTO 27),
        IN_en => IN_en,
        Carry_en => Carry_en,
        ALU_en => ALU_en,
        RegWrite_en => Internal_Reg_Write_en,
        Mem_to_Reg_en => Mem_to_Reg_en,
        MemWrite_en => MemWrite_en,
        MemRead_en => MemRead_en

    );

    --Register File Initialization
    Internal_Register_File : Reg_file PORT MAP(
        clk => clk,
        rst => Reg_File_rst,
        write_en => Internal_Reg_Write_en,
        Read_Address1 => FD_Inst(26 DOWNTO 24),
        Read_Address2 => FD_Inst(23 DOWNTO 21),
        Write_Addesss => FD_Inst(20 DOWNTO 18),
        Write_Data => MW_Write_Data,
        Read_Data1 => Read_Data1,
        Read_Data2 => Read_Data2

    );

    --Remaining Output Signals
    OPCODE <= FD_Inst(31 DOWNTO 27);
    FD_IN_PORT_out <= FD_IN_PORT;
    Write_address_RD <= FD_Inst(20 DOWNTO 18);
    RegWrite_en <= Internal_Reg_Write_en;
END ARCHITECTURE;