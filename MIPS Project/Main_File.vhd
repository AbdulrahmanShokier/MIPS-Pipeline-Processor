library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MIPS_MAIN is
    Port (
        CLK   : in  STD_LOGIC;    -- Clock signal
        RESET : in  STD_LOGIC     -- Reset signal
    );
end MIPS_MAIN;

architecture Behavioral of MIPS_MAIN is

    -- Component Declarations
    component MUX_32 is
        Port (
            MUX_IN1 : in  STD_LOGIC_VECTOR (31 downto 0); -- PC+4
            MUX_IN2 : in  STD_LOGIC_VECTOR (31 downto 0); -- PC+4+IMM VALUE
            SEL     : in  STD_LOGIC;                     -- Selector
            MUX_OUT : out STD_LOGIC_VECTOR (31 downto 0) -- Output to PC
        );
    end component;

    component PC is
        Port (
            PC_N   : in  STD_LOGIC_VECTOR (31 downto 0); -- New PC value
            CLK    : in  STD_LOGIC;                     -- Clock signal
            RESET  : in  STD_LOGIC;                     -- Reset signal
            STALL  : in  STD_LOGIC;                     -- Stall signal
            PC_OUT : out STD_LOGIC_VECTOR (31 downto 0) -- Current PC value
        );
    end component;

    component PC_ADDER is
        Port (
            INPUT1  : in  STD_LOGIC_VECTOR (31 downto 0); -- PC input
            ADD_OUT : out STD_LOGIC_VECTOR (31 downto 0)  -- PC+4 output
        );
    end component;

    component IM_COMPONENT is
        Port (
            PC       : in  STD_LOGIC_VECTOR (31 downto 0); -- PC input
            INSTRUCT : out STD_LOGIC_VECTOR (31 downto 0)  -- Instruction output
        );
    end component;

    component F_ID_REG is
        Port (
            INSTRUCT     : in  STD_LOGIC_VECTOR (31 downto 0); -- Instruction input
            PC           : in  STD_LOGIC_VECTOR (31 downto 0); -- PC input
            INSTRUCT_OUT : out STD_LOGIC_VECTOR (31 downto 0); -- Instruction output
            PC_OUT       : out STD_LOGIC_VECTOR (31 downto 0); -- PC output
            CLK          : in  STD_LOGIC;                     -- Clock signal
            STALL        : in  STD_LOGIC;                     -- Stall signal
            FLUSH        : in  STD_LOGIC                      -- Flush signal
        );
    end component;

    component SIGN_EXTEND is
        Port (
            INPUT  : in  STD_LOGIC_VECTOR (15 downto 0); -- 16-bit input
            OUTPUT : out STD_LOGIC_VECTOR (31 downto 0)  -- 32-bit sign-extended output
        );
    end component;

    component SHIFT is
        Port (
            INPUT  : in  STD_LOGIC_VECTOR (31 downto 0); -- Input value
            OUTPUT : out STD_LOGIC_VECTOR (31 downto 0)  -- Shifted output
        );
    end component;

    component BRANCH_ADDER is
        Port (
        PC_PLUS_4    : in  STD_LOGIC_VECTOR(31 downto 0);  -- PC+4 input
        IMM_SHIFTED  : in  STD_LOGIC_VECTOR(31 downto 0);  -- Shifted immediate value
        BRANCH_ADDR  : out STD_LOGIC_VECTOR(31 downto 0)   -- Branch target address
    );
    end component;

component MAIN_CONTROL_UNIT is
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
end component;

component REG_FILE is
    Port ( 
        READ_ADD1   : in  STD_LOGIC_VECTOR (4 downto 0);  -- rs (read address 1)
        READ_ADD2   : in  STD_LOGIC_VECTOR (4 downto 0);  -- rt (read address 2)
        WRITE_ADD   : in  STD_LOGIC_VECTOR (4 downto 0);  -- rd (write address)
        WRITE_DATA  : in  STD_LOGIC_VECTOR (31 downto 0); -- Data to write
        REG_WRITE_S : in  STD_LOGIC;                      -- Register write signal
        CLK         : in  STD_LOGIC;                       -- Clock signal
        DATA1       : out STD_LOGIC_VECTOR (31 downto 0);  -- Read data 1 (from rs)
        DATA2       : out STD_LOGIC_VECTOR (31 downto 0)   -- Read data 2 (from rt)
    );
