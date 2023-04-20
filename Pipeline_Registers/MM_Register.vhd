LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY MM_Register IS
    PORT (
        clk, en, rst : IN STD_LOGIC;
        EM_IN_en_out : IN STD_LOGIC;
        EM_IN_PORT_out, EM_ALU_Out_out : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        EM_Write_Addr_out : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        EM_RegWrite_en_out, EM_Mem_to_Reg_en_out : IN STD_LOGIC;

        MM_IN_en_out : OUT STD_LOGIC;
        MM_IN_PORT_out, MM_ALU_Out_out : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        MM_Write_Addr_out : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        MM_RegWrite_en_out, MM_Mem_to_Reg_en_out : OUT STD_LOGIC;
        EM_Memory_Reset_out : IN STD_LOGIC;
        MM_Memory_Reset_out : OUT STD_LOGIC
    );
END MM_Register;

ARCHITECTURE arch OF MM_Register IS

BEGIN
    main_loop : PROCESS (clk, rst)
    BEGIN

        IF rst = '1' THEN --check on reset
            --make all outputs zero
            MM_IN_en_out <= '0';
            MM_IN_PORT_out <= (OTHERS => '0');
            MM_Write_Addr_out <= (OTHERS => '0');
            MM_ALU_Out_out <= (OTHERS => '0');
            MM_RegWrite_en_out <= '0';
            MM_Mem_to_Reg_en_out <= '0';
        ELSIF falling_edge(clk) AND en = '1' THEN --check on enable and falling edge
            MM_IN_en_out <= EM_IN_en_out;
            MM_IN_PORT_out <= EM_IN_PORT_out;
            MM_ALU_Out_out <= EM_ALU_Out_out;
            MM_Write_Addr_out <= EM_Write_Addr_out;
            MM_RegWrite_en_out <= EM_RegWrite_en_out;
            MM_Mem_to_Reg_en_out <= EM_Mem_to_Reg_en_out;
        END IF;
        IF falling_edge(clk) THEN
            MM_Memory_Reset_out <= EM_Memory_Reset_out;

        END IF;
    END PROCESS; -- main_loop

END arch;