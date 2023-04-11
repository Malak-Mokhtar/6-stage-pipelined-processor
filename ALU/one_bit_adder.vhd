library IEEE;
use IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;


entity one_bit_adder is 
	
	  Port (a : in  STD_LOGIC;
           b : in  STD_LOGIC;
           cin : in  STD_LOGIC;
           sum : out  STD_LOGIC;
           cout : out  STD_LOGIC);

end one_bit_adder;


Architecture my_one_bit_adder of one_bit_adder is
begin

sum <= a xor b xor cin;
cout <= (a and b) or (cin AND (a xor b));


end my_one_bit_adder;