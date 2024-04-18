 --includes
LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY processor IS
    port map(
        clk,reset: IN std_logic;
        signal_int:IN std_logic;
        input_port: IN std_logic_vector(31 DOWNTO 0);
        output_port: OUT std_logic_vector(31 DOWNTO 0)
    );

END processor;

ARCHITECTURE behavioral OF processor IS
-------------------------------------------- FETCH STAGE -----------------------
component  PCmux is
    port(
        PCnext : in std_logic_vector(31 downto 0);
        PC_BR_Ra: in std_logic_vector(31 downto 0);
        PC_Ret: in std_logic_vector(31 downto 0);
        PC_value: in std_logic_vector(31 downto 0);
        flushEX: in std_logic;
        flushMem: in std_logic;
        PC: out std_logic_vector(31 downto 0)
    );
end component;

component PCregister is
    port(
        clk : in std_logic;
        reset : in std_logic;
        Interrupt : in std_logic;
        WriteEnable : in std_logic;
        ResetValue, InterruptValue,PCValue: in unsigned(11 downto 0);
        PCout : out unsigned(11 downto 0)
    );
end component;

component InstructionMemory is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           address : in  STD_LOGIC_VECTOR (11 downto 0);
           data : out  STD_LOGIC_VECTOR (15 downto 0));
end component;

component FetchDecodeReg is
    port (
        clk : in std_logic;
        reset : in std_logic;
        Interrupt : in std_logic;
        IntermediateEnable : in std_logic;
        pc : in std_logic_vector(31 downto 0);
        instructionIn : in std_logic_vector(15 downto 0);
        instructionOut: out std_logic_vector(15 downto 0);
        PC_data : out std_logic_vector(31 downto 0)
    );
end component;
-------------------------------------------- DECODE  STAGE -----------------------
component Controller IS
PORT (
    enable : IN STD_LOGIC;
    oppCode:IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    Func: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
    one_two_attrib: IN  STD_LOGIC;
    MEM_READ,MEM_WRITE,WRITE_BACK,RS1_RD,RS2_RD:OUT STD_LOGIC;
    RA2_SEL:OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
    WRB_S: OUT  STD_LOGIC_VECTOR (1 DOWNTO 0);
    Free_P_Enable:OUT  STD_LOGIC;
    Mem_protect_enable, Mem_free_enable: OUT  STD_LOGIC;
    aluControl : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
    RS1_RD_SEL,RS2_RD_SEL:OUT STD_LOGIC;
    ra2_sel:OUT STD_LOGIC
);
end component;

component register_file IS
GENERIC (
    bits : INTEGER := 32;
    RegNo: INTEGER := 8
    );
PORT (
    clk : IN STD_LOGIC;
    reset : IN STD_LOGIC;
    data_write : IN STD_LOGIC_VECTOR(bits - 1 DOWNTO 0);
    data_out1 : OUT STD_LOGIC_VECTOR(bits - 1 DOWNTO 0);
    data_out2 : OUT STD_LOGIC_VECTOR(bits - 1 DOWNTO 0);
    write_enable : IN STD_LOGIC;
    read_address1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    read_address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    write_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0)
);
end component;

component mux_rs2 is 
    port(
        rs2, rd   : in  std_logic_vector(2 downto 0);
        ra2       : out std_logic_vector(2 downto 0);
        rs2_rd    : in  std_logic
    );
end component;

component mux_rs1 is
    port(
        rs1, rd   : in  std_logic_vector(2 downto 0);
        ra1       : out std_logic_vector(2 downto 0);
        rs1_rd    : in  std_logic
    );
end component;

component mux_regFile_out is
    port(
        ra2, IMM ,Pc  : in  std_logic_vector(31 downto 0);
        ra2_out       : out std_logic_vector(31 downto 0);
        ra2_Sel   : in  std_logic_vector(1 downto 0)
    );
end component;