end component;

component Compare_Unit is
    Port ( 
        RS_VAL : in  STD_LOGIC_VECTOR(31 downto 0); -- Value of register rs
        RT_VAL : in  STD_LOGIC_VECTOR(31 downto 0); -- Value of register rt
        ZERO   : out STD_LOGIC                  -- Zero flag: '1' if rs = rt, '0' otherwise
    );
end component;

component And_Gate is
    Port (
        A      : in  STD_LOGIC;  -- Input A (ZERO_FLAG)
        B      : in  STD_LOGIC;  -- Input B (BRANCH_SIGNAL)
        RESULT : out STD_LOGIC   -- AND output (MUX selection)
    );
end component;

component HAZARD_DETECTION_UNIT is
    Port ( 
        -- Inputs
        ID_EX_MEM_READ : in STD_LOGIC;    -- MEM_READ signal from ID/EX register
        ID_EX_RT       : in STD_LOGIC_VECTOR(4 downto 0);  -- RT register in ID/EX
        IF_ID_RS       : in STD_LOGIC_VECTOR(4 downto 0);  -- RS register in IF/ID
        IF_ID_RT       : in STD_LOGIC_VECTOR(4 downto 0);  -- RT register in IF/ID
        STALL          : out STD_LOGIC    -- Stall signal (1 to stall, 0 to continue)
    );
end component;

component Control_Mux is
       Port (
        -- Separate control signal inputs
        CTRL_MEM_READ    : in  STD_LOGIC;
        CTRL_MEM_TO_REG  : in  STD_LOGIC;
        CTRL_MEM_WRITE   : in  STD_LOGIC;
        CTRL_ALU_SRC     : in  STD_LOGIC;
        CTRL_REG_WRITE   : in  STD_LOGIC;
        CTRL_ALU_OP      : in  STD_LOGIC_VECTOR(1 downto 0); -- ALU_OP as a 2-bit control signal
        CTRL_REG_DST   : in  STD_LOGIC;
        -- Stall signal input
        CTRL_STALL       : in  STD_LOGIC;

        -- Separate control signal outputs
        CTRL_MEM_READ_OUT    : out STD_LOGIC;
        CTRL_MEM_TO_REG_OUT  : out STD_LOGIC;
        CTRL_MEM_WRITE_OUT   : out STD_LOGIC;
        CTRL_ALU_SRC_OUT     : out STD_LOGIC;
        CTRL_REG_WRITE_OUT   : out STD_LOGIC;
        CTRL_ALU_OP_OUT      : out STD_LOGIC_VECTOR(1 downto 0); -- ALU_OP output
        CTRL_REG_DST_OUT   : out  STD_LOGIC
    );
end component;

component FLUSH_DETECTOR is
Port (
        BRANCH_AND_ZERO_FLAG : in STD_LOGIC;  -- AND gate output (branch and zero flag)
        JUMP : in STD_LOGIC;                   -- Jump instruction signal
        FLUSH_SIGNAL : out STD_LOGIC           -- Output the flush signal
    );
end component;



component ID_EX_REG is
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
end component;

component jump_address_calc is
    Port (
        target   : in  STD_LOGIC_VECTOR(25 downto 0); -- 26-bit target field from J-type instruction
        pcPlus4  : in  STD_LOGIC_VECTOR(31 downto 0); -- PC + 4 input
        jumpAddr : out STD_LOGIC_VECTOR(31 downto 0)  -- Calculated 32-bit jump address
    );
end component;

component FORWARD_A_MUX is
    Port (
        IN1    : in  STD_LOGIC_VECTOR (31 downto 0); -- ID/EX
        IN2    : in  STD_LOGIC_VECTOR (31 downto 0); -- MEM/WB
        IN3    : in  STD_LOGIC_VECTOR (31 downto 0); -- EX/MEM
        OUTPUT : out STD_LOGIC_VECTOR (31 downto 0);
        X      : in  STD_LOGIC_VECTOR (1 downto 0)   -- Select signal
    );
