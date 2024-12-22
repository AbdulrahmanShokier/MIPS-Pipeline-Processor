library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Standard for arithmetic operations

entity PC is
    Port (
        PC_N   : in  STD_LOGIC_VECTOR (31 downto 0); -- New PC value
        CLK    : in  STD_LOGIC;                     -- Clock signal
        RESET  : in  STD_LOGIC;                     -- Reset signal
        STALL  : in  STD_LOGIC;                     -- Stall signal
        PC_OUT : out STD_LOGIC_VECTOR (31 downto 0) -- Current PC value
    );
end PC;

architecture Behavioral of PC is
    signal TEMP : STD_LOGIC_VECTOR(31 downto 0) := x"00000000";  
begin

process(CLK, RESET)
begin
    if RESET = '1' then
        TEMP <= x"00000000"; -- Reset PC to initial state
    elsif rising_edge(CLK) then
        if STALL = '0' then  -- Update PC only if STALL is not asserted
            TEMP <= PC_N;
        end if;
    end if;
end process;

PC_OUT <= TEMP; -- Output current PC value

end Behavioral;



