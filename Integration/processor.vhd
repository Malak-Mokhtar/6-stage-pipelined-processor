-- vhdl-linter-disable component
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY processor IS
    PORT (
        clk, rst : IN STD_LOGIC;
        IN_Port : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END processor;

ARCHITECTURE arch OF processor IS
    --Fetch Stage Component
    COMPONENT Fetch_Stage IS
        PORT (
            clk, pc_rst, pc_en : IN STD_LOGIC;
            IN_PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            Read_Address : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            Inst : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    --Fetch Decode Register
    COMPONENT FD_Register IS
        PORT (
            clk, en, rst : IN STD_LOGIC;
            Inst : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Read_Address, IN_PORT : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            FD_Inst_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            FD_Read_Address_out, FD_IN_PORT_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;
    --------------------------------------------------------------------
    -- Decode Stage
    COMPONENT Decode_Stage IS
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
    END COMPONENT;

    -- Decode Execute Register
    COMPONENT DE_Register IS
        PORT (
            clk, en, rst : IN STD_LOGIC;
            IN_en, RegWrite_en, Carry_en, ALU_en, Mem_to_Reg_en, MemWrite_en, MemRead_en : IN STD_LOGIC;
            FD_IN_PORT_out, Read_Data1, Read_Data2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            Inst_20_to_18_Write_Addrs : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_31_to_27_OPCODE : IN STD_LOGIC_VECTOR(4 DOWNTO 0);

            DE_IN_en_out, DE_RegWrite_en_out, DE_Carry_en_out, DE_ALU_en_out, DE_Mem_to_Reg_en_out, DE_MemWrite_en_out, DE_MemRead_en_out : OUT STD_LOGIC;
            DE_IN_PORT_out, DE_Read_Data1_out, DE_Read_Data2_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            DE_Write_Addr_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            DE_OPCODE_out : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)

        );
    END COMPONENT;
    --------------------------------------------------------------------
    SIGNAL PC_en : STD_LOGIC := '1';
    SIGNAL FD_en : STD_LOGIC := '1';
    SIGNAL DE_en : STD_LOGIC := '1';
    -------------------------------------------------------------
    --Fetch Stage
    SIGNAL Inst : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Read_Address : STD_LOGIC_VECTOR(15 DOWNTO 0);
    -- FD Register
    SIGNAL FD_Inst_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL FD_Read_Address_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL FD_IN_PORT_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    --DE Register
    SIGNAL IN_PC : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL IN_en : STD_LOGIC;
    SIGNAL FD_IN_PORT_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Write_address_RD : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL RegWrite_en : STD_LOGIC;
    SIGNAL Carry_en : STD_LOGIC;
    SIGNAL ALU_en : STD_LOGIC;
    SIGNAL OPCODE : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL Read_Data1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Read_Data2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Mem_to_Reg_en : STD_LOGIC;
    SIGNAL MemWrite_en : STD_LOGIC;
    SIGNAL MemRead_en : STD_LOGIC;
BEGIN

    --Fetch Stage
    Internal_Fetch_Stage : Fetch_Stage PORT MAP(
        clk => clk,
        pc_rst => rst,
        pc_en => PC_en, --TODO: add an input to pc_en
        IN_PC => "0000000000000101",
        Read_Address => Read_Address,
        Inst => Inst

    );

    -- FD Register
    Internal_FD_Register : FD_Register PORT MAP(
        --inputs
        clk => clk,
        en => FD_en,
        rst => rst,
        Inst => Inst,
        Read_Address => Read_Address,
        IN_Port => IN_Port,
        --------------------------
        --outputs
        FD_Inst_out => FD_Inst_out,
        FD_Read_Address_out => FD_Read_Address_out,
        FD_IN_PORT_out => FD_IN_PORT_out

    );

    --Decode Stage
    Internal_Decode_Stage : Decode_Stage PORT MAP(
        --INPUT PORTS
        clk => clk,
        Reg_File_rst => rst,
        FD_Inst => FD_Inst_out,
        FD_Read_Address => FD_Read_Address_out,
        FD_IN_PORT => FD_IN_PORT_out,
        MW_write_Data => "1111000000001111", --TODO add future MW Data
        --OUTPUT PORTS
        IN_PC => IN_PC,
        IN_en => IN_en,
        FD_IN_PORT_out => FD_IN_PORT_out,
        Write_address_RD => Write_address_RD,
        RegWrite_en => RegWrite_en,
        Carry_en => Carry_en,
        ALU_en => ALU_en,
        OPCODE => OPCODE,
        Read_Data1 => Read_Data1,
        Read_Data2 => Read_Data2,
        Mem_to_Reg_en => Mem_to_Reg_en,
        MemWrite_en => MemWrite_en,
        MemRead_en => MemRead_en
    );

END ARCHITECTURE;