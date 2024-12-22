library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_CONTROL is
    Port (
        FUNCT     : in  STD_LOGIC_VECTOR(5 downto 0); -- Function field
        ALU_OP    : in  STD_LOGIC_VECTOR(1 downto 0); -- ALUOp signal
        ALU_CTRL  : out STD_LOGIC_VECTOR(3 downto 0)  -- ALU Control signal
    );
end ALU_CONTROL;

architecture Behavioral of ALU_CONTROL is
begin
    process(FUNCT, ALU_OP)
    begin
        case ALU_OP is
            when "00" => -- Load/Store
                ALU_CTRL <= "0010"; -- Add

            when "01" => -- Branch
                ALU_CTRL <= "0110"; -- Subtract

            when "10" => -- R-type instructions
                case FUNCT is
                    when "100000" => -- Add
                        ALU_CTRL <= "0010";
                    when "100010" => -- Subtract
                        ALU_CTRL <= "0110";
                    when "100100" => -- AND
                        ALU_CTRL <= "0000";
                    when "100101" => -- OR
                        ALU_CTRL <= "0001";
                    when "101010" => -- Set on Less Than
                        ALU_CTRL <= "0111";
                    when others =>
                        ALU_CTRL <= "1111"; -- Default: Undefined operation
                end case;

            when others => -- Default case for ALU_OP
                ALU_CTRL <= "1111"; -- Undefined operation
        end case;
    end process;
end Behavioral;

