library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity F_ID_REG is
    Port ( INSTRUCT : in  STD_LOGIC_VECTOR (31 downto 0);
           PC : in  STD_LOGIC_VECTOR (31 downto 0);
           INSTRUCT_OUT : out  STD_LOGIC_VECTOR (31 downto 0);
           PC_OUT : out  STD_LOGIC_VECTOR (31 downto 0);
           CLK : in  STD_LOGIC;
           STALL : in  STD_LOGIC;
           FLUSH : in  STD_LOGIC
           );
end F_ID_REG;

architecture Behavioral of F_ID_REG is

signal INSTRUCT_TEMP : STD_LOGIC_VECTOR(31 downto 0) := x"00000000";
signal PC_TEMP : STD_LOGIC_VECTOR(31 downto 0) := x"00000000";

begin

process (CLK)
begin
    if (CLK'event and CLK = '1') then
        if (FLUSH = '1') then  -- Flush takes priority over stall
            INSTRUCT_TEMP <= x"00000000";  -- Clear instruction
            PC_TEMP <= x"00000000";        -- Optionally clear PC (if required by design)
        elsif (STALL = '0') then  -- Normal operation (no stall)
            INSTRUCT_TEMP <= INSTRUCT;
            PC_TEMP <= PC;
        end if;
        -- If STALL = '1', keep the values unchanged (no assignment required)
    end if;
end process;

INSTRUCT_OUT <= INSTRUCT_TEMP;
PC_OUT <= PC_TEMP;

end Behavioral;

