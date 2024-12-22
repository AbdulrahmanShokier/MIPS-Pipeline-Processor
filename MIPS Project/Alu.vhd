library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity ALU is
    Port (
        INPUT1     : in  STD_LOGIC_VECTOR (31 downto 0); -- 32-bit operand 1
        INPUT2     : in  STD_LOGIC_VECTOR (31 downto 0); -- 32-bit operand 2
        ALU_CTRL   : in  STD_LOGIC_VECTOR (3 downto 0);  -- 4-bit ALU control signal
        RESULT     : out STD_LOGIC_VECTOR (31 downto 0)  -- 32-bit output
    );
end ALU;

architecture Behavioral of ALU is
begin
    process(INPUT1, INPUT2, ALU_CTRL)
        variable temp_result : signed(31 downto 0);
    begin
        case ALU_CTRL is
            when "0010" => -- Add
                temp_result := signed(INPUT1) + signed(INPUT2);
                RESULT <= std_logic_vector(temp_result);

            when "0110" => -- Subtract
                temp_result := signed(INPUT1) - signed(INPUT2);
                RESULT <= std_logic_vector(temp_result);

            when "0000" => -- AND
                RESULT <= INPUT1 AND INPUT2;

            when "0001" => -- OR
                RESULT <= INPUT1 OR INPUT2;

            when "0111" => -- Set on Less Than (slt)
                if signed(INPUT1) < signed(INPUT2) then
                    RESULT <= (others => '0');
                    RESULT(0) <= '1';
                else
                    RESULT <= (others => '0');
                end if;

            when others => -- Default: Output 0 for unsupported operations
                RESULT <= (others => '0');
        end case;
    end process;
end Behavioral;

