library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;



entity full_adder is

      port(a,b : IN std_logic_vector (15 downto 0);
		cin: IN std_logic;
		c: out std_logic_vector (15 downto 0);
		cout: out std_logic);
		
end full_adder;


architecture my_full_adder of full_adder is

component one_bit_adder is 
	
	  Port (a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           cin : in  STD_LOGIC;
           sum : out  STD_LOGIC;
           cout : out  STD_LOGIC);

end component;

signal temp: std_logic_vector(16 downto 0);

begin

temp(0) <= cin;

loop_generate: for i in 0 to 15 generate
				 adder: one_bit_adder port map(a(i),b(i),temp(i),c(i),temp(i+1));
end generate;

cout <= temp(16);



end my_full_adder;





