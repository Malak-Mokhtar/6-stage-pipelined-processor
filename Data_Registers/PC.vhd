LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY PC IS
    PORT (
        clk, rst, en : IN STD_LOGIC;
        IN_PC, IN_DATA : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Read_Address : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END PC;

ARCHITECTURE arch OF PC IS
BEGIN

    main_loop : PROCESS (clk)
    BEGIN
        IF rst = '1' THEN
            -- async reset
            -- Read_Address <= (OTHERS => '0');
            Read_Address <= IN_DATA;
            -- Read_Address <= IN_DATA;
        ELSIF (rising_edge(clk)) AND en = '1' THEN
            -- change PC on rising edge
            Read_Address <= IN_PC;
        END IF;
    END PROCESS; -- main_loop

END ARCHITECTURE;