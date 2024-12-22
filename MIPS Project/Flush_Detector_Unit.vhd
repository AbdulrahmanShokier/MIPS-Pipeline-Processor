library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FLUSH_DETECTOR is
    Port (
        BRANCH_AND_ZERO_FLAG : in STD_LOGIC;  -- AND gate output (branch and zero flag)
        JUMP : in STD_LOGIC;                   -- Jump instruction signal
        FLUSH_SIGNAL : out STD_LOGIC           -- Output the flush signal
    );
end FLUSH_DETECTOR;

architecture Behavioral of FLUSH_DETECTOR is
begin
    -- The flush signal is generated if either of these conditions is true:
    -- 1. Branch is taken (branch and zero flag)
    -- 2. Jump instruction
    process (BRANCH_AND_ZERO_FLAG, JUMP)
    begin
        if (BRANCH_AND_ZERO_FLAG = '1') then
            FLUSH_SIGNAL <= '1';  -- Branch is taken, flush the pipeline
        elsif (JUMP = '1') then
            FLUSH_SIGNAL <= '1';  -- Jump instruction, flush the pipeline
        else
            FLUSH_SIGNAL <= '0';  -- No flush needed
        end if;
    end process;
end Behavioral;

