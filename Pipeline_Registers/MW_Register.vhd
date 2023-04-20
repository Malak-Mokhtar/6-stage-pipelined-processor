LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY MW_Register IS
    PORT (
        clk, en, rst, MM_IN_en_out, MM_RegWrite_en_out, MM_Mem_to_Reg_en_out : IN STD_LOGIC;
        MM_IN_PORT_out, MM_ALU_Out_out, Read_Data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        MM_Write_Addr_out : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

        MW_IN_en_out, MW_RegWrite_en_out, MW_Mem_to_Reg_en_out : OUT STD_LOGIC;
        MW_IN_PORT_out, MW_ALU_Out_out, MW_Read_Data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        MW_Write_Addr_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);

        EM_Memory_Reset_out : IN STD_LOGIC;
        MW_Memory_Reset_out : OUT STD_LOGIC
    );
END MW_Register;

ARCHITECTURE arch OF MW_Register IS

BEGIN
    main_loop : PROCESS (clk, rst)
    BEGIN

        IF rst = '1' THEN --check on reset
            --make all outputs zero
            MW_IN_en_out <= '0';
            MW_RegWrite_en_out <= '0';
            MW_IN_PORT_out <= (OTHERS => '0');
            MW_ALU_Out_out <= (OTHERS => '0');
            MW_Read_Data_out <= (OTHERS => '0');
            MW_Write_Addr_out <= (OTHERS => '0');
            MW_Mem_to_Reg_en_out <= '0';

        ELSIF falling_edge(clk) AND en = '1' THEN --check on enable and falling edge
            MW_IN_en_out <= MM_IN_en_out;
            MW_RegWrite_en_out <= MM_RegWrite_en_out;
            MW_IN_PORT_out <= MM_IN_PORT_out;
            MW_ALU_Out_out <= MM_ALU_Out_out;
            MW_Read_Data_out <= Read_Data;
            MW_Write_Addr_out <= MM_Write_Addr_out;
            MW_Mem_to_Reg_en_out <= MM_Mem_to_Reg_en_out;
        END IF;
        IF falling_edge(clk) THEN
            MW_Memory_Reset_out <= EM_Memory_Reset_out;

        END IF;
    END PROCESS; -- main_loop

END ARCHITECTURE;