library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FORWARD_A_MUX is
    Port (
        IN1    : in  STD_LOGIC_VECTOR (31 downto 0); -- ID/EX
        IN2    : in  STD_LOGIC_VECTOR (31 downto 0); -- MEM/WB
        IN3    : in  STD_LOGIC_VECTOR (31 downto 0); -- EX/MEM
        OUTPUT : out STD_LOGIC_VECTOR (31 downto 0);
        X      : in  STD_LOGIC_VECTOR (1 downto 0)   -- Select signal
    );
end FORWARD_A_MUX;

architecture Behavioral of FORWARD_A_MUX is
begin

process(X, IN1, IN2, IN3)
begin
    case X is
        when "00" => 
            OUTPUT <= IN1; -- ID/EX
        when "01" => 
            OUTPUT <= IN2; -- MEM/WB
        when "10" => 
            OUTPUT <= IN3; -- EX/MEM
        when others => 
            OUTPUT <= x"00000000"; -- Default case
    end case;
end process;

end Behavioral;