component Decode_Execute IS
PORT (
    clk,reset,enable : IN STD_LOGIC;
    dataIn1,dataIn2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --
    alu_control_in: IN STD_LOGIC_VECTOR(3 DOWNTO 0); --
    RA_In:In STD_LOGIC_VECTOR(31 DOWNTO 0); --
    RD_In: IN STD_LOGIC_VECTOR(2 DOWNTO 0); --
    RS1_In,RS2_In: IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- to forward unit
    MEM_READ_In,MEM_WRITE_In,WRITE_BACK_In:IN STD_LOGIC;

    RA_OUT:OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    alu_control_out: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  --
    dataOut1,dataOut2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    RD_Out: OUT STD_LOGIC_VECTOR(2 DOWNTO 0); 
    MEM_READ_Out,MEM_WRITE_Out,WRITE_BACK_Out:OUT STD_LOGIC;
    RS1_out,RS2_out: OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
);
end component;
-------------------------------------------- EXECUTE STAGE -----------------------
component ALU IS
PORT (
    input1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    input2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
    sel : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    outpt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
    carryout : OUT STD_LOGIC
);
end component;
component Execute_Mememory_Register IS

PORT (
    clk,reset,enable : IN STD_LOGIC;
    MEM_READ_In,MEM_WRITE_In,WRITE_BACK_In:IN STD_LOGIC;
    WRB_S_In: IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
    Rd_address_In: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    Ra_In:In STD_LOGIC_VECTOR(31 DOWNTO 0);
    AluOut_In: In STD_LOGIC_VECTOR(31 DOWNTO 0);


    MEM_READ_Out,MEM_WRITE_Out,WRITE_BACK_Out:OUT STD_LOGIC;
    WRB_S_Out: OUT  STD_LOGIC_VECTOR (1 DOWNTO 0);
    Rd_address_Out: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    Ra_Out:Out STD_LOGIC_VECTOR(31 DOWNTO 0);
    AluOut_Out: Out STD_LOGIC_VECTOR(31 DOWNTO 0)
);
end component;
-------------------------------------------- WRITE BACK STAGE -----------------------
component Mem_WB_reg is
    Port ( 
        clk,reset,enable : in STD_LOGIC;
        Ra2_in : in STD_LOGIC_VECTOR(31 downto 0);
        Mem_data_in : in STD_LOGIC_VECTOR(31 downto 0);
        Alu_data_in : in STD_LOGIC_VECTOR(31 downto 0);
        Rd_address_in : in STD_LOGIC_VECTOR(2 downto 0);
        WBS_in : in STD_LOGIC_VECTOR(1 downto 0);
        WB_EN_in : in STD_LOGIC;
        Ra2_out : out STD_LOGIC_VECTOR(31 downto 0);
        Mem_data_out : out STD_LOGIC_VECTOR(31 downto 0);
        Alu_data_out : out STD_LOGIC_VECTOR(31 downto 0);
        Rd_address_out : out STD_LOGIC_VECTOR(2 downto 0);
        WBS_out : out STD_LOGIC_VECTOR(1 downto 0);
        WB_EN_out : out STD_LOGIC     
    );
