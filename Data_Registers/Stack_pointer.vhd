LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Stack_Pointer IS
    PORT (
        clk, rst, en : IN STD_LOGIC;
        data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        out_data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END Stack_Pointer;

ARCHITECTURE arch OF Stack_Pointer IS
    SIGNAL data_signal : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN

    main_loop : PROCESS (clk, Rst)
    BEGIN
        IF rst = '1' THEN
            data_signal <= (OTHERS => '0');
        ELSIF rising_edge(clk) AND en = '1' THEN
            data_signal <= data;

        END IF;
    END PROCESS; -- main_loop
    out_data <= data_signal;
END ARCHITECTURE;