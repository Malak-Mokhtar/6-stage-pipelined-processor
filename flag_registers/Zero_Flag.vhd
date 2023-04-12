LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Zero_Flag IS
    PORT (
        DE_JZ_en_out : IN STD_LOGIC;
	DE_ALU_en_out : IN STD_LOGIC;
	ZF_ALU : IN STD_LOGIC;
	ZF_OUT : out STD_LOGIC;
	clk, rst : IN STD_LOGIC);
END Zero_Flag;

ARCHITECTURE my_Zero_Flag OF Zero_flag IS
   component DFF IS
    PORT (
        d, clk, rst, enable : IN STD_LOGIC;
        q : OUT STD_LOGIC);
    end component;


signal d1 : STD_LOGIC;
signal q1 : STD_LOGIC;
signal enable : std_logic;


BEGIN

enable <= DE_JZ_en_out or DE_ALU_en_out;
d1 <= ZF_ALU and not DE_JZ_en_out;
ZF_OUT <= q1;


my_DFF : DFF PORT MAP(d1, clk, rst, enable, q1);


		  
END my_Zero_Flag;