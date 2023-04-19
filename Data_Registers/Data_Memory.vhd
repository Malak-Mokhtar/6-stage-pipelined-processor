LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Data_Memory IS
    PORT (
        Address, Write_Data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        clk, Rst, MemWrite_en, MemRead_en : IN STD_LOGIC;
        Read_Data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END Data_Memory;

ARCHITECTURE arch OF Data_Memory IS

    TYPE Mem_type IS ARRAY (0 TO 1024) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL memory_data : Mem_type;
    --SIGNAL Address_sig1, Write_Data_sig1: STD_LOGIC_VECTOR(15 DOWNTO 0);
    --SIGNAL Rst_sig1, MemWrite_en_sig1, MemRead_en_sig1 : STD_LOGIC;

BEGIN

    main_loop : PROCESS (clk, Rst)
    BEGIN
        --async reset
        IF Rst = '1' AND falling_edge(clk) THEN
            -- memory_data <= (OTHERS => (OTHERS => '0'));
            Read_Data <= memory_data(0);
        ELSIF falling_edge(clk) THEN
            IF MemWrite_en = '1' THEN --write data
                memory_data(to_integer(unsigned(Address))) <= Write_Data;
                Read_Data <= (OTHERS => '-');--read data is don't care
            ELSIF MemRead_en = '1' THEN --read data
                Read_Data <= memory_data(to_integer(unsigned(Address)));
            ELSE
                Read_Data <= (OTHERS => '-');--read data is don't care
            END IF;
        END IF;
    END PROCESS; -- main_loop

END ARCHITECTURE;