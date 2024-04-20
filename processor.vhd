--includes
library IEEE;
  use ieee.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use IEEE.math_real.all;

entity processor is
  port (
    clk, reset  : in  std_logic;
    signal_int  : in  std_logic;
    input_port  : in  std_logic_vector(31 downto 0);
    output_port : out std_logic_vector(31 downto 0)
  );

end entity;

architecture IMP of processor is
  -------------------------------------------- FETCH STAGE 
  component PCmux is
    port (
      PCnext   : in  std_logic_vector(31 downto 0);
      PC_BR_Ra : in  std_logic_vector(31 downto 0);
      PC_Ret   : in  std_logic_vector(31 downto 0);
      PC_value : in  std_logic_vector(31 downto 0);
      flushEX  : in  std_logic;
      flushMem : in  std_logic;
      PC       : out std_logic_vector(31 downto 0)
    );
  end component;

  component PCregister is
    port (
      clk                                 : in  std_logic;
      reset                               : in  std_logic;
      Interrupt                           : in  std_logic;
      WriteEnable                         : in  std_logic;
      ResetValue, InterruptValue, PCValue : in  unsigned(11 downto 0);
      PCout                               : out unsigned(11 downto 0)
    );
  end component;

  component InstructionMemory is
    port (clk     : in  STD_LOGIC;
          reset   : in  STD_LOGIC;
          address : in  STD_LOGIC_VECTOR(11 downto 0);
          data    : out STD_LOGIC_VECTOR(15 downto 0));
  end component;

  component FetchDecodeReg is
    port (
      clk                : in  std_logic;
      reset              : in  std_logic;
      Interrupt          : in  std_logic;
      IntermediateEnable : in  std_logic;
      pc                 : in  std_logic_vector(31 downto 0);
      instructionIn      : in  std_logic_vector(15 downto 0);
      instructionOut     : out std_logic_vector(15 downto 0);
      PC_data            : out std_logic_vector(31 downto 0)
    );
  end component;
  -------------------------------------------- DECODE  STAGE 
  component Controller is
    port (
      enable                              : in  STD_LOGIC;
      oppCode                             : in  STD_LOGIC_VECTOR(2 downto 0);
      Func                                : in  STD_LOGIC_VECTOR(2 downto 0);
      one_two_attrib                      : in  STD_LOGIC;
      MEM_READ, MEM_WRITE, WRITE_BACK     : out STD_LOGIC;
      RA2_SEL                             : out STD_LOGIC_VECTOR(1 downto 0);
      WRB_S                               : out STD_LOGIC_VECTOR(1 downto 0);
      Free_P_Enable                       : out STD_LOGIC;
      Mem_protect_enable, Mem_free_enable : out STD_LOGIC;
      aluControl                          : out STD_LOGIC_VECTOR(3 downto 0);
      RS1_RD_SEL, RS2_RD_SEL              : out STD_LOGIC;
      Interrupt_Signal                    : out  STD_LOGIC
    );
  end component;

  component register_file is
    generic (
      bits  : INTEGER := 32;
      RegNo : INTEGER := 8
    );
    port (
      clk           : in  STD_LOGIC;
      reset         : in  STD_LOGIC;
      data_write    : in  STD_LOGIC_VECTOR(bits - 1 downto 0);
      data_out1     : out STD_LOGIC_VECTOR(bits - 1 downto 0);
      data_out2     : out STD_LOGIC_VECTOR(bits - 1 downto 0);
      write_enable  : in  STD_LOGIC;
      read_address1 : in  STD_LOGIC_VECTOR(2 downto 0);
      read_address2 : in  STD_LOGIC_VECTOR(2 downto 0);
      write_address : in  STD_LOGIC_VECTOR(2 downto 0)
    );
  end component;

  component mux_rs2 is
    port (
      rs2, rd : in  std_logic_vector(2 downto 0);
      ra2     : out std_logic_vector(2 downto 0);
      rs2_rd  : in  std_logic
    );
  end component;

  component mux_rs1 is
    port (
      rs1, rd : in  std_logic_vector(2 downto 0);
      ra1     : out std_logic_vector(2 downto 0);
      rs1_rd  : in  std_logic
    );
  end component;

  component mux_regFile_out is
    port (
      ra2, IMM, Pc : in  std_logic_vector(31 downto 0);
      ra2_out      : out std_logic_vector(31 downto 0);
      ra2_Sel      : in  std_logic_vector(1 downto 0)
    );
  end component;

  component Decode_Execute is
    port (
      clk, reset, enable                          : in  STD_LOGIC;
      dataIn1, dataIn2                            : in  STD_LOGIC_VECTOR(31 downto 0); --
      alu_control_in                              : in  STD_LOGIC_VECTOR(3 downto 0);  --
      RA_In                                       : in  STD_LOGIC_VECTOR(31 downto 0); --
      RD_In                                       : in  STD_LOGIC_VECTOR(2 downto 0);  --
      RS1_In, RS2_In                              : in  STD_LOGIC_VECTOR(2 downto 0);  -- to forward unit
      MEM_READ_In, MEM_WRITE_In, WRITE_BACK_In    : in  STD_LOGIC;
      WRB_S_In                                    : in  STD_LOGIC_VECTOR(1 downto 0);

      RA_OUT                                      : out STD_LOGIC_VECTOR(31 downto 0);
      alu_control_out                             : out STD_LOGIC_VECTOR(3 downto 0);  --
      dataOut1, dataOut2                          : out STD_LOGIC_VECTOR(31 downto 0);
      RD_Out                                      : out STD_LOGIC_VECTOR(2 downto 0);
      MEM_READ_Out, MEM_WRITE_Out, WRITE_BACK_Out : out STD_LOGIC;
      RS1_out, RS2_out                            : out STD_LOGIC_VECTOR(2 downto 0);
      WRB_S_Out                                   : out STD_LOGIC_VECTOR(1 downto 0)
    );
  end component;
  -------------------------------------------- EXECUTE STAGE 
  component ALU is
    port (
      input1   : in  STD_LOGIC_VECTOR(31 downto 0);
      input2   : in  STD_LOGIC_VECTOR(31 downto 0);
      sel      : in  STD_LOGIC_VECTOR(3 downto 0);
      outpt    : out STD_LOGIC_VECTOR(31 downto 0);
      carryout : out STD_LOGIC
    );
  end component;
  component Execute_Mememory_Register is

    port (
      clk, reset, enable                          : in  STD_LOGIC;
      MEM_READ_In, MEM_WRITE_In, WRITE_BACK_In    : in  STD_LOGIC;
      WRB_S_In                                    : in  STD_LOGIC_VECTOR(1 downto 0);
      Rd_address_In                               : in  STD_LOGIC_VECTOR(2 downto 0);
      Ra_In                                       : in  STD_LOGIC_VECTOR(31 downto 0);
      AluOut_In                                   : in  STD_LOGIC_VECTOR(31 downto 0);

      MEM_READ_Out, MEM_WRITE_Out, WRITE_BACK_Out : out STD_LOGIC;
      WRB_S_Out                                   : out STD_LOGIC_VECTOR(1 downto 0);
      Rd_address_Out                              : out STD_LOGIC_VECTOR(2 downto 0);
      Ra_Out                                      : out STD_LOGIC_VECTOR(31 downto 0);
      AluOut_Out                                  : out STD_LOGIC_VECTOR(31 downto 0)
    );
  end component;
  -------------------------------------------- WRITE BACK STAGE
  component Mem_WB_reg is
    port (
      clk, reset, enable : in  STD_LOGIC;
      Ra2_in             : in  STD_LOGIC_VECTOR(31 downto 0);
      Mem_data_in        : in  STD_LOGIC_VECTOR(31 downto 0);
      Alu_data_in        : in  STD_LOGIC_VECTOR(31 downto 0);
      Rd_address_in      : in  STD_LOGIC_VECTOR(2 downto 0);
      WBS_in             : in  STD_LOGIC_VECTOR(1 downto 0);
      WB_EN_in           : in  STD_LOGIC;
      Ra2_out            : out STD_LOGIC_VECTOR(31 downto 0);
      Mem_data_out       : out STD_LOGIC_VECTOR(31 downto 0);
      Alu_data_out       : out STD_LOGIC_VECTOR(31 downto 0);
      Rd_address_out     : out STD_LOGIC_VECTOR(2 downto 0);
      WBS_out            : out STD_LOGIC_VECTOR(1 downto 0);
      WB_EN_out          : out STD_LOGIC
    );
  end component;

  component mux_WB is
    port (
      InPortData, Mem_data, Alu_Data, RA2 : in  std_logic_vector(31 downto 0);
      DataWriteBack                       : out std_logic_vector(31 downto 0);
      WBW_s                               : in  std_logic_vector(1 downto 0)
    );

  end component;

  signal controller_pc_Enable                                                : std_logic;
  signal Reset_Pc_Value, Interrupt_PC_Value, PC_value_selected, PC_VALUE_OUT : unsigned(11 downto 0);
  SIGNAL PC_INSTRUCTION_INCREMNTED: std_logic_vector(31 downto 0);
  SIGNAL PC_VALUE_SELECTED_STD_LOGIC: std_logic_vector(11 downto 0);
  SIGNAL IMM_CONCATENATED: std_logic_vector(31 downto 0);
  SIGNAL PC_VALUE_SELECTED_CONCATENATED: std_logic_vector(31 downto 0);
  SIGNAL PC_VALUE_CONCATENATED: std_logic_vector(31 downto 0);
  SIGNAL PC_VALUE_OUT_STD_LOGIC: std_logic_vector(11 downto 0);
  SIGNAL PC_MUX_OUT: std_logic_vector(31 downto 0);
  signal PC_next_Instruction, PC_BR_Ra_value, PC_Ret_value, PC_Execption_value : std_logic_vector(31 downto 0);
  signal flushEx_signal, flushMem_signal                                         : std_logic;
  signal Instruction_from_memory                                                 : STD_LOGIC_VECTOR(15 downto 0);
  signal Intermediate_Enable_controller                                          : std_logic;
  signal Instruction_from_Fetch_Decode                                           : std_logic_vector(15 downto 0);
  signal PC_value_from_Fetch_Decode                                              : std_logic_vector(31 downto 0);
  signal Rs1, Rd, Rs2                                                            : std_logic_vector(2 downto 0);
  signal Rs1_output_Mux, Rs2_output_Mux                                          : std_logic_vector(2 downto 0);
  signal rs1_rd_controll, rs2_rd_controll                                        : std_logic;
  signal Ra1_value_RegisterFile, Ra2_value_RegisterFile                          : STD_LOGIC_VECTOR(31 downto 0);
  signal ra2_sel_controll                                                        : std_logic_vector(1 downto 0);
  signal Ra2_value_enter_Decode_Execute                                          : STD_LOGIC_VECTOR(31 downto 0);
  signal Enable_Decode_Execute, Enable_Execute_Memory, Enable_Mem_Wb             : std_logic;
  signal RA_out_Decode_Execute, RA1_Decode_Execute, RA2_Decode_Execute           : STD_LOGIC_VECTOR(31 downto 0);
  signal alu_control_out_Decode_Execute                                          : STD_LOGIC_VECTOR(3 downto 0);
  signal RD_Out_Decode_Execute, RS1_out_Decode_Execute, RS2_out_Decode_Execute   : STD_LOGIC_VECTOR(2 downto 0);
  -- SIGNAL controller_alu_operation:STD_LOGIC_VECTOR (3 DOWNTO 0);
  signal interrupt_signal_controller_out                                                      : std_logic;
  signal Alu_output_data                                                                          : STD_LOGIC_VECTOR(31 downto 0);
  signal OF_flag                                                                                  : std_logic;
  signal MEM_READ_IN_Decode_Execute, MEM_WRITE_IN_Decode_Execute, WRITE_BACK_IN_Decode_Execute    : std_logic;
  signal MEM_READ_out_Decode_Execute, MEM_WRITE_out_Decode_Execute, WRITE_BACK_out_Decode_Execute : std_logic;
  signal MEM_READ_out_Execute_Mem, MEM_WRITE_out_Execute_Mem, WRITE_BACK_out_Execute_Mem          : std_logic;
  signal Rd_out_Execute_Mem                                                                       : STD_LOGIC_VECTOR(2 downto 0);
  signal Ra_Out_Execute_Mem, AluOut_Out_Execute_Mem                                               : STD_LOGIC_VECTOR(31 downto 0);
  signal WRB_S_Out_Execute_Mem                                                                    : STD_LOGIC_VECTOR(1 downto 0);
  signal Ra2_out_mem_wb, Mem_data_out_mem_wbt, Alu_data_out_mem_wb                                : STD_LOGIC_VECTOR(31 downto 0);
  signal Rd_address_out_mem_wb                                                                    : STD_LOGIC_VECTOR(2 downto 0);
  signal WBS_out_mem_wb                                                                           : STD_LOGIC_VECTOR(1 downto 0);
  signal WB_EN_out_mem_wb, enableControll                                                         : STD_LOGIC;
  -- controll signals
  signal Free_P_Enable_con, Mem_protect_enable_con, Mem_free_enable_con : STD_LOGIC;
  signal alu_controll_signal                                            : STD_LOGIC_VECTOR(3 downto 0);
  signal WRB_S_con, WRB_S_Decode_Execute                                : STD_LOGIC_VECTOR(1 downto 0);
  signal Data_write_back_out_muxWB                                      : std_logic_vector(31 downto 0);
  signal InPortData_MUX_WB                                              : std_logic_vector(31 downto 0);

