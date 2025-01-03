library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MEM_WB is
    Port (
        clk       : in  STD_LOGIC;                    -- Clock signal
        rst       : in  STD_LOGIC;                    -- Reset signal
        memToReg  : in  STD_LOGIC;                    -- memToReg signal
        regWrite  : in  STD_LOGIC;                    -- regWrite signal
        ALUResult : in  STD_LOGIC_VECTOR (31 downto 0);-- ALU result
        MemOut    : in  STD_LOGIC_VECTOR (31 downto 0);-- Data from memory
        rd        : in  STD_LOGIC_VECTOR (4 downto 0); -- Register destination address

        memToReg_out : out  STD_LOGIC;                -- memToReg output
        regWrite_out : out  STD_LOGIC;                -- regWrite output
        ALUResult_out : out  STD_LOGIC_VECTOR (31 downto 0); -- ALU result output
        MemOut_out : out  STD_LOGIC_VECTOR (31 downto 0); -- Memory data output
        rd_out    : out  STD_LOGIC_VECTOR (4 downto 0) -- Destination register output
    );
end MEM_WB;

architecture Behavioral of MEM_WB is
begin

    process(clk, rst,memToReg,regWrite,ALUResult,MemOut,rd)
    begin
        if rst = '1' then
            -- Reset the outputs when reset is active
            memToReg_out <= '0';
            regWrite_out <= '0';
            ALUResult_out <= (others => '0');
            MemOut_out <= (others => '0');
            rd_out <= (others => '0');
        elsif rising_edge(clk) then
            -- Latch values on the rising edge of the clock
            memToReg_out <= memToReg;
            regWrite_out <= regWrite;
            ALUResult_out <= ALUResult;
            MemOut_out <= MemOut;
            rd_out <= rd;
        end if;
    end process;

end Behavioral;

