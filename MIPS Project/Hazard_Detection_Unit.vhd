library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity HAZARD_DETECTION_UNIT is
    Port ( 
        -- Inputs
        ID_EX_MEM_READ : in STD_LOGIC;    -- MEM_READ signal from ID/EX register
        ID_EX_RT       : in STD_LOGIC_VECTOR(4 downto 0);  -- RT register in ID/EX
        IF_ID_RS       : in STD_LOGIC_VECTOR(4 downto 0);  -- RS register in IF/ID
        IF_ID_RT       : in STD_LOGIC_VECTOR(4 downto 0);  -- RT register in IF/ID

        -- Outputs
        STALL          : out STD_LOGIC    -- Stall signal (1 to stall, 0 to continue)
    );
end HAZARD_DETECTION_UNIT;

architecture Behavioral of HAZARD_DETECTION_UNIT is
begin
    process(ID_EX_MEM_READ, ID_EX_RT, IF_ID_RS, IF_ID_RT)
    begin
        if (ID_EX_MEM_READ = '1') then
            -- Check for data hazard: If RT or RS matches with ID/EX RT, generate stall
            if (ID_EX_RT = IF_ID_RS or ID_EX_RT = IF_ID_RT) then
                STALL <= '1';  -- Stall the pipeline
            else
                STALL <= '0';  -- No hazard, no stall
            end if;
        else
            STALL <= '0';  -- No load instruction in ID/EX, no hazard
        end if;
    end process;
end Behavioral;

