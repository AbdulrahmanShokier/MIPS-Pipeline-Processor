library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CONTROL_MUX is
    Port (
        -- Separate control signal inputs
        CTRL_MEM_READ    : in  STD_LOGIC;
        CTRL_MEM_TO_REG  : in  STD_LOGIC;
        CTRL_MEM_WRITE   : in  STD_LOGIC;
        CTRL_ALU_SRC     : in  STD_LOGIC;
        CTRL_REG_WRITE   : in  STD_LOGIC;
        CTRL_ALU_OP      : in  STD_LOGIC_VECTOR(1 downto 0); -- ALU_OP as a 2-bit control signal
        CTRL_REG_DST     : in  STD_LOGIC;
        
        -- Stall signal input
        CTRL_STALL       : in  STD_LOGIC;

        -- Separate control signal outputs
        CTRL_MEM_READ_OUT    : out STD_LOGIC;
        CTRL_MEM_TO_REG_OUT  : out STD_LOGIC;
        CTRL_MEM_WRITE_OUT   : out STD_LOGIC;
        CTRL_ALU_SRC_OUT     : out STD_LOGIC;
        CTRL_REG_WRITE_OUT   : out STD_LOGIC;
        CTRL_ALU_OP_OUT      : out STD_LOGIC_VECTOR(1 downto 0); -- ALU_OP output;
        CTRL_REG_DST_OUT     : out STD_LOGIC
    );
end CONTROL_MUX;

architecture Behavioral of CONTROL_MUX is
begin

    process(CTRL_STALL, CTRL_MEM_READ, CTRL_MEM_TO_REG, CTRL_MEM_WRITE, CTRL_ALU_SRC, CTRL_REG_WRITE, CTRL_ALU_OP, CTRL_REG_DST)
    begin
        if (CTRL_STALL = '1') then
            -- If stall is detected, set all control outputs to 0
            CTRL_MEM_READ_OUT    <= '0';
            CTRL_MEM_TO_REG_OUT  <= '0';
            CTRL_MEM_WRITE_OUT   <= '0';
            CTRL_ALU_SRC_OUT     <= '0';
            CTRL_REG_WRITE_OUT   <= '0';
            CTRL_ALU_OP_OUT      <= "00";  -- ALU_OP also set to 00 during stall
            CTRL_REG_DST_OUT     <= '0';
        else
            -- If no stall, pass the control signals through
            CTRL_MEM_READ_OUT    <= CTRL_MEM_READ;
            CTRL_MEM_TO_REG_OUT  <= CTRL_MEM_TO_REG;
            CTRL_MEM_WRITE_OUT   <= CTRL_MEM_WRITE;
            CTRL_ALU_SRC_OUT     <= CTRL_ALU_SRC;
            CTRL_REG_WRITE_OUT   <= CTRL_REG_WRITE;
            CTRL_ALU_OP_OUT      <= CTRL_ALU_OP;  -- ALU_OP passed through as well
            CTRL_REG_DST_OUT     <= CTRL_REG_DST;
        end if;
    end process;

end Behavioral;

