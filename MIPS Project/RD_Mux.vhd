library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RD_RT_MUX is
    Port ( RT : in  STD_LOGIC_VECTOR (4 downto 0);
           RD : in  STD_LOGIC_VECTOR (4 downto 0);
           X : in  STD_LOGIC;
           OUTPUT : out  STD_LOGIC_VECTOR (4 downto 0)
           );
end RD_RT_MUX;

architecture Behavioral of RD_RT_MUX is
begin
    process(RT, RD, X)
    begin
        if X = '0' then
            OUTPUT <= RT;
        else
            OUTPUT <= RD;
        end if;
    end process;
end Behavioral;

