LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY DE_Register IS
    PORT (
        clk, en_structural, en_load_use, rst : IN STD_LOGIC;
        IN_en, RegWrite_en, Carry_en, ALU_en, Mem_to_Reg_en, MemWrite_en, MemRead_en, PC_disable, Immediate_en : IN STD_LOGIC;
        FD_IN_PORT_out, Read_Data1, Read_Data2: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Inst_20_to_18_Write_Addrs : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Inst_31_to_27_OPCODE : IN STD_LOGIC_VECTOR(4 DOWNTO 0);

        DE_IN_en_out, DE_RegWrite_en_out, DE_Carry_en_out, DE_ALU_en_out, DE_Mem_to_Reg_en_out, DE_MemWrite_en_out, DE_MemRead_en_out, DE_PC_disable_out, DE_en_load_use_out : OUT STD_LOGIC;
        DE_IN_PORT_out, DE_Read_Data1_out, DE_Read_Data2_out: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
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
        JMP_en : IN STD_LOGIC;
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
        DE_JMP_en_out : OUT STD_LOGIC;
        DE_PC_or_addrs1_en_out : OUT STD_LOGIC;
        DE_FLAGS_en_out : OUT STD_LOGIC;
        DE_RTI_en_out : OUT STD_LOGIC;
        DE_OUT_en_out : OUT STD_LOGIC;
        DE_Interrupt_en_out : OUT STD_LOGIC;
        DE_Immediate_en_out : OUT STD_LOGIC;
        DE_Read_Address1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        DE_Read_Address2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)

    );
END DE_Register;

ARCHITECTURE arch OF DE_Register IS
signal pipelined_rst: std_logic;
BEGIN
    pipelined_rst<= rst OR en_load_use;
    main_loop : PROCESS (clk, pipelined_rst)
    BEGIN
        IF (pipelined_rst = '1' and falling_edge(clk)) THEN --check on reset
            DE_IN_en_out <= '0';
            DE_RegWrite_en_out <= '0';
            DE_Carry_en_out <= '0';
            DE_ALU_en_out <= '0';
            DE_Mem_to_Reg_en_out <= '0';
            DE_MemWrite_en_out <= '0';
            DE_MemRead_en_out <= '0';
            DE_IN_PORT_out <= (OTHERS => '0');
            DE_Read_Data1_out <= (OTHERS => '0');
            DE_Read_Data2_out <= (OTHERS => '0');
            DE_Write_Addr_out <= (OTHERS => '0');
            DE_OPCODE_out <= (OTHERS => '0');
            DE_SETC_en_out <= '0';
            DE_CLRC_en_out <= '0';
            DE_JZ_en_out <= '0';
            DE_JC_en_out <= '0';
            DE_SP_en_out <= '0';
            DE_SP_inc_en_out <= '0';
            DE_RET_en_out <= '0';
            DE_CALL_en_out <= '0';
            DE_JMP_en_out <= '0';
            DE_PC_or_addrs1_en_out <= '0';
            DE_FLAGS_en_out <= '0';
            DE_RTI_en_out <= '0';
            DE_OUT_en_out <= '0';
            DE_Interrupt_en_out <= '0';
            DE_Read_Address1 <= (OTHERS => '0');
            DE_Read_Address2 <= (OTHERS => '0');
            DE_PC_disable_out <= '0';
            DE_Immediate_en_out <= '0';
            DE_en_load_use_out <= en_load_use;

        ELSIF falling_edge(clk) AND en_structural = '0' THEN --check on enable and falling edge
            DE_IN_en_out <= IN_en;
            DE_IN_PORT_out <= FD_IN_PORT_out;
            DE_Write_Addr_out <= Inst_20_to_18_Write_Addrs;
            DE_RegWrite_en_out <= RegWrite_en;
            DE_Carry_en_out <= Carry_en;
            DE_ALU_en_out <= ALU_en;
            DE_OPCODE_out <= Inst_31_to_27_OPCODE;
            DE_Read_Data1_out <= Read_Data1;
            DE_Read_Data2_out <= Read_Data2;
            DE_Mem_to_Reg_en_out <= Mem_to_Reg_en;
            DE_MemWrite_en_out <= MemWrite_en;
            DE_MemRead_en_out <= MemRead_en;

            --phase 2 code
            DE_SETC_en_out <= SETC_en;
            DE_CLRC_en_out <= CLRC_en;
            DE_JZ_en_out <= JZ_en;
            DE_JC_en_out <= JC_en;
            DE_SP_en_out <= SP_en;
            DE_SP_inc_en_out <= SP_inc_en;
            DE_RET_en_out <= RET_en;
            DE_CALL_en_out <= CALL_en;
            DE_JMP_en_out <= JMP_en;
            DE_PC_or_addrs1_en_out <= PC_or_addrs1_en;
            DE_FLAGS_en_out <= FLAGS_en;
            DE_RTI_en_out <= RTI_en;
            DE_OUT_en_out <= OUT_en;
            DE_Read_Address1 <= Read_Address1;
            DE_Read_Address2 <= Read_Address2;
            DE_Interrupt_en_out <= Interrupt_en;
            DE_PC_disable_out <= PC_disable;
            DE_Immediate_en_out <= Immediate_en;
            DE_en_load_use_out <= en_load_use;
            
        END IF;
    END PROCESS; -- main_loop

END ARCHITECTURE;