end Mem_WB_reg;

    SIGNAL controller_pc_Enable: std_logic;
    SIGNAL Reset_Pc_Value,Interrupt_PC_Value,PC_value_selected,PC_VALUE_OUT:unsigned(11 downto 0);
    SIGNAL PC_next_Instruction,PC_BR_Ra_value,PC_Ret_value,PC_Execption_value:  std_logic_vector(31 downto 0);
    SIGNAL flushEx_signal,flushMem_signal: std_logic;
    SIGNAL Instruction_from_memory:STD_LOGIC_VECTOR (15 downto 0);
    SIGNAL Intermediate_Enable_controller:std_logic;
    SIGNAL Instruction_from_Fetch_Decode : std_logic_vector(15 downto 0);
    SIGNAL PC_value_from_Fetch_Decode : std_logic_vector(31 downto 0);
    SIGNAL Rs1,Rd,Rs2: std_logic_vector (2 downto 0); 
    SIGNAL Rs1_output_Mux,Rs2_output_Mux: std_logic_vector (2 downto 0); 
    SIGNAL rs1_rd_controll,rs2_rd_controll: std_logic;
    SIGNAL Ra1_value_RegisterFile,Ra2_value_RegisterFile:  STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ra2_sel_controll:std_logic;
    SIGNAL Ra2_value_enter_Decode_Execute: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Enable_Decode_Execute,Enable_Execute_Memory,Enable_Mem_Wb: std_logic;
    SIGNAL RA_out_Decode_Execute,RA1_Decode_Execute,RA2_Decode_Execute: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL alu_control_out_Decode_Execute: STD_LOGIC_VECTOR(3 DOWNTO 0); 
    SIGNAL RD_Out_Decode_Execute,RS1_out_Decode_Execute,RS2_out_Decode_Execute:STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL controller_alu_operation:STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL Alu_output_data:STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL OF_flag:std_logic;
    SIGNAL MEM_READ_IN_Decode_Execute,MEM_WRITE_IN_Decode_Execute,WRITE_BACK_IN_Decode_Execute: std_logic;
    SIGNAL MEM_READ_out_Decode_Execute,MEM_WRITE_out_Decode_Execute,WRITE_BACK_out_Decode_Execute: std_logic;
    SIGNAL MEM_READ_out_Execute_Mem,MEM_WRITE_out_Execute_Mem,WRITE_BACK_out_Execute_Mem: std_logic;
    SIGNAL Rd_out_Execute_Mem: STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Ra_Out_Execute_Mem,AluOut_Out_Execute_Mem:STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL WRB_S_Out_Execute_Mem:(1 DOWNTO 0);
    SIGNAL Ra2_out_mem_wb,Mem_data_out_mem_wbt,Alu_data_out_mem_wb:STD_LOGIC_VECTOR(31 downto 0);
    SIGNAL Rd_address_out_mem_wb:STD_LOGIC_VECTOR(2 downto 0);
    SIGNAL WBS_out_mem_wb:STD_LOGIC_VECTOR(1 downto 0);
    SIGNAL WB_EN_out_mem_wb:STD_LOGIC;



