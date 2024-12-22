library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MEM_TO_REG_MUX is
    Port (
        memToReg   : in  STD_LOGIC;                        -- Control signal for selection
        MemOut     : in  STD_LOGIC_VECTOR (31 downto 0);    -- 32-bit memory output
        ALUOut     : in  STD_LOGIC_VECTOR (31 downto 0);    -- 32-bit ALU output
        result     : out STD_LOGIC_VECTOR (31 downto 0)     -- 32-bit result (selected value)
    );
end MEM_TO_REG_MUX;

architecture Behavioral of MEM_TO_REG_MUX is
begin

    process(memToReg, MemOut, ALUOut)
    begin
        if memToReg = '1' then
            result <= MemOut;  -- If memToReg is 1, select MemOut (memory data)
        else
            result <= ALUOut;  -- If memToReg is 0, select ALUOut (ALU result)
        end if;
    end process;

end Behavioral;

