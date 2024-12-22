library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;  -- For arithmetic operations

entity COMPARE_UNIT is
    Port ( 
        RS_VAL : in  STD_LOGIC_VECTOR(31 downto 0); -- Value of register rs
        RT_VAL : in  STD_LOGIC_VECTOR(31 downto 0); -- Value of register rt
        ZERO   : out STD_LOGIC                  -- Zero flag: '1' if rs = rt, '0' otherwise
    );
end COMPARE_UNIT;

architecture Behavioral of COMPARE_UNIT is
begin

    -- Comparator Process
    process(RS_VAL, RT_VAL)
    begin
        if RS_VAL = RT_VAL then
            ZERO <= '1'; -- rs equals rt
        else
            ZERO <= '0'; -- rs not equal to rt
        end if;
    end process;

end Behavioral;

