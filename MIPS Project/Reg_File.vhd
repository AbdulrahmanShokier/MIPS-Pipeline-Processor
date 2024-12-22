library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;  -- Use numeric_std for arithmetic operations

entity REG_FILE is
    Port ( 
        READ_ADD1   : in  STD_LOGIC_VECTOR (4 downto 0);
        READ_ADD2   : in  STD_LOGIC_VECTOR (4 downto 0);
        WRITE_ADD   : in  STD_LOGIC_VECTOR (4 downto 0);
        WRITE_DATA  : in  STD_LOGIC_VECTOR (31 downto 0);
        REG_WRITE_S : in  STD_LOGIC;
        CLK         : in  STD_LOGIC;
        DATA1       : out STD_LOGIC_VECTOR (31 downto 0);
        DATA2       : out STD_LOGIC_VECTOR (31 downto 0)
    );
end REG_FILE;

architecture Behavioral of REG_FILE is

    -- Define a 32-register file, each 32 bits wide
    type REG_ARRAY is array (0 to 31) of std_logic_vector(31 downto 0);
    signal REGFILE : REG_ARRAY := (others => (others => '0'));

begin

    -- Synchronous Write Process
    process(CLK)
    begin
        if rising_edge(CLK) then
            if REG_WRITE_S = '1' and WRITE_ADD /= "00000" then
                REGFILE(to_integer(unsigned(WRITE_ADD))) <= WRITE_DATA;
            end if;
        end if;
    end process;

    -- Hazard Mitigation Logic for Asynchronous Read
    process(READ_ADD1, READ_ADD2, WRITE_ADD, WRITE_DATA, REG_WRITE_S, REGFILE)
    begin
        -- Default reads from the register file
        DATA1 <= REGFILE(to_integer(unsigned(READ_ADD1)));
        DATA2 <= REGFILE(to_integer(unsigned(READ_ADD2)));

        -- Check for hazards and forward the write data directly if needed
        if (REG_WRITE_S = '1' and WRITE_ADD = READ_ADD1 and WRITE_ADD /= "00000") then
            DATA1 <= WRITE_DATA;
        end if;

        if (REG_WRITE_S = '1' and WRITE_ADD = READ_ADD2 and WRITE_ADD /= "00000") then
            DATA2 <= WRITE_DATA;
        end if;
    end process;

end Behavioral;