end component;

component FORWARD_B_MUX is
    Port (
        RT       : in  STD_LOGIC_VECTOR (31 downto 0); -- RT register value
        EX_MEM   : in  STD_LOGIC_VECTOR (31 downto 0); -- Forwarded data from EX/MEM
        MEM_WB   : in  STD_LOGIC_VECTOR (31 downto 0); -- Forwarded data from MEM/WB
        IMMEDIATE: in  STD_LOGIC_VECTOR (31 downto 0); -- Immediate value
        FWD_CTRL : in  STD_LOGIC_VECTOR (1 downto 0);  -- 2-bit control signal
        OUTPUT   : out STD_LOGIC_VECTOR (31 downto 0)  -- Selected output
    );
end component;

component ALU_CONTROL is
    Port (
        FUNCT     : in  STD_LOGIC_VECTOR(5 downto 0); -- Function field
        ALU_OP    : in  STD_LOGIC_VECTOR(1 downto 0); -- ALUOp signal
        ALU_CTRL  : out STD_LOGIC_VECTOR(3 downto 0)  -- ALU Control signal
    );
end component;

component ALU is
    Port (
        INPUT1     : in  STD_LOGIC_VECTOR (31 downto 0); -- 32-bit operand 1
        INPUT2     : in  STD_LOGIC_VECTOR (31 downto 0); -- 32-bit operand 2
        ALU_CTRL   : in  STD_LOGIC_VECTOR (3 downto 0);  -- 4-bit ALU control signal
        RESULT     : out STD_LOGIC_VECTOR (31 downto 0)  -- 32-bit output
    );
end component;

component FORWARDING_UNIT is
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
end component ;

component EX_MEM_REG is
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
end component;

component DATA_MEM is
    Port (
        address    : in  STD_LOGIC_VECTOR (31 downto 0); -- 32-bit address
        writeData  : in  STD_LOGIC_VECTOR (31 downto 0); -- 32-bit write data
        clk        : in  STD_LOGIC;                      -- Clock input
        memRead    : in  STD_LOGIC;                      -- Memory read control
        memWrite   : in  STD_LOGIC;                      -- Memory write control
        readData   : out STD_LOGIC_VECTOR (31 downto 0)  -- 32-bit read data output
    );
end component;

component MEM_WB is
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
end component;


component RD_RT_MUX is
    Port ( RT : in  STD_LOGIC_VECTOR (4 downto 0);
           RD : in  STD_LOGIC_VECTOR (4 downto 0);
           X : in  STD_LOGIC;
           OUTPUT : out  STD_LOGIC_VECTOR (4 downto 0)
           );
end component;



