library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MUX_32 is
    Port ( MUX_IN1 : in  STD_LOGIC_VECTOR (31 downto 0); --PC+4
           MUX_IN2 : in  STD_LOGIC_VECTOR (31 downto 0); --PC+4+IMM VALUE
           SEL : in  STD_LOGIC;
           MUX_OUT : out  STD_LOGIC_VECTOR (31 downto 0)); -- PC New content
end MUX_32;

architecture Behavioral of MUX_32 is

begin
MUX_OUT <= MUX_IN1 WHEN SEL ='0' else
         MUX_IN2 ; 
			 
END Behavioral;