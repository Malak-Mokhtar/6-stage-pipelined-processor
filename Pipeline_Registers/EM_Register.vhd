LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY EM_Register IS
    PORT (
        clk, en, rst, DE_IN_en_out, DE_RegWrite_en_out, DE_Mem_to_Reg_en_out, DE_MemWrite_en_out, DE_MemRead_en_out : IN STD_LOGIC;
        DE_IN_PORT_out, ALU_Out,
        DE_Read_Data1_final_out, DE_Read_Data2_final_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- Edited in Phase 2
        DE_Write_Addr_out : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        -- Phase 2 Inputs:
        en_structural,
        DE_RTI_en_out,
        DE_RET_en_out,
        DE_CALL_en_out,
        DE_PC_or_addrs1_out,
        DE_FLAGS_en_out,
        ZF_OUT,
        CF_OUT,
        NF_OUT,
        DE_Carry_en_out,
        DE_OUT_en_out,
        DE_Interrupt_en_out,
        DE_SP_en_out,
        DE_SP_inc_en_out,
        DE_en_load_use_out : IN STD_LOGIC;

        EM_IN_en_out, EM_RegWrite_en_out, EM_Mem_to_Reg_en_out, EM_MemWrite_en_out, EM_MemRead_en_out : OUT STD_LOGIC;
        EM_IN_PORT_out, EM_ALU_Out_out, EM_Read_Data1_out, EM_Read_Data2_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        EM_Write_Addr_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);

        Memory_Reset_in : IN STD_LOGIC;
        EM_Memory_Reset_out : OUT STD_LOGIC;

        -- Phase 2 Outputs:
        EM_SP_en_out,
        EM_SP_inc_en_out,
        EM_RET_en_out,
        EM_CALL_en_out,
        EM_PC_or_addrs1_out,
        EM_FLAGS_en_out,
        EM_ZF_OUT_out,
        EM_CF_OUT_out,
        EM_NF_OUT_out,
        EM_Carry_en_out,
        EM_RTI_en_out,
        EM_OUT_en_out,
        EM_Interrupt_en_out,
        EM_en_load_use_out : OUT STD_LOGIC;
        DE_RTI_FLAGS_en_out : IN STD_LOGIC;
        EM_RTI_FLAGS_en_out : OUT STD_LOGIC
    );
END EM_Register;

ARCHITECTURE arch OF EM_Register IS

    SIGNAL pipelined_rst : STD_LOGIC;

BEGIN

    pipelined_rst <= rst OR en_structural;

    main_loop : PROCESS (clk, pipelined_rst)
    BEGIN

        IF (pipelined_rst = '1' and falling_edge(clk)) THEN --check on reset
            --make all outputs zero
            EM_IN_en_out <= '0';
            EM_RegWrite_en_out <= '0';
            EM_Mem_to_Reg_en_out <= '0';
            EM_MemWrite_en_out <= '0';
            EM_MemRead_en_out <= '0';
            EM_Write_Addr_out <= (OTHERS => '0');
            EM_IN_PORT_out <= (OTHERS => '0');
            EM_ALU_Out_out <= (OTHERS => '0');
            EM_Read_Data1_out <= (OTHERS => '0');
            EM_Read_Data2_out <= (OTHERS => '0');
            EM_RET_en_out <= '0';
            EM_CALL_en_out <= '0';
            EM_PC_or_addrs1_out <= '0';
            EM_FLAGS_en_out <= '0';
            EM_ZF_OUT_out <= '0';
            EM_CF_OUT_out <= '0';
            EM_NF_OUT_out <= '0';
            EM_Carry_en_out <= '0';
            EM_RTI_en_out <= '0';
            EM_OUT_en_out <= '0';
            EM_Interrupt_en_out <= '0';
            EM_SP_en_out <= '0';
            EM_SP_inc_en_out <= '0';
            EM_en_load_use_out <= '0';
            EM_RTI_FLAGS_en_out <= '0';

        ELSIF (falling_edge(clk) AND (en = '1')) and en_structural = '0' THEN --check on enable and falling edge
            EM_Write_Addr_out <= DE_Write_Addr_out;
            EM_IN_en_out <= DE_IN_en_out;
            EM_RegWrite_en_out <= DE_RegWrite_en_out;
            EM_Mem_to_Reg_en_out <= DE_Mem_to_Reg_en_out;
            EM_MemWrite_en_out <= DE_MemWrite_en_out;
            EM_MemRead_en_out <= DE_MemRead_en_out;
            EM_IN_PORT_out <= DE_IN_PORT_out;
            EM_ALU_Out_out <= ALU_Out;
            EM_Read_Data1_out <= DE_Read_Data1_final_out;
            EM_Read_Data2_out <= DE_Read_Data2_final_out;
            EM_RET_en_out <= DE_RET_en_out;
            EM_CALL_en_out <= DE_CALL_en_out;
            EM_PC_or_addrs1_out <= DE_PC_or_addrs1_out;
            EM_FLAGS_en_out <= DE_FLAGS_en_out;
            EM_ZF_OUT_out <= ZF_OUT;
            EM_CF_OUT_out <= CF_OUT;
            EM_NF_OUT_out <= NF_OUT;
            EM_Carry_en_out <= DE_Carry_en_out;
            EM_RTI_en_out <= DE_RTI_en_out;
            EM_OUT_en_out <= DE_OUT_en_out;
            EM_Interrupt_en_out <= DE_Interrupt_en_out;
            EM_SP_en_out <= DE_SP_en_out;
            EM_SP_inc_en_out <= DE_SP_inc_en_out;
            EM_en_load_use_out <= DE_en_load_use_out;
            EM_RTI_FLAGS_en_out <= DE_RTI_FLAGS_en_out;
        END IF;
        IF falling_edge(clk) THEN
            EM_Memory_Reset_out <= Memory_Reset_in;

        END IF;
    END PROCESS; -- main_loop

END ARCHITECTURE;