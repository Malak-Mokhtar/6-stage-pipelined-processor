LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Memory_Stages IS
    PORT (
        --INPUT PORTS    
        clk, general_rst : IN STD_LOGIC;
        EM_IN_en_out,
        EM_RegWrite_en_out,
        EM_Mem_to_Reg_en_out,
        EM_MemWrite_en_out,
        EM_MemRead_en_out,
        -- Phase 2:
        EM_SP_en_out,
        EM_SP_inc_en_out,
        EM_PC_or_addrs1_en_out,
        EM_FLAGS_en_out,
        EM_Interrupt_en_out,
        EM_ZF_OUT_out,
        EM_CF_OUT_out,
        EM_NF_OUT_out : IN STD_LOGIC;
        --
        EM_IN_PORT_out,
        EM_ALU_Out_out,
        EM_Read_Data1_out,
        -- Phase 2:
        EM_SP_before_out,
        EM_SP_after_out,
        Read_Address : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        --
        EM_Write_Addr_out : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        EM_Memory_Reset_out : IN STD_LOGIC;

        -- OUTPUT PORTS
        MM_IN_en,
        MM_RegWrite_en,
        MM_Mem_to_Reg_en : OUT STD_LOGIC;
        MM_Write_Addr : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        MM_IN_PORT,
        MM_ALU_Out,
        Read_Data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        MM_Memory_Reset_out : OUT STD_LOGIC;
        MM_Interrupt_en_out : OUT STD_LOGIC;
        -- Phase 2 Inputs:
        EM_RTI_en_out,
        EM_OUT_en_out,
        EM_RET_en_out,
        EM_CALL_en_out : IN STD_LOGIC;

        -- Phase 2 Outputs
        MM_RET_en_out,
        MM_CALL_en_out,
        MM_PC_or_addrs1_en_out,
        MM_RTI_en_out,
        MM_OUT_en_out,
        MM_FLAGS_en_out : OUT STD_LOGIC

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

    -- Phase 2
    -- Read address MUX
    COMPONENT MUX_MEM_ADD IS
        PORT (
            Read_Data1, SP_Before, SP_After : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            SP_en, SP_inc_en, PC_or_addr1_en : IN STD_LOGIC;
            Read_Addrs : OUT STD_LOGIC_VECTOR (15 DOWNTO 0));
    END COMPONENT;

    -- Read Data MUX
    COMPONENT MUX_MEM_DATA IS
        PORT (
            ALU_out, Read_Address, Flags : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            Flags_en, Interrupt_en : IN STD_LOGIC;
            Read_Data : OUT STD_LOGIC_VECTOR (15 DOWNTO 0));
    END COMPONENT;

    -- Flag concatenation and extension module
    COMPONENT Concatenation_Extension IS
        PORT (
            ZF_OUT, CF_OUT, NF_OUT : IN STD_LOGIC;
            Flags : OUT STD_LOGIC_VECTOR (15 DOWNTO 0));
    END COMPONENT;

    ------------------
    -- Memory memory pipelined register
    COMPONENT MM_Register IS
    PORT (
        clk, en, rst : IN STD_LOGIC;
        EM_IN_en_out : IN STD_LOGIC;
        EM_IN_PORT_out, EM_ALU_Out_out : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        EM_Write_Addr_out : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        EM_RegWrite_en_out, EM_Mem_to_Reg_en_out, EM_Interrupt_en_out : IN STD_LOGIC;
        -- Phase 2 Inputs:
        EM_RTI_en_out,
        EM_OUT_en_out,
        EM_RET_en_out,
        EM_CALL_en_out,
        EM_FLAGS_en_out,
        EM_PC_or_addrs1_en_out : IN STD_LOGIC;
        MM_IN_en_out : OUT STD_LOGIC;
        MM_IN_PORT_out, MM_ALU_Out_out : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        MM_Write_Addr_out : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        MM_RegWrite_en_out, MM_Mem_to_Reg_en_out : OUT STD_LOGIC;
        EM_Memory_Reset_out : IN STD_LOGIC;
        MM_Memory_Reset_out, MM_FLAGS_en_out, MM_Interrupt_en_out : OUT STD_LOGIC;
        -- Phase 2 Outputs
        MM_RET_en_out,
        MM_CALL_en_out,
        MM_PC_or_addrs1_en_out,
        MM_RTI_en_out,
        MM_OUT_en_out : OUT STD_LOGIC
    );
    END COMPONENT;

    COMPONENT Stack_Pointer IS
        PORT (
            clk, rst, en : IN STD_LOGIC;
            data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            out_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT SP_ALU IS
    PORT (
        clk,SP_en, inc_en : IN STD_LOGIC;
        sp_before : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        sp_after : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
    END COMPONENT;

    -------------------SIGNALS----------------
    SIGNAL MM_en : STD_LOGIC := '1';
    -- Phase 2
    SIGNAL Read_Data1, Read_Data2, Flags_sig,  SP_before_sig, SP_after_sig : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN

    Data_memory_MAP : Data_Memory PORT MAP(
        Address => Read_Data1, -- Phase 2
        Write_Data => Read_Data2,
        clk => clk,
        Rst => EM_Memory_Reset_out,
        MemWrite_en => EM_MemWrite_en_out,
        MemRead_en => EM_MemRead_en_out,
        Read_Data => Read_Data
    );

    MUX_MEM_ADD_MAP : MUX_MEM_ADD PORT MAP(
        Read_Data1 => EM_Read_Data1_out,
        SP_Before => SP_before_sig,
        SP_After => SP_after_sig,
        SP_en => EM_SP_en_out,
        SP_inc_en => EM_SP_inc_en_out,
        PC_or_addr1_en => EM_PC_or_addrs1_en_out,
        Read_Addrs => Read_Data1
    );

    MUX_MEM_DATA_MAP : MUX_MEM_DATA PORT MAP(
        ALU_out => EM_ALU_Out_out,
        Read_Address => Read_Address,
        Flags => Flags_sig,
        Flags_en => EM_FLAGS_en_out,
        Interrupt_en => EM_Interrupt_en_out,
        Read_Data => Read_Data2
    );

    Concatenation_Extension_MAP : Concatenation_Extension PORT MAP(
        ZF_OUT => EM_ZF_OUT_out,
        CF_OUT => EM_CF_OUT_out,
        NF_OUT => EM_NF_OUT_out,
        Flags => Flags_sig
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
        EM_Mem_to_Reg_en_out => EM_Mem_to_Reg_en_out,
        EM_RTI_en_out => EM_RTI_en_out,
        EM_OUT_en_out => EM_OUT_en_out,
        EM_RET_en_out => EM_RET_en_out,
        EM_CALL_en_out => EM_CALL_en_out,
        EM_PC_or_addrs1_en_out => EM_PC_or_addrs1_en_out,
        MM_IN_en_out => MM_IN_en,
        MM_IN_PORT_out => MM_IN_PORT,
        MM_ALU_Out_out => MM_ALU_Out,
        MM_Write_Addr_out => MM_Write_Addr,
        MM_RegWrite_en_out => MM_RegWrite_en,
        MM_Mem_to_Reg_en_out => MM_Mem_to_Reg_en,
        EM_Memory_Reset_out => EM_Memory_Reset_out,
        MM_Memory_Reset_out => MM_Memory_Reset_out,
        MM_RET_en_out => MM_RET_en_out,
        MM_CALL_en_out => MM_CALL_en_out,
        MM_PC_or_addrs1_en_out => MM_PC_or_addrs1_en_out,
        MM_RTI_en_out => MM_RTI_en_out,
        MM_OUT_en_out => MM_OUT_en_out,
        EM_FLAGS_en_out => EM_FLAGS_en_out,
        MM_FLAGS_en_out => MM_FLAGS_en_out,
        EM_Interrupt_en_out => EM_Interrupt_en_out,
        MM_Interrupt_en_out => MM_Interrupt_en_out
    );

    Stack_Pointer_MAP : Stack_Pointer PORT MAP(
        clk => clk,
        rst => general_rst,
        en => EM_SP_en_out,
        data => SP_after_sig,
        out_data => SP_before_sig
    );

    SP_ALU_MAP : SP_ALU PORT MAP(
        clk => clk,
        SP_en => EM_SP_en_out,
        inc_en => EM_SP_inc_en_out,
        SP_after => SP_after_sig,
        SP_before => SP_before_sig
    );

END ARCHITECTURE;