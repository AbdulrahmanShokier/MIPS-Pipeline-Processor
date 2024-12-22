library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FORWARD_B_MUX is
    Port (
        RT       : in  STD_LOGIC_VECTOR (31 downto 0); -- RT register value
        EX_MEM   : in  STD_LOGIC_VECTOR (31 downto 0); -- Forwarded data from EX/MEM
        MEM_WB   : in  STD_LOGIC_VECTOR (31 downto 0); -- Forwarded data from MEM/WB
        IMMEDIATE: in  STD_LOGIC_VECTOR (31 downto 0); -- Immediate value
        FWD_CTRL : in  STD_LOGIC_VECTOR (1 downto 0);  -- 2-bit control signal
        OUTPUT   : out STD_LOGIC_VECTOR (31 downto 0)  -- Selected output
    );
end FORWARD_B_MUX;

architecture Behavioral of FORWARD_B_MUX is
begin
    process(FWD_CTRL, RT, EX_MEM, MEM_WB, IMMEDIATE)
    begin
        case FWD_CTRL is
            when "00" => 
                OUTPUT <= RT; -- Select RT register value
            when "01" => 
                OUTPUT <= MEM_WB; -- Select forwarded data from EX/MEM stage
            when "10" => 
                OUTPUT <= EX_MEM; -- Select forwarded data from MEM/WB stage
            when "11" => 
                OUTPUT <= IMMEDIATE; -- Select immediate value
            when others => 
                OUTPUT <= (others => '0'); -- Default case (invalid FWD_CTRL)
        end case;
    end process;
end Behavioral;

