library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FORWARDING_UNIT is
    Port ( 
           EX_MEM_REG_WRITE : in  STD_LOGIC;
           MEM_WB_REG_WRITE : in  STD_LOGIC;
           ID_EX_RS         : in  STD_LOGIC_VECTOR (4 downto 0);
           ID_EX_RT         : in  STD_LOGIC_VECTOR (4 downto 0);
           EX_MEM_RD        : in  STD_LOGIC_VECTOR (4 downto 0);
           MEM_WB_RD        : in  STD_LOGIC_VECTOR (4 downto 0);
           ALUSrc           : in  STD_LOGIC; -- Added ALUSrc signal
           FORWARD_A        : out STD_LOGIC_VECTOR (1 downto 0);
           FORWARD_B        : out STD_LOGIC_VECTOR (1 downto 0)
           );
end FORWARDING_UNIT;

architecture Behavioral of FORWARDING_UNIT is

signal FOR_A_TEMP : STD_LOGIC_VECTOR(1 downto 0) := "00";
signal FOR_B_TEMP : STD_LOGIC_VECTOR(1 downto 0) := "00";

begin

FORWARD_A <= FOR_A_TEMP;
FORWARD_B <= FOR_B_TEMP;


process(EX_MEM_RD, MEM_WB_RD, EX_MEM_REG_WRITE, MEM_WB_REG_WRITE, 
        ID_EX_RS, ID_EX_RT, ALUSrc)
begin 

    -- Forwarding Logic for FORWARD_A (first operand)
    if (EX_MEM_REG_WRITE = '1' and EX_MEM_RD /= "00000" and EX_MEM_RD = ID_EX_RS) then
        FOR_A_TEMP <= "10"; -- Forward from EX/MEM
    elsif (MEM_WB_REG_WRITE = '1' and MEM_WB_RD /= "00000" and MEM_WB_RD = ID_EX_RS 
           and not (EX_MEM_REG_WRITE = '1' and EX_MEM_RD /= "00000" and EX_MEM_RD = ID_EX_RS)) then
        FOR_A_TEMP <= "01"; -- Forward from MEM/WB (only if EX forwarding is not applicable)
    else
        FOR_A_TEMP <= "00"; -- Use default ID/EX value
    end if;

    -- Forwarding Logic for FORWARD_B (second operand)
    if (ALUSrc = '1') then
        FOR_B_TEMP <= "11"; -- Use immediate value (no forwarding)
    elsif (EX_MEM_REG_WRITE = '1' and EX_MEM_RD /= "00000" and EX_MEM_RD = ID_EX_RT) then
        FOR_B_TEMP <= "10"; -- Forward from EX/MEM
    elsif (MEM_WB_REG_WRITE = '1' and MEM_WB_RD /= "00000" and MEM_WB_RD = ID_EX_RT 
           and not (EX_MEM_REG_WRITE = '1' and EX_MEM_RD /= "00000" and EX_MEM_RD = ID_EX_RT)) then
        FOR_B_TEMP <= "01"; -- Forward from MEM/WB (only if EX forwarding is not applicable)
    else
        FOR_B_TEMP <= "00"; -- Use default ID/EX value
    end if;

end process;

end Behavioral;