begin
    Rs1 <= Instruction_from_Fetch_Decode (6 downto 4);
    Rs2 <= Instruction_from_Fetch_Decode (3 downto 1);
    Rd  <= Instruction_from_Fetch_Decode (9 downto 7);

    PC_: PCregister PORT MAP(clk=>clk,reset=>reset,Interrupt=> signal_int,
    writeEnable=>controller_pc_Enable,
    ResetValue=>Reset_Pc_Value,InterruptValue=>Interrupt_PC_Value,
    PCValue=>PC_value_selected,
    PCout=>PC_VALUE_OUT
    );

    PC_MUX: PCmux PORT MAP (
     PCnext=>PC_next_Instruction,PC_BR_Ra =>PC_BR_Ra_value,PC_Ret=>PC_Ret_value,
     PC_value=>PC_Execption_value,flushEX =>flushEx_signal,
     flushMem=>flushMem_signal,
     PC=>PC_value_selected,
    );

    Instruction_Memory: InstructionMemory PORT MAP (clk=>clk,reset=>reset,
    address=>PC_VALUE_OUT,data=>Instruction_from_memory);


    FetchDecode_Reg: FetchDecodeReg PORT MAP (clk=>clk,reset=>reset,                 ---- THERE NO ENABLE 
    Interrupt=>signal_int, IntermediateEnable=>Intermediate_Enable_controller,
    pc=>(x"00000"&PC_VALUE_OUT),instructionIn=>Instruction_from_memory,           ------------- CHECK PC VALUE ----------------
    instructionOut=>Instruction_from_Fetch_Decode,
    PC_data => PC_value_from_Fetch_Decode
    );

    muxRS1 : mux_rs1 PORT MAP(rs1=>Rs1,rd=>Rd,ra1=>Rs1_output_Mux,rs1_rd=>rs1_rd_controll);

    muxRS2 : mux_rs2 PORT MAP(rs2=>Rs2,rd=>Rd,ra2=>Rs2_output_Mux,rs2_rd=>rs2_rd_controll);

    mux_regFile_ra2: mux_regFile_out PORT MAP(ra2=>Ra2_value_RegisterFile,
    IMM=> (x"00000"&PC_VALUE_OUT),              ------------------------------------------------------------siwajshlffbs----
    Pc=> PC_value_from_Fetch_Decode,ra2_out=>Ra2_value_enter_Decode_Execute,ra2_Sel=>ra2_sel_controll);

    Register_file_comp : register_file PORT MAP (clk=>clk,reset=>reset,
    data_write=> -------------------------------------------------------------------------------- from write back
    read_address1=> Rs1_output_Mux,
    read_address2=> Rs2_output_Mux,
    write_enable=>WB_EN_out_mem_wb,
    write_address=>Rd_address_out_mem_wb,
    data_out1=>Ra1_value_RegisterFile,
    data_out2=>Ra2_value_enter_Decode_Execute
    );
   

    DecodeExecute:  Decode_Execute PORT MAP (clk=>clk,reset=>reset,enable=>Enable_Decode_Execute,
    dataIn1=>Ra1_value_RegisterFile,
    dataIn2=>Ra2_value_enter_Decode_Execute,
    alu_control_in=>alu_controll_signal,
    RA_In=>Ra2_value_RegisterFile,
    RD_In=>Rd,
    Rs1_In=>Rs1_output_Mux,
    RS2_In=> Rs2_output_Mux,
    MEM_READ_In=>MEM_READ_IN_Decode_Execute,
    MEM_WRITE_In=>MEM_WRITE_IN_Decode_Execute,
    WRITE_BACK_In=>WRITE_BACK_IN_Decode_Execute,
    RA_OUT=>RA_out_Decode_Execute,
    alu_control_out=>alu_control_out_Decode_Execute,
    dataOut1=>RA1_Decode_Execute,
    dataOut2=>RA2_Decode_Execute,
    RD_Out=>RD_Out_Decode_Execute,
    MEM_READ_Out=>MEM_READ_out_Decode_Execute,
    MEM_WRITE_Out=>MEM_WRITE_out_Decode_Execute,
    WRITE_BACK_Out=>WRITE_BACK_out_Decode_Execute,
    RS1_out=>RS1_out_Decode_Execute,
    RS2_out=>RS2_out_Decode_Execute
    );

    alu_comp: ALU PORT MAP (input1=>RA1_Decode_Execute,
    input2=>RA2_Decode_Execute,
    sel=>controller_alu_operation,
    outpt=>Alu_output_data,
    carryout=>OF_flag,
    );

    --------- NEED TO ADD MUXES OF FREE/PROTECTED ENABLES AND FORWARD UNITS ----------

    ExecuteMememoryRegister: Execute_Mememory_Register PORT MAP (clk=>clk,reset=>reset,enable=>Enable_Execute_Memory,
    MEM_READ_In=>MEM_READ_out_Decode_Execute,
    MEM_WRITE_In=>MEM_WRITE_out_Decode_Execute,
    WRITE_BACK_In=>WRITE_BACK_out_Decode_Execute,
    WRB_S_In=>----------------------------------------------
    Rd_address_In=>RD_Out_Decode_Execute,
    Ra_In=>RA_out_Decode_Execute,
    AluOut_In=>Alu_output_data,
    MEM_READ_Out=>MEM_READ_out_Execute_Mem,
    MEM_WRITE_Out=>MEM_WRITE_out_Execute_Mem,
    WRITE_BACK_Out=>WRITE_BACK_out_Execute_Mem,
    WRB_S_Out=>WRB_S_Out_Execute_Mem,
    Rd_address_Out=>Rd_out_Execute_Mem,
    Ra_Out=>Ra_Out_Execute_Mem,
    AluOut_Out=>AluOut_Out_Execute_Mem,
    );

    Mem_WB_register :Mem_WB_reg PORT MAP (clk=>clk,reset=>reset,enable=>Enable_Mem_Wb,
    Ra2_in=>Ra_Out_Execute_Mem,
    Mem_data_in=>Ra_Out_Execute_Mem,----------------------------------------------------------- TO BE EDITED WITH MEMERY ACUTALLY DATA --------------------------------------
    Alu_data_in=>luOut_Out_Execute_Mem,
    Rd_address_in=>Rd_out_Execute_Mem,
    WBS_in=>RB_S_Out_Execute_Mem,
    WB_EN_in=>WRITE_BACK_out_Execute_Mem,
    Ra2_out=>Ra2_out_mem_wb,
    Mem_data_out=>Mem_data_out_mem_wbt,
    Alu_data_out=>Alu_data_out_mem_wb,
    Rd_address_out=>Rd_address_out_mem_wb,
    WBS_out=>WBS_out_mem_wb,
    WB_EN_out=>WB_EN_out_mem_wb,
    );


------------------------------ MUX WRITE BACK------------------------------

----------------------------- Controller ------------------------------------

    



end architecture behavioral;