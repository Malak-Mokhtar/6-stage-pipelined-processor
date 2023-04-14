-- vhdl-linter-disable component
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY processor IS
    PORT (
        clk, rst : IN STD_LOGIC;
        IN_Port : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END processor;

ARCHITECTURE arch OF processor IS
    --Fetch Stage Component
    COMPONENT Fetch_Stage IS
        PORT (
            clk, pc_rst, pc_en : IN STD_LOGIC;
            IN_PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            Read_Address : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            Inst : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    --Fetch Decode Register
    COMPONENT FD_Register IS
        PORT (
            clk, en, rst : IN STD_LOGIC;
            Inst : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Read_Address, IN_PORT : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            FD_Inst_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            FD_Read_Address_out, FD_IN_PORT_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;
    --------------------------------------------------------------------
    SIGNAL PC_en : STD_LOGIC := '1';
    SIGNAL FD_en : STD_LOGIC := '1';
    -------------------------------------------------------------
    --Fetch Stage
    SIGNAL Inst : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Read_Address : STD_LOGIC_VECTOR(15 DOWNTO 0);
    -- FD Register
    SIGNAL FD_Inst_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL FD_Read_Address_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL FD_IN_PORT_out : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

    --Fetch Stage
    Internal_Fetch_Stage : Fetch_Stage PORT MAP(
        clk => clk,
        pc_rst => rst,
        pc_en => PC_en, --TODO: add an input to pc_en
        IN_PC => "0000000000000101",
        Read_Address => Read_Address,
        Inst => Inst

    );

    -- FD Register
    Internal_FD_Register : FD_Register PORT MAP(
        --inputs
        clk => clk,
        en => FD_en,
        rst => rst,
        Inst => Inst,
        Read_Address => Read_Address,
        IN_Port => IN_Port,
        --------------------------
        --outputs
        FD_Inst_out => FD_Inst_out,
        FD_Read_Address_out => FD_Read_Address_out,
        FD_IN_PORT_out => FD_IN_PORT_out

    );
END ARCHITECTURE;