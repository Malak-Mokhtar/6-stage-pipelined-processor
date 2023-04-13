LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Carry_flag IS
    PORT (
        DE_JC_en_out : IN STD_LOGIC;
	DE_SETC_en_out : IN STD_LOGIC;
	DE_CLRC_en_out : IN STD_LOGIC;
	DE_Carry_en_out : IN STD_LOGIC;
	CF_ALU : in STD_LOGIC;
	CF_OUT: out std_logic;
	clk, rst : IN STD_LOGIC);
END Carry_flag;

ARCHITECTURE my_carry_flag OF carry_flag IS
   component DFF IS
    PORT (
        d, clk, rst, enable : IN STD_LOGIC;
        q : OUT STD_LOGIC);
    end component;


signal d1 : STD_LOGIC;
signal q1 : STD_LOGIC;


BEGIN


d1 <= not DE_JC_en_out and ((not DE_CLRC_en_out and CF_ALU) or (not DE_CLRC_en_out and DE_SETC_en_out));
CF_OUT <= q1;

my_DFF : DFF PORT MAP(d1, clk, rst, DE_Carry_en_out, q1);


		  
END my_carry_flag;