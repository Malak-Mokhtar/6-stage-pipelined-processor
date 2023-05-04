Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity XOR_gate is


PORT(in1, in2: in std_logic_vector(2 downto 0);
out1: out std_logic);
end entity;



architecture my_XOR_gate of XOR_gate is
signal sig0, sig1, sig2: std_logic;
begin


sig0 <= in1(0) xor in2(0);
sig1 <= in1(1) xor in2(1);
sig2 <= in1(2) xor in2(2);

out1 <= sig0 or sig1 or sig2;


end architecture;