------ Signals---------------------------------------------------------------------------
    signal PC_OUT          : STD_LOGIC_VECTOR(31 downto 0); -- Current PC value
    signal MUX_OUT         : STD_LOGIC_VECTOR(31 downto 0); -- Output of MUX (input to PC)
    signal ADDER_OUT       : STD_LOGIC_VECTOR(31 downto 0); -- Output of PC_ADDER (PC+4)
    signal INSTRUCTION     : STD_LOGIC_VECTOR(31 downto 0); -- Output of instruction memory
    signal INSTRUCT_OUT    : STD_LOGIC_VECTOR(31 downto 0); -- Instruction output from IF/ID register
    signal PC_REG_OUT      : STD_LOGIC_VECTOR(31 downto 0); -- PC output from IF/ID register
    signal SIGN_EXT_OUT    : STD_LOGIC_VECTOR(31 downto 0); -- Output of SIGN_EXTEND
    signal SHIFT_OUT       : STD_LOGIC_VECTOR(31 downto 0); -- Output of SHIFT
    signal IMM_VALUE       : STD_LOGIC_VECTOR(15 downto 0); -- Immediate value extracted
    signal BRANCH_ADDR   : STD_LOGIC_VECTOR(31 downto 0); -- Output of BRANCH_ADDER
    signal BRANCH_MUX_OUT : STD_LOGIC_VECTOR(31 downto 0); -- Output of BRANCH_MUX
    signal JUMP_ADDR : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

    signal STALL           : STD_LOGIC := '0'; -- Placeholder for Stall signal
    signal FLUSH           : STD_LOGIC := '0'; -- Placeholder for Flush signal
    signal PC_SEL             : STD_LOGIC := '0'; -- Placeholder for MUX selector signal
    signal BRANCH_SEL    : STD_LOGIC := '0'; -- Placeholder for branch selection signal
    signal OPCODE     : STD_LOGIC_VECTOR(5 downto 0); -- Opcode extracted from instruction
    signal BRANCH     : STD_LOGIC;                   -- Branch signal from control unit
    signal MEM_READ   : STD_LOGIC;                   -- Memory read signal
    signal MEM_TO_REG : STD_LOGIC;                   -- Memory-to-register signal
    signal MEM_WRITE  : STD_LOGIC;                   -- Memory write signal
    signal ALU_SRC    : STD_LOGIC;                   -- ALU source signal
    signal REG_WRITE  : STD_LOGIC;                   -- Register write signal
    signal REG_DES    : STD_LOGIC;                   -- Register destination signal
    signal JUMP       : STD_LOGIC;                   -- Jump signal
    signal ALU_OP     : STD_LOGIC_VECTOR(1 downto 0); -- ALU operation signal
    
    signal WRITE_ADD : STD_LOGIC_VECTOR(4 downto 0) := (others => '0'); -- Write address, initially zero
    signal WRITE_DATA : STD_LOGIC_VECTOR(31 downto 0) := (others => '0'); -- Write data, initially zero
    signal REG_WRITE_S : STD_LOGIC := '0'; -- Initialize REG_WRITE_S to 0
    signal READ_DATA1 : STD_LOGIC_VECTOR (31 downto 0); -- Output data1 from register file
    signal READ_DATA2 : STD_LOGIC_VECTOR (31 downto 0); -- Output data2 from register file

    signal Zero_Flag          : STD_LOGIC ; -- Placeholder for Stall signal

    signal ID_EX_MemRead: STD_LOGIC := '0';
    signal ID_EX_RT : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');

    signal CTRL_MEM_READ_OUT    : STD_LOGIC;
    signal CTRL_MEM_TO_REG_OUT  : STD_LOGIC;
    signal CTRL_MEM_WRITE_OUT   : STD_LOGIC;
    signal CTRL_ALU_SRC_OUT     : STD_LOGIC;
    signal CTRL_REG_WRITE_OUT   : STD_LOGIC;
    signal CTRL_ALU_OP_OUT      : STD_LOGIC_VECTOR(1 downto 0); 
    signal CTRL_REG_DST_OUT : STD_LOGIC;

    signal    ID_EX_REG_WRITE_OUT :  STD_LOGIC;
    signal    ID_EX_ALU_OP_OUT :  STD_LOGIC_VECTOR(1 downto 0);
    signal    ID_EX_ALU_SRC_OUT :  STD_LOGIC;
    signal    ID_EX_MEM_READ_OUT :  STD_LOGIC;
    signal    ID_EX_MEM_WRITE_OUT :  STD_LOGIC;
    signal    ID_EX_MEM_TO_REG_OUT :  STD_LOGIC;
    signal    ID_EX_REG_DEST_OUT :  STD_LOGIC;
    signal    ID_EX_RS_DATA_OUT :  STD_LOGIC_VECTOR(31 downto 0);
    signal    ID_EX_RT_DATA_OUT :  STD_LOGIC_VECTOR(31 downto 0);
    signal    ID_EX_IMMEDIATE_OUT :  STD_LOGIC_VECTOR(31 downto 0);
    signal    ID_EX_RS_OUT :  STD_LOGIC_VECTOR(4 downto 0);
    signal    ID_EX_RT_OUT :  STD_LOGIC_VECTOR(4 downto 0);
    signal    ID_EX_RD_OUT :  STD_LOGIC_VECTOR(4 downto 0);
    signal    ID_EX_FUNC_OUT :  STD_LOGIC_VECTOR(5 downto 0);
	
    signal    JUMP_ADDRESS_S:STD_LOGIC_VECTOR(31 downto 0);

    signal    F_U_Ctrl_AMUX:STD_LOGIC_VECTOR(1 downto 0);
    signal    F_U_Ctrl_BMUX:STD_LOGIC_VECTOR(1 downto 0);

    signal    AluOpCtrl_out:STD_LOGIC_VECTOR(3 downto 0);

    
    signal    ALU_A_operand:STD_LOGIC_VECTOR(31 downto 0);
    signal    ALU_B_operand:STD_LOGIC_VECTOR(31 downto 0);
  
    signal    ALU_result_formALU:STD_LOGIC_VECTOR(31 downto 0);

    --signals for the output of the Decode _ Execute register

    Signal        EX_MEM_MemWrite_out :   STD_LOGIC;
    Signal        EX_MEM_MemRead_out  :   STD_LOGIC;
    Signal        EX_MEM_RegWrite_out :   STD_LOGIC;
    Signal        EX_MEM_MemToReg_out :   STD_LOGIC;
    Signal        EX_MEM_ALU_Result_out :   STD_LOGIC_VECTOR(31 downto 0);
    Signal        EX_MEM_Write_Data_out :   STD_LOGIC_VECTOR(31 downto 0);
    Signal        EX_MEM_Write_Register_out :   STD_LOGIC_VECTOR(4 downto 0);

    signal	  MEM_data_output:STD_LOGIC_VECTOR(31 downto 0);
    
    signal        MEM_WB_AluResult_out:STD_LOGIC_VECTOR(31 downto 0); 
    signal        MEM_WB_MemOut_out:STD_LOGIC_VECTOR(31 downto 0); 
    signal        MEM_WB_memToReg_out:STD_LOGIC; 
    signal        MEM_WB_regWrite_out:STD_LOGIC; 
    signal        MEM_WB_rd_out:STD_LOGIC_VECTOR(4 downto 0);

    signal        MemToRegMUX_out:STD_LOGIC_VECTOR(31 downto 0);
    
    signal        EX_MEM_RtRd_mux_out:STD_LOGIC_VECTOR(4 downto 0);
