LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY DE_Register IS
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
END DE_Register;

ARCHITECTURE arch OF DE_Register IS

BEGIN
    main_loop : PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN --check on reset
            --make all outputs zero
            DE_IN_en_out <= '0';
            DE_IN_PORT_out <= (OTHERS => '0');
            DE_Write_Addr_out <= (OTHERS => '0');
            DE_RegWrite_en_out <= '0';
            DE_Carry_en_out <= '0';
            DE_ALU_en_out <= '0';
            DE_OPCODE_out <= (OTHERS => '0');
            DE_Read_Data1_out <= (OTHERS => '0');
            DE_Read_Data2_out <= (OTHERS => '0');
            DE_Mem_to_Reg_en_out <= '0';
            DE_MemWrite_en_out <= '0';
            DE_MemRead_en_out <= '0';

        ELSIF falling_edge(clk) AND en = '1' THEN --check on enable and falling edge
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

        END IF;
    END PROCESS; -- main_loop

END ARCHITECTURE;