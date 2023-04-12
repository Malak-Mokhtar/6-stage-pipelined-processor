LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY FD_Register IS
    PORT (
        clk, en, rst : IN STD_LOGIC;
        IN_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        OUT_Data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END FD_Register;

ARCHITECTURE arch OF FD_Register IS

    SIGNAL data : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
    main_loop : PROCESS (clk, rst)
    BEGIN

        IF rst = '1' THEN --check on reset
            data <= (OTHERS => '0');
        ELSIF falling_edge(clk) AND en = '1' THEN --check on enable and falling edge
            data <= IN_data;
        END IF;
    END PROCESS; -- main_loop
    OUT_Data <= data;
END ARCHITECTURE;