begin

    -- MUX_32 Instantiation
    MUX_INST : MUX_32
    port map (
        MUX_IN1 => BRANCH_MUX_OUT,  -- Branch MUX output
        MUX_IN2 => JUMP_ADDR,       -- Temporary placeholder for jump address
        SEL     => PC_SEL,             -- Placeholder for PC selection signal
        MUX_OUT => MUX_OUT          -- Output connected to PC
    );

    -- PC Instantiation
    PC_INST : PC
        port map (
            PC_N   => MUX_OUT,  -- MUX output becomes the new PC value
            CLK    => CLK,
            RESET  => RESET,
            STALL  => STALL,    -- Placeholder for Stall signal
            PC_OUT => PC_OUT    -- Current PC value
        );

    -- PC_ADDER Instantiation
    PC_ADDER_INST : PC_ADDER
        port map (
            INPUT1  => PC_OUT,     -- Current PC value as input
            ADD_OUT => ADDER_OUT   -- PC+4 output
        );

    -- IM_COMPONENT Instantiation
    IM_INST : IM_COMPONENT
        port map (
            PC       => PC_OUT,      -- Current PC value as input
            INSTRUCT => INSTRUCTION  -- Instruction output
        );

    -- F_ID_REG Instantiation
    F_ID_REG_INST : F_ID_REG
        port map (
            INSTRUCT     => INSTRUCTION,  -- Instruction from IM_COMPONENT
            PC           => ADDER_OUT,    -- PC+4 from PC_ADDER
            INSTRUCT_OUT => INSTRUCT_OUT, -- Output to ID stage
            PC_OUT       => PC_REG_OUT,   -- Output to ID stage
            CLK          => CLK,
            STALL        => STALL,       -- Placeholder for Stall signal
            FLUSH        => FLUSH        -- Placeholder for Flush signal
        );

    -- SIGN_EXTEND Instantiation
    IMM_VALUE <= INSTRUCT_OUT(15 downto 0); -- Extract immediate value (bits 15:0)
    SIGN_EXT_INST : SIGN_EXTEND
        port map (
            INPUT  => IMM_VALUE,
            OUTPUT => SIGN_EXT_OUT
        );

    -- SHIFT Instantiation
    SHIFT_INST : SHIFT
        port map (
            INPUT  => SIGN_EXT_OUT, -- Output from SIGN_EXTEND
            OUTPUT => SHIFT_OUT     -- Shifted immediate value
        );

    BRANCH_ADDER_INST : BRANCH_ADDER
        port map (
            PC_PLUS_4    => PC_REG_OUT,   -- PC+4 output from IF/ID register
            IMM_SHIFTED  => SHIFT_OUT,    -- Shifted immediate value
       	    BRANCH_ADDR  => BRANCH_ADDR   -- Branch target address
        );
    BRANCH_MUX_INST : MUX_32
        port map (
            MUX_IN1 => ADDER_OUT,        -- PC+4 output from PC_ADDER
            MUX_IN2 => BRANCH_ADDR,      -- Output from BRANCH_ADDER
            SEL     => BRANCH_SEL,       -- Placeholder for branch selection signal
            MUX_OUT => BRANCH_MUX_OUT    -- Output to the PC MUX
    );

    OPCODE <= INSTRUCT_OUT(31 downto 26); -- Extract opcode bits 31-26 from the instruction
