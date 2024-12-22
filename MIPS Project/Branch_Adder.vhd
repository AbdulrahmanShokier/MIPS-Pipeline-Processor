library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BRANCH_ADDER is
    Port (
        PC_PLUS_4 : in  STD_LOGIC_VECTOR(31 downto 0);  -- PC+4 input
        IMM_SHIFTED : in  STD_LOGIC_VECTOR(31 downto 0);  -- Shifted immediate value
        BRANCH_ADDR : out  STD_LOGIC_VECTOR(31 downto 0)  -- Branch target address
    );
end BRANCH_ADDER;

architecture Behavioral of BRANCH_ADDER is
begin
    -- Add PC+4 and the shifted immediate value
    BRANCH_ADDR <= PC_PLUS_4 + IMM_SHIFTED;
end Behavioral;

