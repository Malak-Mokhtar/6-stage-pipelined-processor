LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ED_Register IS
    PORT (
        clk, en, rst, DE_IN_en_out, DE_RegWrite_en_out, DE_Mem_to_Reg_en_out, DE_MemWrite_en_out, DE_MemRead_en_out : IN STD_LOGIC;
        DE_IN_PORT_out, ALU_Out, DE_Read_Data1_out, DE_Read_Data2_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        DE_Write_Addr_out : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        
        EM_IN_en_out, EM_RegWrite_en_out, EM_Mem_to_Reg_en_out, EM_MemWrite_en_out, EM_MemRead_en_out   : OUT STD_LOGIC;
        EM_IN_PORT_out, EM_ALU_Out_out,EM_Read_Data1_out,EM_Read_Data2_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        EM_Write_Addr_out : OUT STD_LOGIC_VECTOR(2 downto 0)
    );
END ED_Register;

ARCHITECTURE arch OF ED_Register IS

BEGIN
    main_loop : PROCESS (clk, rst)
    BEGIN

        IF rst = '1' THEN --check on reset
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
            EM_Read_Data2_out<= (OTHERS => '0');
            
        ELSIF falling_edge(clk) AND en = '1' THEN --check on enable and falling edge
            EM_Write_Addr_out <= DE_Write_Addr_out;
            EM_IN_en_out <= DE_IN_en_out;
            EM_RegWrite_en_out <= DE_RegWrite_en_out;
            EM_Mem_to_Reg_en_out <= DE_Mem_to_Reg_en_out;
            EM_MemWrite_en_out <= DE_MemWrite_en_out;
            EM_MemRead_en_out <= DE_MemRead_en_out;
            EM_IN_PORT_out <= DE_IN_PORT_out;
            EM_ALU_Out_out <= ALU_Out;
            EM_Read_Data1_out <= DE_Read_Data1_out;
            EM_Read_Data2_out <= DE_Read_Data2_out;
        END IF;
    END PROCESS; -- main_loop

END ARCHITECTURE;