MAIN_CONTROL_UNIT_INST : MAIN_CONTROL_UNIT
port map (
    OP_CODE    => OPCODE,     -- Opcode extracted from instruction
    BRANCH     => BRANCH,     -- Branch signal output
    MEM_READ   => MEM_READ,   -- Memory read signal
    MEM_TO_REG => MEM_TO_REG, -- Memory-to-register signal
    MEM_WRITE  => MEM_WRITE,  -- Memory write signal
    ALU_SRC    => ALU_SRC,    -- ALU source signal
    REG_WRITE  => REG_WRITE,  -- Register write signal
    REG_DES    => REG_DES,    -- Register destination signal
    JUMP       => JUMP,       -- Jump signal
    ALU_OP     => ALU_OP      -- ALU operation signal
);
PC_SEL <= JUMP; -- PC selection depends only on the jump signal

REG_FILE_INST : REG_FILE
    port map (
        READ_ADD1   => INSTRUCT_OUT(25 downto 21),  -- rs from instruction (bits 25-21)
        READ_ADD2   => INSTRUCT_OUT(20 downto 16),  -- rt from instruction (bits 20-16)
        WRITE_ADD   => WRITE_ADD,                    -- Write address (updated in write-back stage)
        WRITE_DATA  => WRITE_DATA,                   -- Write data (updated in write-back stage)
        REG_WRITE_S => REG_WRITE_S,                  -- Register write signal (initially 0, updated in write-back stage)
        CLK         => CLK,                          -- Clock signal
        DATA1       => READ_DATA1,                   -- Output data1 (from rs)
        DATA2       => READ_DATA2                    -- Output data2 (from rt)
    );

CMP_UNIT_INST : Compare_Unit
    port map (
        RS_VAL => READ_DATA1,
        RT_VAL => READ_DATA2, 
        ZERO   => Zero_Flag
    );

And_Gate_INST : And_Gate
    port map (
        A      => BRANCH,
        B      => Zero_Flag,
        RESULT => BRANCH_SEL
    );

FLUSH_UNIT_INST : FLUSH_DETECTOR
    port map (
	BRANCH_AND_ZERO_FLAG => BRANCH_SEL,
	JUMP => PC_SEL,
	FLUSH_SIGNAL => FLUSH 
	);

Hazard_Det_Unit_INST : HAZARD_DETECTION_UNIT
    port map (
        ID_EX_MEM_READ => ID_EX_MemRead,
        ID_EX_RT => ID_EX_RT,
        IF_ID_RS  => INSTRUCT_OUT(25 downto 21),
        IF_ID_RT   => INSTRUCT_OUT(20 downto 16),
        STALL  => STALL
    );

