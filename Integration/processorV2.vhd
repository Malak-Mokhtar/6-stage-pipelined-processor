LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY processor IS
    PORT (
        clk, rst : IN STD_LOGIC;
        IN_Port : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Interrupt : IN STD_LOGIC;
        OUT_Port : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END processor;

ARCHITECTURE arch OF processor IS
    -- Fetch Stage Component
    COMPONENT Fetch_Stage IS
        PORT (
            -- Inputs:
            clk,
            pc_rst,
            -- Phase 2:
            JMP_en,
            CALL_en,
            MW_RTI_en_out,
            MW_RET_en_out,
            PC_disable,
            en_load_use,
            en_structural,
            DE_JZ_en_out,
            ZF_OUT,
            DE_JC_en_out,
            CF_OUT : IN STD_LOGIC;
            --
            IN_PC, IN_DATA : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

            -- Outputs:
            Read_Address : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            Inst : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    -- Decode Stage
    COMPONENT Decode_Stage IS
        PORT (
            --INPUT PORTS    
            clk, Reg_File_rst : IN STD_LOGIC;
            FD_Inst : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            FD_Read_Address,
            FD_IN_PORT,
            --Phase 2:
            DE_Read_Data1_out,
            MW_Read_Data_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            --
            MW_Write_Data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            MW_Write_Address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            MW_RegWrite_en,
            -- Phase 2:
            MW_RET_en_out,
            DE_JZ_en_out,
            DE_JC_en_out,
            MW_PC_or_addrs1_en_out,
            MW_RTI_en_out,
            ZF_OUT,
            CF_OUT : IN STD_LOGIC;

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
            MemRead_en : OUT STD_LOGIC;
            -- Phase 2:
            SETC_en,
            CLRC_en,
            JZ_en,
            JC_en,
            SP_en,
            SP_inc_en,
            RET_en,
            OUT_en,
            RTI_en,
            CALL_en,
            JMP_en,
            Immediate_en : OUT STD_LOGIC;
            Interrupt_en : OUT STD_LOGIC;
            FLAGS_en : OUT STD_LOGIC;
            PC_or_addrs1_en : OUT STD_LOGIC

        );
    END COMPONENT;
    -----------------------------------------------------------------
    -- Fetch Decode Register 
    COMPONENT FD_Register IS
        PORT (
            clk, en_structural, en_load_use : IN STD_LOGIC;
            rst, ZF_OUT, DE_JZ_en_out, CF_OUT, DE_JC_en_out, DE_RET_en_out, EM_RET_en_out, MM_RET_en_out, DE_Interrupt_en_out : IN STD_LOGIC;
            Inst : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Read_Address, IN_PORT : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            FD_Inst_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            FD_Read_Address_out, FD_IN_PORT_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;
    --Decode Execute Register
    COMPONENT DE_Register IS
        PORT (
            clk, en_structural, rst : IN STD_LOGIC;
            IN_en, RegWrite_en, Carry_en, ALU_en, Mem_to_Reg_en, MemWrite_en, MemRead_en : IN STD_LOGIC;
            FD_IN_PORT_out, Read_Data1, Read_Data2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            Inst_20_to_18_Write_Addrs : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Inst_31_to_27_OPCODE : IN STD_LOGIC_VECTOR(4 DOWNTO 0);

            DE_IN_en_out, DE_RegWrite_en_out, DE_Carry_en_out, DE_ALU_en_out, DE_Mem_to_Reg_en_out, DE_MemWrite_en_out, DE_MemRead_en_out : OUT STD_LOGIC;
            DE_IN_PORT_out, DE_Read_Data1_out, DE_Read_Data2_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            DE_Write_Addr_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            DE_OPCODE_out : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);

            -- phase 2 update

            SETC_en : IN STD_LOGIC;
            CLRC_en : IN STD_LOGIC;
            JZ_en : IN STD_LOGIC;
            JC_en : IN STD_LOGIC;
            SP_en : IN STD_LOGIC;
            SP_inc_en : IN STD_LOGIC;
            RET_en : IN STD_LOGIC;
            CALL_en : IN STD_LOGIC;
            PC_or_addrs1_en : IN STD_LOGIC;
            FLAGS_en : IN STD_LOGIC;
            RTI_en : IN STD_LOGIC;
            OUT_en : IN STD_LOGIC;
            Read_Address1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Read_Address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Interrupt_en : IN STD_LOGIC;
            DE_SETC_en_out : OUT STD_LOGIC;
            DE_CLRC_en_out : OUT STD_LOGIC;
            DE_JZ_en_out : OUT STD_LOGIC;
            DE_JC_en_out : OUT STD_LOGIC;
            DE_SP_en_out : OUT STD_LOGIC;
            DE_SP_inc_en_out : OUT STD_LOGIC;
            DE_RET_en_out : OUT STD_LOGIC;
            DE_CALL_en_out : OUT STD_LOGIC;
            DE_PC_or_addrs1_en_out : OUT STD_LOGIC;
            DE_FLAGS_en_out : OUT STD_LOGIC;
            DE_RTI_en_out : OUT STD_LOGIC;
            DE_OUT_en_out : OUT STD_LOGIC;
            DE_Interrupt_en_out : OUT STD_LOGIC;
            DE_Read_Address1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            DE_Read_Address2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)

        );
    END COMPONENT;
    ----------------------------------------------------------------------------  
    -- Fetch Stage Signals
    SIGNAL pc_rst : STD_LOGIC;
    SIGNAL JMP_en : STD_LOGIC;
    SIGNAL CALL_en : STD_LOGIC;
    SIGNAL MW_RTI_en_out : STD_LOGIC;
    SIGNAL MW_RET_en_out : STD_LOGIC;
    SIGNAL PC_disable : STD_LOGIC;
    SIGNAL en_load_use : STD_LOGIC;
    SIGNAL en_structural : STD_LOGIC;
    SIGNAL DE_JZ_en_out : STD_LOGIC;
    SIGNAL ZF_OUT : STD_LOGIC;
    SIGNAL DE_JC_en_out : STD_LOGIC;
    SIGNAL CF_OUT : STD_LOGIC;
    SIGNAL IN_PC : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL IN_DATA : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Read_Address : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Inst : STD_LOGIC_VECTOR(31 DOWNTO 0);
    -- FD Stage Signals
    SIGNAL DE_RET_en_out : STD_LOGIC;
    SIGNAL EM_RET_en_out : STD_LOGIC;
    SIGNAL MM_RET_en_out : STD_LOGIC;
    SIGNAL DE_Interrupt_en_out : STD_LOGIC;
    SIGNAL FD_Inst_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL FD_Read_Address_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL FD_IN_PORT_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    ----------------------------------------------------------------
    -- Decode Stage Signals
    SIGNAL FD_Inst : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL FD_Read_Address : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL FD_IN_PORT : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL DE_Read_Data1_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MW_Read_Data_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MW_Write_Data : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MW_Write_Address : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL MW_RegWrite_en : STD_LOGIC;
    SIGNAL MW_PC_or_addrs1_en_out : STD_LOGIC;
    SIGNAL IN_en : STD_LOGIC;
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
    SIGNAL SETC_en : STD_LOGIC;
    SIGNAL CLRC_en : STD_LOGIC;
    SIGNAL JZ_en : STD_LOGIC;
    SIGNAL JC_en : STD_LOGIC;
    SIGNAL SP_en : STD_LOGIC;
    SIGNAL SP_inc_en : STD_LOGIC;
    SIGNAL RET_en : STD_LOGIC;
    SIGNAL OUT_en : STD_LOGIC;
    SIGNAL RTI_en : STD_LOGIC;
    SIGNAL Immediate_en : STD_LOGIC;
    SIGNAL PC_or_addrs1_en : STD_LOGIC;
    SIGNAL FLAGS_en : STD_LOGIC;

    -- Decode Execute Register
    SIGNAL Inst_20_to_18_Write_Addrs : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Inst_31_to_27_OPCODE : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL DE_IN_en_out : STD_LOGIC;
    SIGNAL DE_RegWrite_en_out : STD_LOGIC;
    SIGNAL DE_Carry_en_out : STD_LOGIC;
    SIGNAL DE_ALU_en_out : STD_LOGIC;
    SIGNAL DE_Mem_to_Reg_en_out : STD_LOGIC;
    SIGNAL DE_MemWrite_en_out : STD_LOGIC;
    SIGNAL DE_MemRead_en_out : STD_LOGIC;
    SIGNAL DE_IN_PORT_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL DE_Read_Data2_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL DE_Write_Addr_out : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL DE_OPCODE_out : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL Read_Address1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Read_Address2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Interrupt_en : STD_LOGIC;
    SIGNAL DE_SETC_en_out : STD_LOGIC;
    SIGNAL DE_CLRC_en_out : STD_LOGIC;
    SIGNAL DE_SP_en_out : STD_LOGIC;
    SIGNAL DE_SP_inc_en_out : STD_LOGIC;
    SIGNAL DE_CALL_en_out : STD_LOGIC;
    SIGNAL DE_PC_or_addrs1_en_out : STD_LOGIC;
    SIGNAL DE_FLAGS_en_out : STD_LOGIC;
    SIGNAL DE_RTI_en_out : STD_LOGIC;
    SIGNAL DE_OUT_en_out : STD_LOGIC;
    SIGNAL DE_Read_Address1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL DE_Read_Address2 : STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN
    --Internal Fetch Stage
    Internal_Fetch_Stage : Fetch_Stage PORT MAP(
        clk => clk,
        pc_rst => rst,
        JMP_en => JMP_en,
        CALL_en => CALL_en,
        MW_RTI_en_out => MW_RTI_en_out,
        MW_RET_en_out => MW_RET_en_out,
        PC_disable => PC_disable,
        en_load_use => en_load_use,
        en_structural => en_structural,
        DE_JZ_en_out => DE_JZ_en_out,
        ZF_OUT => ZF_OUT,
        DE_JC_en_out => DE_JC_en_out,
        CF_OUT => CF_OUT,
        IN_PC => IN_PC,
        IN_DATA => IN_DATA,
        Read_Address => Read_Address,
        Inst => Inst
    );
    --Internal FD Register
    Internal_FD_Register : FD_Register PORT MAP(
        clk => clk,
        rst => rst,
        en_structural => en_structural,
        en_load_use => en_load_use,
        ZF_OUT => ZF_OUT,
        DE_JZ_en_out => DE_JZ_en_out,
        CF_OUT => CF_OUT,
        DE_JC_en_out => DE_JC_en_out,
        DE_RET_en_out => DE_RET_en_out,
        EM_RET_en_out => EM_RET_en_out,
        MM_RET_en_out => MM_RET_en_out,
        DE_Interrupt_en_out => DE_Interrupt_en_out,
        Inst => Inst,
        Read_Address => Read_Address,
        IN_PORT => IN_PORT,
        FD_Inst_out => FD_Inst_out,
        FD_Read_Address_out => FD_Read_Address_out,
        FD_IN_PORT_out => FD_IN_PORT_out
    );

    --Internal Decode Stage
    Internal_Decode_Stage : Decode_Stage PORT MAP(
        clk => clk,
        Reg_File_rst => rst,
        FD_Inst => FD_Inst,
        FD_Read_Address => FD_Read_Address,
        FD_IN_PORT => FD_IN_PORT,
        DE_Read_Data1_out => DE_Read_Data1_out,
        MW_Read_Data_out => MW_Read_Data_out,
        MW_Write_Data => MW_Write_Data,
        MW_Write_Address => MW_Write_Address,
        MW_RegWrite_en => MW_RegWrite_en,
        MW_RET_en_out => MW_RET_en_out,
        DE_JZ_en_out => DE_JZ_en_out,
        DE_JC_en_out => DE_JC_en_out,
        MW_PC_or_addrs1_en_out => MW_PC_or_addrs1_en_out,
        MW_RTI_en_out => MW_RTI_en_out,
        ZF_OUT => ZF_OUT,
        CF_OUT => CF_OUT,
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
        MemRead_en => MemRead_en,
        SETC_en => SETC_en,
        CLRC_en => CLRC_en,
        JZ_en => JZ_en,
        JC_en => JC_en,
        SP_en => SP_en,
        SP_inc_en => SP_inc_en,
        RET_en => RET_en,
        OUT_en => OUT_en,
        RTI_en => RTI_en,
        CALL_en => CALL_en,
        JMP_en => JMP_en,
        Immediate_en => Immediate_en
    );

    --Internal DE Register
    Internal_DE_Register : DE_Register PORT MAP(
        clk => clk,
        en_structural => en_structural,
        rst => rst,
        IN_en => IN_en,
        RegWrite_en => RegWrite_en,
        Carry_en => Carry_en,
        ALU_en => ALU_en,
        Mem_to_Reg_en => Mem_to_Reg_en,
        MemWrite_en => MemWrite_en,
        MemRead_en => MemRead_en,
        FD_IN_PORT_out => FD_IN_PORT_out,
        Read_Data1 => Read_Data1,
        Read_Data2 => Read_Data2,
        Inst_20_to_18_Write_Addrs => Inst_20_to_18_Write_Addrs,
        Inst_31_to_27_OPCODE => Inst_31_to_27_OPCODE,
        SETC_en => SETC_en,
        CLRC_en => CLRC_en,
        JZ_en => JZ_en,
        JC_en => JC_en,
        SP_en => SP_en,
        SP_inc_en => SP_inc_en,
        RET_en => RET_en,
        CALL_en => CALL_en,
        PC_or_addrs1_en => PC_or_addrs1_en,
        FLAGS_en => FLAGS_en,
        RTI_en => RTI_en,
        OUT_en => OUT_en,
        Read_Address1 => Read_Address1,
        Read_Address2 => Read_Address2,
        Interrupt_en => Interrupt_en,
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
        DE_SETC_en_out => DE_SETC_en_out,
        DE_CLRC_en_out => DE_CLRC_en_out,
        DE_JZ_en_out => DE_JZ_en_out,
        DE_JC_en_out => DE_JC_en_out,
        DE_SP_en_out => DE_SP_en_out,
        DE_SP_inc_en_out => DE_SP_inc_en_out,
        DE_RET_en_out => DE_RET_en_out,
        DE_CALL_en_out => DE_CALL_en_out,
        DE_PC_or_addrs1_en_out => DE_PC_or_addrs1_en_out,
        DE_FLAGS_en_out => DE_FLAGS_en_out,
        DE_RTI_en_out => DE_RTI_en_out,
        DE_OUT_en_out => DE_OUT_en_out,
        DE_Interrupt_en_out => DE_Interrupt_en_out,
        DE_Read_Address1 => DE_Read_Address1,
        DE_Read_Address2 => DE_Read_Address2
    );

END ARCHITECTURE;