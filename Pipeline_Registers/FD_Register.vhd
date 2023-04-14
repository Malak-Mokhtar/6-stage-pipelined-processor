LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY FD_Register IS
    PORT (
        clk, en, rst : IN STD_LOGIC;
        Inst : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Read_Address, IN_PORT : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        FD_Inst_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        FD_Read_Address_out, FD_IN_PORT_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END FD_Register;

ARCHITECTURE arch OF FD_Register IS

BEGIN
    main_loop : PROCESS (clk, rst)
    BEGIN

        IF rst = '1' THEN --check on reset
            --make all outputs zero
            FD_Inst_out <= (OTHERS => '0');
            FD_Read_Address_out <= (OTHERS => '0');
            FD_IN_PORT_out <= (OTHERS => '0');
        ELSIF falling_edge(clk) AND en = '1' THEN --check on enable and falling edge
            FD_Inst_out <= Inst;
            FD_Read_Address_out <= Read_Address;
            FD_IN_PORT_out <= IN_PORT;
        END IF;
    END PROCESS; -- main_loop

END ARCHITECTURE;