Control_Mux_INST : Control_Mux
    port map (
        CTRL_MEM_READ    => MEM_READ,
        CTRL_MEM_TO_REG  => MEM_TO_REG,
        CTRL_MEM_WRITE   => MEM_WRITE,
        CTRL_ALU_SRC     => ALU_SRC,
        CTRL_REG_WRITE   => REG_WRITE,
        CTRL_ALU_OP      => ALU_OP,
        CTRL_REG_DST => REG_DES,
        -- Stall signal input
        CTRL_STALL       => STALL,

        -- Separate control signal outputs
        CTRL_MEM_READ_OUT    => CTRL_MEM_READ_OUT,
        CTRL_MEM_TO_REG_OUT  => CTRL_MEM_TO_REG_OUT,
        CTRL_MEM_WRITE_OUT   => CTRL_MEM_WRITE_OUT,
        CTRL_ALU_SRC_OUT     => CTRL_ALU_SRC_OUT ,
        CTRL_REG_WRITE_OUT   => CTRL_REG_WRITE_OUT,
        CTRL_ALU_OP_OUT      => CTRL_ALU_OP_OUT,
	CTRL_REG_DST_OUT => CTRL_REG_DST_OUT
    );

JUMP_calc: jump_address_calc 
port map(
	pcPlus4 =>PC_REG_OUT,
	target =>INSTRUCT_OUT(25 downto 0),
	jumpAddr => JUMP_ADDR
	);


ID_EX_REG_INST : ID_EX_REG
    port map (
        REG_WRITE    => CTRL_REG_WRITE_OUT,
        ALU_OP  => CTRL_ALU_OP_OUT,
        ALU_SRC   => CTRL_ALU_SRC_OUT ,
        MEM_READ     => CTRL_MEM_READ_OUT,
        MEM_WRITE   => CTRL_MEM_WRITE_OUT,
        MEM_TO_REG      => CTRL_MEM_TO_REG_OUT,
        REG_DEST => CTRL_REG_DST_OUT,
        RS_DATA       => READ_DATA1,
	RT_DATA => READ_DATA2,
	IMMEDIATE => SIGN_EXT_OUT,
        RS    => INSTRUCT_OUT(25 downto 21),
        RT  => INSTRUCT_OUT(20 downto 16),
	RD => INSTRUCT_OUT(15 downto 11),
	FUNC => INSTRUCT_OUT(5 downto 0),
        CLK => CLK,
        RESET => RESET,

        REG_WRITE_OUT => ID_EX_REG_WRITE_OUT,
        ALU_OP_OUT => ID_EX_ALU_OP_OUT,
        ALU_SRC_OUT => ID_EX_ALU_SRC_OUT,
        MEM_READ_OUT => ID_EX_MEM_READ_OUT,
        MEM_WRITE_OUT => ID_EX_MEM_WRITE_OUT,
        MEM_TO_REG_OUT => ID_EX_MEM_TO_REG_OUT,
        REG_DEST_OUT => ID_EX_REG_DEST_OUT,

        RS_DATA_OUT => ID_EX_RS_DATA_OUT,
        RT_DATA_OUT => ID_EX_RT_DATA_OUT,
        IMMEDIATE_OUT => ID_EX_IMMEDIATE_OUT,

        RS_OUT => ID_EX_RS_OUT,
        RT_OUT => ID_EX_RT_OUT,
        RD_OUT => ID_EX_RD_OUT,
        FUNC_OUT => ID_EX_FUNC_OUT

    );

ID_EX_MemRead <= ID_EX_MEM_READ_OUT;
ID_EX_RT <= ID_EX_RT_OUT;


FOR_UNIT : FORWARDING_UNIT
port map (
       	   EX_MEM_REG_WRITE =>EX_MEM_RegWrite_out,
           MEM_WB_REG_WRITE =>MEM_WB_regWrite_out,
           ID_EX_RS         =>ID_EX_RS_OUT,
           ID_EX_RT         =>ID_EX_RT_OUT,
           EX_MEM_RD        =>EX_MEM_Write_Register_out,
           MEM_WB_RD        => MEM_WB_rd_out,
           ALUSrc           =>CTRL_ALU_SRC_OUT,
           FORWARD_A        =>F_U_Ctrl_AMUX,
           FORWARD_B        =>F_U_Ctrl_BMUX
           );

