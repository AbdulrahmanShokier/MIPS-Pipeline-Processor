library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity JUMP_MUX is
    Port (
        branchMuxAddress : in  STD_LOGIC_VECTOR(31 downto 0); -- Output from the branch MUX
        jumpAddress   : in  STD_LOGIC_VECTOR(31 downto 0); -- Calculated jump address
        jump          : in  STD_LOGIC;                    -- Control signal: 1 for jump, 0 for branch
        pcNext        : out STD_LOGIC_VECTOR(31 downto 0) -- Next PC value
    );
end JUMP_MUX;

architecture Behavioral of JUMP_MUX is
begin

    process(branchMuxAddress, jumpAddress, jump)
    begin
        if jump = '1' then
            pcNext <= jumpAddress; -- Select the jump address
        else
            pcNext <= branchMuxAddress; -- Select the branch address
        end if;
    end process;

end Behavioral;

