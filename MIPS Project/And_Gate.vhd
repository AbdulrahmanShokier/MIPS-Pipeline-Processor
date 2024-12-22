library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AND_GATE is
    Port (
        A      : in  STD_LOGIC;  -- Input A (ZERO_FLAG)
        B      : in  STD_LOGIC;  -- Input B (BRANCH_SIGNAL)
        RESULT : out STD_LOGIC   -- AND output (MUX selection)
    );
end AND_GATE;

architecture Behavioral of AND_GATE is
begin

    -- AND operation between A and B
    RESULT <= A AND B;

end Behavioral;

