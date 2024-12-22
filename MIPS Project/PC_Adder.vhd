library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PC_ADDER is    ------CALCULATING PC+4
    Port ( INPUT1 : in  STD_LOGIC_VECTOR (31 downto 0);  -- PC input
           ADD_OUT : out  STD_LOGIC_VECTOR (31 downto 0));  -- PC+4 output
end PC_ADDER;

architecture Behavioral of PC_ADDER is
begin
    -- Add 4 directly to the STD_LOGIC_VECTOR (no need for conversion)
    ADD_OUT <= INPUT1 + "00000000000000000000000000000100";  -- Add 4 in binary (32 bits)
end Behavioral;

