LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Reg_file IS
    PORT (
        clk, Rst, write_en : IN STD_LOGIC;
        Read_Address1, Read_Address2, Write_Addesss : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Read_Data1, Read_Data2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Write_Data : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END Reg_file;

ARCHITECTURE arch OF Reg_file IS

    TYPE reg_type IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR(15 DOWNTO 0);

    SIGNAL register_data : reg_type;

BEGIN

    main_loop : PROCESS (clk, Rst)
    BEGIN
        IF Rst = '1' THEN
            register_data <= (OTHERS => (OTHERS => '0'));
        ELSIF rising_edge(clk) AND write_en = '1' THEN

            register_data(to_integer(unsigned((Write_Addesss)))) <= Write_Data;

        END IF;
    END PROCESS; -- main_loop

    -- ask if it needs to be synchronized
    Read_Data1 <= register_data(to_integer(unsigned((Read_Address1))));
    Read_Data2 <= register_data(to_integer(unsigned((Read_Address2))));
END ARCHITECTURE;