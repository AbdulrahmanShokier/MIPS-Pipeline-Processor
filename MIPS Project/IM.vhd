
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IM_COMPONENT is
    Port ( PC : in  STD_LOGIC_VECTOR (31 downto 0);
           INSTRUCT : out  STD_LOGIC_VECTOR (31 downto 0));
end IM_COMPONENT;

architecture Behavioral of IM_COMPONENT is

TYPE regArray IS array(0 to 64) OF std_logic_vector(7 DOWNTO 0);
SIGNAL RF: regArray:=(
0 =>"00100000",
1 =>"00001000",
2 =>"00000000",
3 =>"00000101",
4 =>"00100000",
5 =>"00001001",
6 =>"00000000",
7 =>"00000101",
8 =>"00100001",
9 =>"00101010",
10=>"00000000",
11=>"00000101",
12=>"10001101",
13=>"00001011",
14=>"00000000",
15=>"00000000",
16=>"00000001",
17=>"01101000",
18=>"01100000",
19=>"00100000",
20=>"00010001",
21=>"00101000",
22=>"00000000",
23=>"00000001",
24=>"00000001",
25=>"00001001",
26=>"01101000",
27=>"00100000",
28=>"00000001",
29=>"00001001",
30=>"01101000",
31=>"00100000",
others =>"11111100"
  );


BEGIN


INSTRUCT <= RF(CONV_INTEGER(PC(5 downto 0)))&RF(CONV_INTEGER(PC(5 downto 0))+1)&RF(CONV_INTEGER(PC(5 downto 0))+2)&RF(CONV_INTEGER(PC(5 downto 0))+3); 


end Behavioral;

