library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity EX_MEM_REG is
    Port (
        CLK         : in  STD_LOGIC;
        RESET       : in  STD_LOGIC;
        -- Inputs
        MemWrite_in : in  STD_LOGIC;
        MemRead_in  : in  STD_LOGIC;
        RegWrite_in : in  STD_LOGIC;
        MemToReg_in : in  STD_LOGIC;
        ALU_Result_in : in  STD_LOGIC_VECTOR(31 downto 0);
        Write_Data_in : in  STD_LOGIC_VECTOR(31 downto 0);
        Write_Register_in : in  STD_LOGIC_VECTOR(4 downto 0);
        -- Outputs
        MemWrite_out : out  STD_LOGIC;
        MemRead_out  : out  STD_LOGIC;
        RegWrite_out : out  STD_LOGIC;
        MemToReg_out : out  STD_LOGIC;
        ALU_Result_out : out  STD_LOGIC_VECTOR(31 downto 0);
        Write_Data_out : out  STD_LOGIC_VECTOR(31 downto 0);
        Write_Register_out : out  STD_LOGIC_VECTOR(4 downto 0)
    );
end EX_MEM_REG;

architecture Behavioral of EX_MEM_REG is
    -- Internal signals to store values
    signal MemWrite_reg, MemRead_reg, RegWrite_reg, MemToReg_reg: STD_LOGIC := '0';
    signal ALU_Result_reg : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal Write_Data_reg : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal Write_Register_reg : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
begin
    process(CLK, RESET)
    begin
        if RESET = '1' then
            -- Reset all outputs to default values
            MemWrite_reg <= '0';
            MemRead_reg <= '0';
            RegWrite_reg <= '0';
            MemToReg_reg <= '0';
            ALU_Result_reg <= (others => '0');
            Write_Data_reg <= (others => '0');
            Write_Register_reg <= (others => '0');
        elsif rising_edge(CLK) then
            -- Latch inputs into internal signals
            MemWrite_reg <= MemWrite_in;
            MemRead_reg <= MemRead_in;
            RegWrite_reg <= RegWrite_in;
            MemToReg_reg <= MemToReg_in;
            ALU_Result_reg <= ALU_Result_in;
            Write_Data_reg <= Write_Data_in;
            Write_Register_reg <= Write_Register_in;
        end if;
    end process;

    -- Assign internal signals to outputs
    MemWrite_out <= MemWrite_reg;
    MemRead_out <= MemRead_reg;
    RegWrite_out <= RegWrite_reg;
    MemToReg_out <= MemToReg_reg;
    ALU_Result_out <= ALU_Result_reg;
    Write_Data_out <= Write_Data_reg;
    Write_Register_out <= Write_Register_reg;
end Behavioral;

