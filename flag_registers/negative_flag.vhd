LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Negative_flag IS
    PORT (NF_ALU : in std_logic;
	  DE_ALU_en_out : in std_logic;
	  NF_OUT: out std_logic;
	  clk, rst : in std_logic);
END Negative_flag;

ARCHITECTURE my_Negative_flag OF Negative_flag IS
   component DFF IS
    PORT (
        d, clk, rst, enable : IN STD_LOGIC;
        q : OUT STD_LOGIC);
    end component;


signal d1 : STD_LOGIC;
signal q1 : STD_LOGIC;


BEGIN


d1 <= NF_ALU;
NF_OUT <= q1;

my_DFF : DFF PORT MAP(d1, clk, rst, DE_ALU_en_out, q1);


		  
END my_Negative_flag;