library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MAIN_CONTROL_UNIT is
    Port (
        OP_CODE    : in  STD_LOGIC_VECTOR (5 downto 0);  -- Instruction opcode
        BRANCH     : out STD_LOGIC;
        MEM_READ   : out STD_LOGIC;
        MEM_TO_REG : out STD_LOGIC;
        MEM_WRITE  : out STD_LOGIC;
        ALU_SRC    : out STD_LOGIC;
        REG_WRITE  : out STD_LOGIC;
        REG_DES    : out STD_LOGIC;
        JUMP       : out STD_LOGIC;
        ALU_OP     : out STD_LOGIC_VECTOR (1 downto 0)
    );
end MAIN_CONTROL_UNIT;

architecture Behavioral of MAIN_CONTROL_UNIT is
begin
    process(OP_CODE)
    begin
        case OP_CODE is
            when "000000" =>  -- R-type
                JUMP       <= '0';
                BRANCH     <= '0';
                MEM_READ   <= '0';
                MEM_TO_REG <= '0';
                MEM_WRITE  <= '0';
                ALU_SRC    <= '0';
                REG_WRITE  <= '1';
                REG_DES    <= '1';
                ALU_OP     <= "10"; -- ALU performs operation based on function field

            when "100011" =>  -- Load word (LW)
                JUMP       <= '0';
                BRANCH     <= '0';
                MEM_READ   <= '1';
                MEM_TO_REG <= '1';
                MEM_WRITE  <= '0';
                ALU_SRC    <= '1';  -- Use immediate value
                REG_WRITE  <= '1';
                REG_DES    <= '0';  -- Destination is rt
                ALU_OP     <= "00"; -- ALU performs addition

            when "101011" =>  -- Store word (SW)
                JUMP       <= '0';
                BRANCH     <= '0';
                MEM_READ   <= '0';
                MEM_WRITE  <= '1';
                ALU_SRC    <= '1';  -- Use immediate value
                REG_WRITE  <= '0';
                REG_DES    <= '-';  -- Don't care
                ALU_OP     <= "00"; -- ALU performs addition

            when "000100" =>  -- Branch if equal (BEQ)
                JUMP       <= '0';
                BRANCH     <= '1';  -- Branch control signal
                MEM_READ   <= '0';
                MEM_WRITE  <= '0';
                ALU_SRC    <= '0';  -- Use register values
                REG_WRITE  <= '0';
                REG_DES    <= '-';  -- Don't care
                ALU_OP     <= "01"; -- ALU performs subtraction for comparison

            when "000010" =>  -- Jump
                JUMP       <= '1';  -- Jump control signal
                BRANCH     <= '0';
                MEM_READ   <= '0';
                MEM_WRITE  <= '0';
                REG_WRITE  <= '0';
                REG_DES    <= '-';  -- Don't care
                ALU_OP     <= "--"; -- Not used

	   when "001000" =>
		JUMP       <= '0';
                BRANCH     <= '0';
                MEM_READ   <= '0';
                MEM_TO_REG <= '0';
                MEM_WRITE  <= '0';
                ALU_SRC    <= '1';
                REG_WRITE  <= '1';
                REG_DES    <= '0';
                ALU_OP     <= "00"; -- ALU performs operation based on function field

            when others =>  -- Default (Invalid opcode)
                JUMP       <= '0';
                BRANCH     <= '0';
                MEM_READ   <= '0';
                MEM_TO_REG <= '0';
                MEM_WRITE  <= '0';
                ALU_SRC    <= '0';
                REG_WRITE  <= '0';
                REG_DES    <= '0';
                ALU_OP     <= "00"; -- Default operation
        end case;
    end process;
end Behavioral;

