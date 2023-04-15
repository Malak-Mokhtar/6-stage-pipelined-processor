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
            MW_Write_Address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            MW_RegWrite_en : IN STD_LOGIC;
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

    ----------------------------------------------------------------------
    --Execute Stage 
    COMPONENT Execute_Stage IS
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
            DE_Read_Data2_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            DE_Write_Addr_out : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
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
    END COMPONENT;

    --EM Register
    COMPONENT EM_Register IS
        PORT (
            clk, en, rst, DE_IN_en_out, DE_RegWrite_en_out, DE_Mem_to_Reg_en_out, DE_MemWrite_en_out, DE_MemRead_en_out : IN STD_LOGIC;
            DE_IN_PORT_out, ALU_Out, DE_Read_Data1_out, DE_Read_Data2_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            DE_Write_Addr_out : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

            EM_IN_en_out, EM_RegWrite_en_out, EM_Mem_to_Reg_en_out, EM_MemWrite_en_out, EM_MemRead_en_out : OUT STD_LOGIC;
            EM_IN_PORT_out, EM_ALU_Out_out, EM_Read_Data1_out, EM_Read_Data2_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            EM_Write_Addr_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;
    --------------------------------------------------------------------
    --Memory Stage
    COMPONENT Memory_Stages IS
        PORT (
            --INPUT PORTS    
            clk, general_rst : IN STD_LOGIC;
            EM_IN_en_out,
            EM_RegWrite_en_out,
            EM_Mem_to_Reg_en_out,
            EM_MemWrite_en_out,
            EM_MemRead_en_out : IN STD_LOGIC;
            EM_IN_PORT_out,
            EM_ALU_Out_out,
            EM_Read_Data1_out,
            EM_Read_Data2_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            EM_Write_Addr_out : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

            -- OUTPUT PORTS
            MM_IN_en,
            MM_RegWrite_en,
            MM_Mem_to_Reg_en : OUT STD_LOGIC;
            MM_Write_Addr : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            MM_IN_PORT,
            MM_ALU_Out,
            Read_Data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

        );
    END COMPONENT;

    --MW Register
    COMPONENT MW_Register IS
        PORT (
            clk, en, rst, MM_IN_en_out, MM_RegWrite_en_out, MM_Mem_to_Reg_en_out : IN STD_LOGIC;
            MM_IN_PORT_out, MM_ALU_Out_out, Read_Data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            MM_Write_Addr_out : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

            MW_IN_en_out, MW_RegWrite_en_out, MW_Mem_to_Reg_en_out : OUT STD_LOGIC;
            MW_IN_PORT_out, MW_ALU_Out_out, MW_Read_Data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            MW_Write_Addr_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;
    --------------------------------------------------------------------
    --WB Stage
    COMPONENT WriteBack_Stage IS
        PORT (
            clk, general_rst : IN STD_LOGIC;
            MW_IN_en_out,
            MW_RegWrite_en_out,
            MW_Mem_to_Reg_en_out : IN STD_LOGIC;
            MW_IN_PORT_out,
            MW_ALU_Out_out,
            MW_Read_Data_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            MW_Write_Addr_out : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Write_Data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            MW_RegWrite_en : OUT STD_LOGIC;
            MW_Write_Addr : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;
    --------------------------------------------------------------------
    SIGNAL PC_en : STD_LOGIC := '1';
    SIGNAL FD_en : STD_LOGIC := '1';
    SIGNAL DE_en : STD_LOGIC := '1';
    SIGNAL EM_en : STD_LOGIC := '1';
    SIGNAL MW_en : STD_LOGIC := '1';
    -------------------------------------------------------------
    --Fetch Stage
    SIGNAL Inst : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Read_Address : STD_LOGIC_VECTOR(15 DOWNTO 0);
    -- FD Register
    SIGNAL FD_Inst_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL FD_Read_Address_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL FD_IN_PORT_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    --DE Register

    --INPUTS
    SIGNAL IN_PC : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL IN_en : STD_LOGIC;
    SIGNAL DE_IN_PORT_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
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

    --OUTPUTS
    SIGNAL DE_IN_en_out : STD_LOGIC;
    SIGNAL DE_RegWrite_en_out : STD_LOGIC;
    SIGNAL DE_Carry_en_out : STD_LOGIC;
    SIGNAL DE_ALU_en_out : STD_LOGIC;
    SIGNAL DE_Mem_to_Reg_en_out : STD_LOGIC;
    SIGNAL DE_MemWrite_en_out : STD_LOGIC;
    SIGNAL DE_MemRead_en_out : STD_LOGIC;
    SIGNAL DE_Read_Data1_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL DE_Read_Data2_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL DE_Write_Addr_out : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL DE_OPCODE_out : STD_LOGIC_VECTOR(4 DOWNTO 0);

    --EM Register

    --INPUTS

    SIGNAL DE_IN_en : STD_LOGIC;
    SIGNAL DE_Mem_to_Reg_en : STD_LOGIC;
    SIGNAL DE_RegWrite_en : STD_LOGIC;
    SIGNAL DE_MemWrite_en : STD_LOGIC;
    SIGNAL DE_MemRead_en : STD_LOGIC;
    SIGNAL DE_Write_Addr : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL DE_IN_PORT : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ALU_Out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL DE_Read_Data1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL DE_Read_Data2 : STD_LOGIC_VECTOR(15 DOWNTO 0);

    --OUTPUTS
    SIGNAL EM_IN_en_out : STD_LOGIC;
    SIGNAL EM_RegWrite_en_out : STD_LOGIC;
    SIGNAL EM_Mem_to_Reg_en_out : STD_LOGIC;
    SIGNAL EM_MemWrite_en_out : STD_LOGIC;
    SIGNAL EM_MemRead_en_out : STD_LOGIC;
    SIGNAL EM_IN_PORT_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL EM_ALU_Out_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL EM_Read_Data1_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL EM_Read_Data2_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL EM_Write_Addr_out : STD_LOGIC_VECTOR(2 DOWNTO 0);

    --MW Register
    --INPUT PORTS
    SIGNAL MM_IN_en : STD_LOGIC;
    SIGNAL MM_RegWrite_en : STD_LOGIC;
    SIGNAL MM_Mem_to_Reg_en : STD_LOGIC;
    SIGNAL MM_Write_Addr : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL MM_IN_PORT : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MM_ALU_Out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Read_Data : STD_LOGIC_VECTOR(15 DOWNTO 0);
    --OUTPUT PORTS
    SIGNAL MW_IN_en_out : STD_LOGIC;
    SIGNAL MW_RegWrite_en_out : STD_LOGIC;
    SIGNAL MW_Mem_to_Reg_en_out : STD_LOGIC;
    SIGNAL MW_IN_PORT_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MW_ALU_Out_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MW_Read_Data_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MW_Write_Addr_out : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL FD_IN_PORT_out_from_Decode_Stage : STD_LOGIC_VECTOR(15 DOWNTO 0);
    --------------------------------------------------------
    --WB Stage

    SIGNAL MW_Write_Data : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MW_RegWrite_en : STD_LOGIC;
    SIGNAL MW_Write_Addr : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN

    --Fetch Stage
    Internal_Fetch_Stage : Fetch_Stage PORT MAP(
        clk => clk,
        pc_rst => rst,
        pc_en => PC_en, --TODO: add an input to pc_en
        IN_PC => IN_PC,
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
    --------------------------------------------------------
    --Decode Stage
    Internal_Decode_Stage : Decode_Stage PORT MAP(
        --INPUT PORTS
        clk => clk,
        Reg_File_rst => rst,
        FD_Inst => FD_Inst_out,
        FD_Read_Address => FD_Read_Address_out,
        FD_IN_PORT => FD_IN_PORT_out,
        MW_write_Data => MW_Write_Data, --TODO add future MW Data *DONE*

        MW_Write_Address => MW_Write_Addr,
        MW_RegWrite_en => MW_RegWrite_en,
        --OUTPUT PORTS
        IN_PC => IN_PC,
        IN_en => IN_en,
        FD_IN_PORT_out => FD_IN_PORT_out_from_Decode_Stage,
        -- Write_address_RD => MW_Write_Addr,
        Write_address_RD => Write_address_RD,
        RegWrite_en => RegWrite_en,
        Carry_en => Carry_en,
        ALU_en => ALU_en,
        OPCODE => OPCODE,
        Read_Data1 => Read_Data1,
        Read_Data2 => Read_Data2,
        Mem_to_Reg_en => Mem_to_Reg_en,
        MemWrite_en => MemWrite_en,
        -- MemWrite_en => MW_RegWrite_en,

        MemRead_en => MemRead_en
    );
    --DE Register
    Internal_DE_Register : DE_Register PORT MAP(
        clk => clk,
        en => DE_en,
        rst => rst,

        --INPUT PORTS
        IN_en => IN_en,
        FD_IN_PORT_out => FD_IN_PORT_out_from_Decode_Stage,
        Inst_20_to_18_Write_Addrs => Write_address_RD,
        RegWrite_en => RegWrite_en,
        Carry_en => Carry_en,
        ALU_en => ALU_en,
        Inst_31_to_27_OPCODE => OPCODE,
        Read_Data1 => Read_Data1,
        Read_Data2 => Read_Data2,
        Mem_to_Reg_en => Mem_to_Reg_en,
        MemWrite_en => MemWrite_en,
        -- MemWrite_en => MW_RegWrite_en,
        MemRead_en => MemRead_en,

        --OUTPUT PORTS
        DE_IN_en_out => DE_IN_en_out,
        DE_RegWrite_en_out => DE_RegWrite_en_out,
        DE_Carry_en_out => DE_Carry_en_out,
        DE_ALU_en_out => DE_ALU_en_out,
        DE_Mem_to_Reg_en_out => DE_Mem_to_Reg_en_out,
        DE_MemWrite_en_out => DE_MemWrite_en_out,
        DE_MemRead_en_out => DE_MemRead_en_out,
        DE_IN_PORT_out => DE_IN_PORT_out,
        DE_Read_Data1_out => DE_Read_Data1_out,
        DE_Read_Data2_out => DE_Read_Data2_out,
        DE_Write_Addr_out => DE_Write_Addr_out,
        DE_OPCODE_out => DE_OPCODE_out

    );

    ---------------------------------------------------------
    --Execute Stage
    Internal_Execute_Stage : Execute_Stage PORT MAP(

        --INPUT PORTS
        clk => clk,
        Reg_File_rst => rst, -- TODO configure resets
        general_rst => rst,
        DE_IN_en_out => DE_IN_en_out,
        DE_RegWrite_en_out => DE_RegWrite_en_out,
        DE_Carry_en_out => DE_Carry_en_out,
        DE_ALU_en_out => DE_ALU_en_out,
        DE_Mem_to_Reg_en_out => DE_Mem_to_Reg_en_out,
        DE_MemWrite_en_out => DE_MemWrite_en_out,
        DE_MemRead_en_out => DE_MemRead_en_out,
        DE_IN_PORT_out => DE_IN_PORT_out,
        DE_Read_Data1_out => DE_Read_Data1_out,
        DE_Read_Data2_out => DE_Read_Data2_out,
        DE_Write_Addr_out => DE_Write_Addr_out,
        DE_OPCODE_out => DE_OPCODE_out,
        -- OUTPUT PORTS
        DE_IN_en => DE_IN_en,
        DE_Mem_to_Reg_en => DE_Mem_to_Reg_en,
        DE_RegWrite_en => DE_RegWrite_en,
        DE_MemWrite_en => DE_MemWrite_en,
        DE_MemRead_en => DE_MemRead_en,
        DE_Write_Addr => DE_Write_Addr,
        DE_IN_PORT => DE_IN_PORT,
        ALU_Out => ALU_Out,
        DE_Read_Data1 => DE_Read_Data1,
        DE_Read_Data2 => DE_Read_Data2
    );
    Internal_EM_Register : EM_Register PORT MAP(
        --INPUT PORTS
        clk => clk,
        en => EM_en,
        rst => rst,
        DE_IN_en_out => DE_IN_en,
        DE_RegWrite_en_out => DE_RegWrite_en,
        DE_Mem_to_Reg_en_out => DE_Mem_to_Reg_en,
        DE_MemWrite_en_out => DE_MemWrite_en,
        DE_MemRead_en_out => DE_MemRead_en,
        DE_IN_PORT_out => DE_IN_PORT_out,
        ALU_Out => ALU_Out,
        DE_Read_Data1_out => DE_Read_Data1,
        DE_Read_Data2_out => DE_Read_Data2,
        DE_Write_Addr_out => DE_Write_Addr,

        --OUTPUTS
        EM_IN_en_out => EM_IN_en_out,
        EM_RegWrite_en_out => EM_RegWrite_en_out,
        EM_Mem_to_Reg_en_out => EM_Mem_to_Reg_en_out,
        EM_MemWrite_en_out => EM_MemWrite_en_out,
        EM_MemRead_en_out => EM_MemRead_en_out,
        EM_IN_PORT_out => EM_IN_PORT_out,
        EM_ALU_Out_out => EM_ALU_Out_out,
        EM_Read_Data1_out => EM_Read_Data1_out,
        EM_Read_Data2_out => EM_Read_Data2_out,
        EM_Write_Addr_out => EM_Write_Addr_out
    );
    ------------------------------------------------
    --Memory Stage
    Internal_Memory_Stages : Memory_Stages PORT MAP(
        --INPUT PORTS    
        clk => clk,
        general_rst => rst,
        EM_IN_en_out => EM_IN_en_out,
        EM_RegWrite_en_out => EM_RegWrite_en_out,
        EM_Mem_to_Reg_en_out => EM_Mem_to_Reg_en_out,
        EM_MemWrite_en_out => EM_MemWrite_en_out,
        EM_MemRead_en_out => EM_MemRead_en_out,
        EM_IN_PORT_out => EM_IN_PORT_out,
        EM_ALU_Out_out => EM_ALU_Out_out,
        EM_Read_Data1_out => EM_Read_Data1_out,
        EM_Read_Data2_out => EM_Read_Data2_out,
        EM_Write_Addr_out => EM_Write_Addr_out,

        -- OUTPUT PORTS
        MM_IN_en => MM_IN_en,
        MM_RegWrite_en => MM_RegWrite_en,
        MM_Mem_to_Reg_en => MM_Mem_to_Reg_en,
        MM_Write_Addr => MM_Write_Addr,
        MM_IN_PORT => MM_IN_PORT,
        MM_ALU_Out => MM_ALU_Out,
        Read_Data => Read_Data

    );

    --MW Register
    Internal_MW_Register : MW_Register PORT MAP(

        --INPUT PORTS
        clk => clk,
        en => MW_en,
        rst => rst,
        MM_IN_en_out => MM_IN_en,
        MM_RegWrite_en_out => MM_RegWrite_en,
        MM_Mem_to_Reg_en_out => MM_Mem_to_Reg_en,
        MM_IN_PORT_out => MM_IN_PORT,
        MM_ALU_Out_out => MM_ALU_Out,
        Read_Data => Read_Data,
        MM_Write_Addr_out => MM_Write_Addr,
        --OUTPUT PORTS
        MW_IN_en_out => MW_IN_en_out,
        MW_RegWrite_en_out => MW_RegWrite_en_out,
        MW_Mem_to_Reg_en_out => MW_Mem_to_Reg_en_out,
        MW_IN_PORT_out => MW_IN_PORT_out,
        MW_ALU_Out_out => MW_ALU_Out_out,
        MW_Read_Data_out => MW_Read_Data_out,
        MW_Write_Addr_out => MW_Write_Addr_out
    );
    ------------------------------------------------
    --WriteBack Stage
    Internal_WriteBack_Stage : WriteBack_Stage PORT MAP(
        clk => clk,
        general_rst => rst,
        MW_IN_en_out => MW_IN_en_out,
        MW_RegWrite_en_out => MW_RegWrite_en_out,
        MW_Mem_to_Reg_en_out => MW_Mem_to_Reg_en_out,
        MW_IN_PORT_out => MW_IN_PORT_out,
        MW_ALU_Out_out => MW_ALU_Out_out,
        MW_Read_Data_out => MW_Read_Data_out,
        MW_Write_Addr_out => MW_Write_Addr_out,
        -- The three go to Decode Stage
        Write_Data => MW_Write_Data,
        MW_RegWrite_en => MW_RegWrite_en,
        MW_Write_Addr => MW_Write_Addr
    );

END ARCHITECTURE;