ALU_CTRL_component:ALU_CONTROL
port map(
	FUNCT     =>ID_EX_FUNC_OUT,
        ALU_OP    =>ID_EX_ALU_OP_OUT,
        ALU_CTRL  =>AluOpCtrl_out
	);

ForA_mux: FORWARD_A_MUX
port map(
	IN1=>ID_EX_RS_DATA_OUT,
	IN2=>MEM_WB_MemOut_out,
	IN3=>EX_MEM_ALU_Result_out,
	OUTPUT=>ALU_A_operand,
	X=>F_U_Ctrl_AMUX
	);

ForB_mux: FORWARD_B_MUX
port map(
	RT=>ID_EX_RT_DATA_OUT,
	EX_MEM=>EX_MEM_ALU_Result_out,
	MEM_WB=>MEM_WB_MemOut_out,
	IMMEDIATE=>ID_EX_IMMEDIATE_OUT,
	FWD_CTRL=>F_U_Ctrl_BMUX,
	OUTPUT=>ALU_B_operand
	);


ALU_component:ALU
port map(
	INPUT1    =>ALU_A_operand,
        INPUT2    =>ALU_B_operand,
        ALU_CTRL  =>AluOpCtrl_out,
        RESULT    =>ALU_result_formALU
	);
	
EX_MEM_REG_INST : EX_MEM_REG
port map (
        CLK=> CLK,
        RESET=>RESET,
        -- Inputs
        MemWrite_in    =>ID_EX_MEM_WRITE_OUT,
        MemRead_in     =>ID_EX_MEM_READ_OUT,
        RegWrite_in    =>ID_EX_REG_WRITE_OUT,
        MemToReg_in    =>ID_EX_MEM_TO_REG_OUT,
        ALU_Result_in  =>ALU_result_formALU,
        Write_Data_in  =>ALU_B_operand,
        Write_Register_in => EX_MEM_RtRd_mux_out,
        -- Outputs
        MemWrite_out  => EX_MEM_MemWrite_out,
        MemRead_out   => EX_MEM_MemRead_out,
        RegWrite_out  => EX_MEM_RegWrite_out,
        MemToReg_out  => EX_MEM_MemToReg_out,
        ALU_Result_out  =>EX_MEM_ALU_Result_out,
        Write_Data_out  =>EX_MEM_Write_Data_out,
        Write_Register_out => EX_MEM_Write_Register_out
    );


DATA_MEM_component:DATA_MEM 
    Port map(
        address=>EX_MEM_ALU_Result_out,
        writeData=>EX_MEM_Write_Data_out,
        clk=>CLK,
        memRead =>EX_MEM_MemRead_out,
        memWrite=>EX_MEM_MemWrite_out,
        readData=>MEM_data_output
    	);

MEM_WB_REG_INST: MEM_WB 
    Port map(
        clk=> CLK,
        rst=> RESET,   
        memToReg=>EX_MEM_MemToReg_out,
        regWrite=>EX_MEM_RegWrite_out,
        ALUResult=>EX_MEM_ALU_Result_out,
        MemOut=>MEM_data_output,    
        rd=>  EX_MEM_Write_Register_out,    

        memToReg_out=>MEM_WB_memToReg_out,
        regWrite_out=> MEM_WB_regWrite_out,
        ALUResult_out=>MEM_WB_AluResult_out ,
        MemOut_out=>MEM_WB_MemOut_out,
        rd_out=>  MEM_WB_rd_out
        );



MemtoReg_mux: MUX_32
port map(
	MUX_IN1 =>MEM_WB_AluResult_out,
        MUX_IN2 =>MEM_WB_MemOut_out,
        SEL => MEM_WB_memToReg_out,
        MUX_OUT => MemToRegMUX_out
	);

EX_MEM_RtRd_mux: RD_RT_MUX
    Port map( RT=>ID_EX_RT_OUT,
              RD=>ID_EX_RD_OUT,
              X=>ID_EX_REG_DEST_OUT,
              OUTPUT =>EX_MEM_RtRd_mux_out
              );

WRITE_DATA<=MemToRegMUX_out;--WR
WRITE_ADD<=MEM_WB_rd_out;--
REG_WRITE_S<=MEM_WB_regWrite_out;--
end Behavioral;


