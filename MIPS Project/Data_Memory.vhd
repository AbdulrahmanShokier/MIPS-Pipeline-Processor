library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DATA_MEM is
    Port (
        address    : in  STD_LOGIC_VECTOR (31 downto 0); -- 32-bit address
        writeData  : in  STD_LOGIC_VECTOR (31 downto 0); -- 32-bit write data
        clk        : in  STD_LOGIC;                      -- Clock input
        memRead    : in  STD_LOGIC;                      -- Memory read control
        memWrite   : in  STD_LOGIC;                      -- Memory write control
        readData   : out STD_LOGIC_VECTOR (31 downto 0)  -- 32-bit read data output
    );
end DATA_MEM;

architecture Behavioral of DATA_MEM is
    -- Memory array: 1024 locations, each 1 byte (total of 1024 bytes)
    type RAM_TYPE is array (0 to 1023) of STD_LOGIC_VECTOR(7 downto 0); 
    signal DM : RAM_TYPE := (others => (others => '0')); -- Initialize all memory locations to 0
    
begin

    -- **WRITE Operation (Sequential)**
    process(clk)
        variable idx : integer;
    begin
        if rising_edge(clk) then
            if memWrite = '1' then
                -- Write 32 bits across 4 consecutive bytes (addresses)
                for idx in 0 to 3 loop
                    DM(to_integer(unsigned(address(31 downto 2))) + (3 - idx)) <= writeData((idx * 8) + 7 downto idx * 8); -- Write each byte
                end loop;
            end if;
        end if;
    end process;

    -- **READ Operation (Combinational)**
    process(address, memRead)
        variable idx : integer;
    begin
        if memRead = '1' then
            -- Read 32 bits from 4 consecutive bytes in Big-Endian format
            readData <= (others => '0'); -- Default to 0 if not reading
            for idx in 0 to 3 loop
                -- In Big-Endian, reverse the byte order
                readData((idx * 8) + 7 downto idx * 8) <= DM(to_integer(unsigned(address(31 downto 2))) + (3 - idx)); -- Read each byte in reverse order
            end loop;
        else
            readData <= (others => '0'); -- Default to 0 if not reading
        end if;
    end process;

end Behavioral;

