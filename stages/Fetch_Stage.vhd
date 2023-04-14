LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Fetch_Stage IS
    PORT (
        clk, pc_rst, pc_en : IN STD_LOGIC;
        IN_PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Read_Address : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Inst : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END Fetch_Stage;

ARCHITECTURE arch OF Fetch_Stage IS

    SIGNAL Internal_Read_Address : STD_LOGIC_VECTOR(15 DOWNTO 0);

    --PC component
    COMPONENT PC IS
        PORT (
            clk, rst, en : IN STD_LOGIC;
            IN_PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            Read_Address : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;
    --Instruction Memory component
    COMPONENT Instruction_Memory IS
        PORT (
            -- clk: IN STD_LOGIC;
            Read_Address : IN STD_LOGIC_VECTOR(15 DOWNTO 0); --input read address

            Inst : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

BEGIN

    Internal_PC : PC PORT MAP(
        clk => clk,
        rst => pc_rst,
        en => pc_en,
        IN_PC => IN_PC,
        Read_Address => Internal_Read_Address
    );
    Internal_Instruction_Memory : Instruction_Memory PORT MAP(
        Read_Address => Internal_Read_Address,
        Inst => Inst
    );
    Read_Address <= Internal_Read_Address;

END ARCHITECTURE;