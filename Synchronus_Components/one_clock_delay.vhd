LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY one_clock_delay IS
    PORT (
        clk : IN STD_LOGIC;
        IN_DATA : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        OUT_DATA : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

    );
END one_clock_delay;

ARCHITECTURE arch OF one_clocks_delay IS

    SIGNAL data : STD_LOGIC_VECTOR(15 DOWNTO 0) := x"0000";

BEGIN

    main_loop : PROCESS (clk)
    BEGIN
        IF (rising_edge(clk)) THEN
            data <= IN_DATA;
        END IF;
    END PROCESS; -- main_loop
    OUT_DATA <= data;
END ARCHITECTURE;