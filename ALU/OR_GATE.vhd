library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity OR_GATE is
    Port ( input_data : in  STD_LOGIC_VECTOR (15 downto 0);
           output : out  STD_LOGIC);
end OR_GATE;

architecture my_or of OR_GATE is
    signal or_result : STD_LOGIC := '0';  -- Signal to hold intermediate result
begin
    -- Perform OR operation on each bit of input_data
    or_result <= input_data(0) or input_data(1) or input_data(2) or input_data(3)
                  or input_data(4) or input_data(5) or input_data(6) or input_data(7)
                  or input_data(8) or input_data(9) or input_data(10) or input_data(11)
                  or input_data(12) or input_data(13) or input_data(14) or input_data(15);
    
    output <= or_result;  -- Assign the final result to the output signal
end my_or;
