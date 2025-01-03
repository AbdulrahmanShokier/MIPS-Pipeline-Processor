library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity ID_EX_REG is
    Port (
        -- Control signals
        REG_WRITE : in STD_LOGIC;
        ALU_OP : in STD_LOGIC_VECTOR(1 downto 0);
        ALU_SRC : in STD_LOGIC;
        MEM_READ : in STD_LOGIC;
        MEM_WRITE : in STD_LOGIC;
        MEM_TO_REG : in STD_LOGIC;
        REG_DEST : in STD_LOGIC;

        -- Register data
        RS_DATA : in STD_LOGIC_VECTOR(31 downto 0);
        RT_DATA : in STD_LOGIC_VECTOR(31 downto 0);
        IMMEDIATE : in STD_LOGIC_VECTOR(31 downto 0);

        -- Instruction fields
        RS : in STD_LOGIC_VECTOR(4 downto 0);
        RT : in STD_LOGIC_VECTOR(4 downto 0);
        RD : in STD_LOGIC_VECTOR(4 downto 0);
        FUNC : in STD_LOGIC_VECTOR(5 downto 0);

        -- Clock and reset
        CLK : in STD_LOGIC;
        RESET : in STD_LOGIC;

        -- Outputs
        -- Same signals will be available as outputs for the EX stage
        REG_WRITE_OUT : out STD_LOGIC;
        ALU_OP_OUT : out STD_LOGIC_VECTOR(1 downto 0);
        ALU_SRC_OUT : out STD_LOGIC;
        MEM_READ_OUT : out STD_LOGIC;
        MEM_WRITE_OUT : out STD_LOGIC;
        MEM_TO_REG_OUT : out STD_LOGIC;
        REG_DEST_OUT : out STD_LOGIC;

        RS_DATA_OUT : out STD_LOGIC_VECTOR(31 downto 0);
        RT_DATA_OUT : out STD_LOGIC_VECTOR(31 downto 0);
        IMMEDIATE_OUT : out STD_LOGIC_VECTOR(31 downto 0);

        RS_OUT : out STD_LOGIC_VECTOR(4 downto 0);
        RT_OUT : out STD_LOGIC_VECTOR(4 downto 0);
        RD_OUT : out STD_LOGIC_VECTOR(4 downto 0);
        FUNC_OUT : out STD_LOGIC_VECTOR(5 downto 0)
    );
end ID_EX_REG;

architecture Behavioral of ID_EX_REG is
begin
    process(CLK, RESET)
    begin
        if RESET = '1' then
            -- Reset all signals to default values
            REG_WRITE_OUT <= '0';
            ALU_OP_OUT <= "00";
            ALU_SRC_OUT <= '0';
            MEM_READ_OUT <= '0';
            MEM_WRITE_OUT <= '0';
            MEM_TO_REG_OUT <= '0';
            REG_DEST_OUT <= '0';

            RS_DATA_OUT <= (others => '0');
            RT_DATA_OUT <= (others => '0');
            IMMEDIATE_OUT <= (others => '0');

            RS_OUT <= (others => '0');
            RT_OUT <= (others => '0');
            RD_OUT <= (others => '0');
            FUNC_OUT <= (others => '0');
        elsif rising_edge(CLK) then
            -- Store values on the rising edge of the clock
            REG_WRITE_OUT <= REG_WRITE;
            ALU_OP_OUT <= ALU_OP;
            ALU_SRC_OUT <= ALU_SRC;
            MEM_READ_OUT <= MEM_READ;
            MEM_WRITE_OUT <= MEM_WRITE;
            MEM_TO_REG_OUT <= MEM_TO_REG;
            REG_DEST_OUT <= REG_DEST;

            RS_DATA_OUT <= RS_DATA;
            RT_DATA_OUT <= RT_DATA;
            IMMEDIATE_OUT <= IMMEDIATE;

            RS_OUT <= RS;
            RT_OUT <= RT;
            RD_OUT <= RD;
            FUNC_OUT <= FUNC;
        end if;
    end process;
end Behavioral;

