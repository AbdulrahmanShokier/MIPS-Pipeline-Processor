library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SIGN_EXTEND is
    Port ( INPUT : in  STD_LOGIC_VECTOR (15 downto 0); -- 16-bit input
           OUTPUT : out  STD_LOGIC_VECTOR (31 downto 0)  -- 32-bit sign-extended output
         );
end SIGN_EXTEND;

architecture Behavioral of SIGN_EXTEND is
begin
    process(INPUT)
    begin
        -- If MSB of INPUT is '0', extend with 16 '0's; otherwise, extend with 16 '1's
        if INPUT(15) = '0' then
            OUTPUT <= "0000000000000000" & INPUT;
        else
            OUTPUT <= "1111111111111111" & INPUT;
        end if;
    end process;
end Behavioral;

