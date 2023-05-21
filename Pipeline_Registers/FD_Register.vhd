LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY FD_Register IS
    PORT (
        clk, en_structural, en_load_use : IN STD_LOGIC;
        rst, ZF_OUT, DE_JZ_en_out, CF_OUT, DE_JC_en_out, DE_RET_en_out, EM_RET_en_out, MM_RET_en_out,MW_RET_en_out, DE_Interrupt_en_out, --
        DE_RTI_en_out, EM_RTI_en_out, MM_RTI_en_out, DE_CALL_en_out, DE_JMP_en_out, Interrupt: IN STD_LOGIC;
        Inst : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Read_Address, IN_PORT : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        FD_Inst_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        FD_Read_Address_out, FD_IN_PORT_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        FD_Interrupt_Signal_out : OUT STD_LOGIC;
    );
END FD_Register;

ARCHITECTURE arch OF FD_Register IS

signal en: std_logic;
signal pipelined_rst: std_logic;
signal Zero_rst,Carry_rst,RET_rst, RTI_rst : std_logic;

BEGIN

    en<= (en_structural) NOR (en_load_use);

    Zero_rst <= ZF_OUT and DE_JZ_en_out;
    Carry_rst <= CF_OUT and DE_JC_en_out;
    RET_rst <= DE_RET_en_out or EM_RET_en_out or MM_RET_en_out or MW_RET_en_out;
    RTI_rst <= DE_RTI_en_out or EM_RTI_en_out or MM_RTI_en_out;

    pipelined_rst<= rst or Zero_rst or Carry_rst or RET_rst or DE_Interrupt_en_out or RTI_rst or DE_CALL_en_out or DE_JMP_en_out;

    main_loop : PROCESS (clk, pipelined_rst)
    BEGIN
        IF pipelined_rst = '1' and rising_edge(clk) THEN --check on reset
            --make all outputs zero
            FD_Inst_out <= (OTHERS => '0');
            FD_Read_Address_out <= (OTHERS => '0');
            FD_IN_PORT_out <= (OTHERS => '0');
            FD_Interrupt_Signal_out <= '0';
        ELSIF falling_edge(clk) AND en = '1' THEN --check on enable and falling edge
            FD_Inst_out <= Inst;
            FD_Read_Address_out <= Read_Address;
            FD_IN_PORT_out <= IN_PORT;
            FD_Interrupt_Signal_out <= Interrupt;
        END IF;
    END PROCESS; -- main_loop

END ARCHITECTURE;