begin


  Rs1 <= Instruction_from_Fetch_Decode(6 downto 4);
  Rs2 <= Instruction_from_Fetch_Decode(3 downto 1);
  Rd  <= Instruction_from_Fetch_Decode(9 downto 7);

  PC1: PCregister
    port map (clk => clk, reset => reset, Interrupt => interrupt_signal_controller_out,
              writeEnable => controller_pc_Enable,
              ResetValue => Reset_Pc_Value, InterruptValue => Interrupt_PC_Value,
              PCValue => unsigned(PC_MUX_OUT(11 downto 0)),
              PCout => (PC_VALUE_OUT)
    );

  PC_MUX: PCmux
    port map (
      PCnext => PC_INSTRUCTION_INCREMNTED,
       PC_BR_Ra => PC_BR_Ra_value, PC_Ret => PC_Ret_value,
      PC_value => PC_Execption_value, flushEX => flushEx_signal,
      flushMem => flushMem_signal,
      PC => PC_MUX_OUT
    );

  InstructionMemory1: InstructionMemory
    port map (clk => clk, reset => reset,
              address => PC_VALUE_OUT_STD_LOGIC, data => Instruction_from_memory);

  FetchDecodeReg1: FetchDecodeReg
    port map (clk => clk, reset => reset, ---- THERE NO ENABLE 
              Interrupt => interrupt_signal_controller_out, IntermediateEnable => Intermediate_Enable_controller,
              pc => PC_VALUE_CONCATENATED, instructionIn => Instruction_from_memory, ------------- CHECK PC VALUE 
              instructionOut => Instruction_from_Fetch_Decode,
              PC_data => PC_value_from_Fetch_Decode
    );

  muxRS1: mux_rs1 port map (rs1 => Rs1, rd => Rd, ra1 => Rs1_output_Mux, rs1_rd => rs1_rd_controll);

  muxRS2: mux_rs2 port map (rs2 => Rs2, rd => Rd, ra2 => Rs2_output_Mux, rs2_rd => rs2_rd_controll);

  mux_regFile_ra2: mux_regFile_out
    port map (ra2     => Ra2_value_RegisterFile,
              IMM     => IMM_CONCATENATED, ------------------------------------------------------------CHECK
              Pc      => PC_value_from_Fetch_Decode,
              ra2_out => Ra2_value_enter_Decode_Execute,
              ra2_Sel => ra2_sel_controll);

  Registerfilecomp1: register_file
    port map (clk => clk, reset => reset,
              data_write => Data_write_back_out_muxWB,
              read_address1 => Rs1_output_Mux,
              read_address2 => Rs2_output_Mux,
              write_enable => WB_EN_out_mem_wb,
              write_address => Rd_address_out_mem_wb,
              data_out1 => Ra1_value_RegisterFile,
              data_out2 => Ra2_value_enter_Decode_Execute
    );

  DecodeExecute: Decode_Execute
    port map (clk => clk, reset => reset, enable => Enable_Decode_Execute,
              dataIn1 => Ra1_value_RegisterFile,
              dataIn2 => Ra2_value_enter_Decode_Execute,
              alu_control_in => alu_controll_signal,
              RA_In => Ra2_value_RegisterFile,
              RD_In => Rd,
              Rs1_In => Rs1_output_Mux,
              RS2_In => Rs2_output_Mux,
              MEM_READ_In => MEM_READ_IN_Decode_Execute,
              MEM_WRITE_In => MEM_WRITE_IN_Decode_Execute,
              WRITE_BACK_In => WRITE_BACK_IN_Decode_Execute,
              WRB_S_In => WRB_S_con,
              RA_OUT => RA_out_Decode_Execute,
              alu_control_out => alu_control_out_Decode_Execute,
              dataOut1 => RA1_Decode_Execute,
              dataOut2 => RA2_Decode_Execute,
              RD_Out => RD_Out_Decode_Execute,
              MEM_READ_Out => MEM_READ_out_Decode_Execute,
              MEM_WRITE_Out => MEM_WRITE_out_Decode_Execute,
              WRITE_BACK_Out => WRITE_BACK_out_Decode_Execute,
              RS1_out => RS1_out_Decode_Execute,
              RS2_out => RS2_out_Decode_Execute,
              WRB_S_Out => WRB_S_Decode_Execute
    );

  alucomp1: ALU
    port map (input1   => RA1_Decode_Execute,
              input2   => RA2_Decode_Execute,
              sel      => alu_control_out_Decode_Execute,
              outpt    => Alu_output_data,
              carryout => OF_flag
    );

  --------- NEED TO ADD MUXES OF FREE/PROTECTED ENABLES AND FORWARD UNITS 
  ExecuteMememoryRegister: Execute_Mememory_Register
    port map (clk => clk, reset => reset, enable => Enable_Execute_Memory,
              MEM_READ_In => MEM_READ_out_Decode_Execute,
              MEM_WRITE_In => MEM_WRITE_out_Decode_Execute,
              WRITE_BACK_In => WRITE_BACK_out_Decode_Execute,
              WRB_S_In => WRB_S_Decode_Execute,
              Rd_address_In => RD_Out_Decode_Execute,
              Ra_In => RA_out_Decode_Execute,
              AluOut_In => Alu_output_data,
              MEM_READ_Out => MEM_READ_out_Execute_Mem,
              MEM_WRITE_Out => MEM_WRITE_out_Execute_Mem,
              WRITE_BACK_Out => WRITE_BACK_out_Execute_Mem,
              WRB_S_Out => WRB_S_Out_Execute_Mem,
              Rd_address_Out => Rd_out_Execute_Mem,
              Ra_Out => Ra_Out_Execute_Mem,
              AluOut_Out => AluOut_Out_Execute_Mem
    );

  MemWBregister: Mem_WB_reg
    port map (clk => clk, reset => reset, enable => Enable_Mem_Wb,
              Ra2_in => Ra_Out_Execute_Mem,
              Mem_data_in => Ra_Out_Execute_Mem, ----------------------------------------------------------- TO BE EDITED WITH MEMERY ACUTALLY DATA 
              Alu_data_in => AluOut_Out_Execute_Mem,
              Rd_address_in => Rd_out_Execute_Mem,
              WBS_in => WRB_S_Out_Execute_Mem,
              WB_EN_in => WRITE_BACK_out_Execute_Mem,
              Ra2_out => Ra2_out_mem_wb,
              Mem_data_out => Mem_data_out_mem_wbt,
              Alu_data_out => Alu_data_out_mem_wb,
              Rd_address_out => Rd_address_out_mem_wb,
              WBS_out => WBS_out_mem_wb,
              WB_EN_out => WB_EN_out_mem_wb
    );

  ----------------------------- Controller
  Controller1: Controller
    port map (enable => enableControll, oppCode => Instruction_from_Fetch_Decode(15 downto 13),
              Func => Instruction_from_Fetch_Decode(12 downto 10),
              one_two_attrib => Instruction_from_Fetch_Decode(0),
              MEM_READ => MEM_READ_IN_Decode_Execute,
              MEM_WRITE => MEM_WRITE_IN_Decode_Execute,
              WRITE_BACK => WRITE_BACK_IN_Decode_Execute,
              RA2_SEL => ra2_sel_controll,
              WRB_S => WRB_S_con,
              Free_P_Enable => Free_P_Enable_con,
              Mem_protect_enable => Mem_protect_enable_con,
              Mem_free_enable => Mem_free_enable_con,
              aluControl => alu_controll_signal,
              RS1_RD_SEL => rs1_rd_controll,
              RS2_RD_SEL => rs2_rd_controll,
              Interrupt_Signal => interrupt_signal_controller_out
    );
  ------------------------------ MUX WRITE BACK
  muxWB: mux_WB
    port map (InPortData    => InPortData_MUX_WB,
              Mem_data      => Mem_data_out_mem_wbt,
              Alu_Data      => AluOut_Out_Execute_Mem,
              RA2           => Ra2_out_mem_wb,
              DataWriteBack => Data_write_back_out_muxWB,
              WBW_s         => WBS_out_mem_wb
    );

    PC_VALUE_SELECTED_STD_LOGIC <= std_logic_vector(PC_value_selected);
    PC_VALUE_OUT_STD_LOGIC <= std_logic_vector(PC_VALUE_OUT);
    PC_VALUE_CONCATENATED <= x"00000" & PC_VALUE_OUT_STD_LOGIC;-- TO BE 32 
    IMM_CONCATENATED <= x"00000" & PC_VALUE_OUT_STD_LOGIC;
    PC_VALUE_SELECTED_CONCATENATED <= x"00000" & PC_VALUE_SELECTED_STD_LOGIC;
    PC_INSTRUCTION_INCREMNTED <= std_logic_vector(unsigned(PC_VALUE_CONCATENATED) + 1);

end architecture;
