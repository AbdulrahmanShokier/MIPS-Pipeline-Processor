library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity JUMP_ADDRESS_CALC is
    Port (
        target   : in  STD_LOGIC_VECTOR(25 downto 0); -- 26-bit target field from J-type instruction
        pcPlus4  : in  STD_LOGIC_VECTOR(31 downto 0); -- PC + 4 input
        jumpAddr : out STD_LOGIC_VECTOR(31 downto 0)  -- Calculated 32-bit jump address
    );
end JUMP_ADDRESS_CALC;

architecture Behavioral of JUMP_ADDRESS_CALC is
    signal shiftedTarget : STD_LOGIC_VECTOR(27 downto 0); -- 28-bit shifted target
    signal upperPC       : STD_LOGIC_VECTOR(3 downto 0);  -- Upper 4 bits of PC + 4
begin

    process(target, pcPlus4)
    begin
        -- Shift the 26-bit target left by 2 bits
        shiftedTarget <= target & "00";

        -- Extract the upper 4 bits of PC+4
        upperPC <= pcPlus4(31 downto 28);

        -- Concatenate the upper 4 bits of PC+4 with the 28-bit shifted target
        
    end process;
jumpAddr <= upperPC & shiftedTarget;
end Behavioral;

