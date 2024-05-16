--includes
LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY processor IS
  PORT (
    clk, reset : IN STD_LOGIC;
    signal_int : IN STD_LOGIC;
    input_port : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    output_port : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );

END ENTITY;

ARCHITECTURE IMP OF processor IS
  -------------------------------------------- FETCH STAGE 
  COMPONENT PCmux IS
    PORT (
      PCnext : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      PC_BR_Ra : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      PC_Ret : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      PC_value : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      PC_DATA_MEM_BR_COND : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      SIGNAL_COND : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      flushEX : IN STD_LOGIC;
      flushMem : IN STD_LOGIC;
      predicted : IN STD_LOGIC;
      ZF : IN STD_LOGIC;
      PC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT PCregister IS
    PORT (
      clk : IN STD_LOGIC;
      reset : IN STD_LOGIC;
      Interrupt : IN STD_LOGIC;
      WriteEnable : IN STD_LOGIC;
      ResetValue, InterruptValue, PCValue : IN unsigned(11 DOWNTO 0);
      PCout : OUT unsigned(11 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT InstructionMemory IS
    PORT (
      clk : IN STD_LOGIC;
      reset : IN STD_LOGIC;
      address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      data : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
  END COMPONENT;

  COMPONENT FetchDecodeReg IS
    PORT (
      clk : IN STD_LOGIC;
      reset : IN STD_LOGIC;
      enable : IN STD_LOGIC;
      Interrupt : IN STD_LOGIC;
      IntermediateEnable : IN STD_LOGIC;
      pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      instructionIn : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
      instructionOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      PC_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
  END COMPONENT;
  COMPONENT hazarddectionunit IS
    PORT (
      oldRD : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      currentRS1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      currentRS2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      MEMRead : IN STD_LOGIC;
      WriteBack : IN STD_LOGIC;
      stall : OUT STD_LOGIC
    );

  END COMPONENT;

  COMPONENT PCValuecontrolbox IS
    PORT (
      PC_nextInstruc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      signal_cond : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      PCValue : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
  END COMPONENT;
  -------------------------------------------- DECODE  STAGE 
  COMPONENT Controller IS
    PORT (
      enable : IN STD_LOGIC;
      oppCode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      Func : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      one_two_attrib : IN STD_LOGIC;
      MEM_READ, MEM_WRITE, WRITE_BACK : OUT STD_LOGIC;
      RA2_SEL : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      WRB_S : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      Free_P_Enable : OUT STD_LOGIC;
      Mem_protect_enable, Mem_free_enable : OUT STD_LOGIC;
      aluControl : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      RS1_RD_SEL, RS2_RD_SEL : OUT STD_LOGIC;
      Interrupt_Signal : OUT STD_LOGIC;
      STALL_FETCH_IMM : OUT STD_LOGIC;
      Signal_br : OUT STD_LOGIC_VECTOR (1 DOWNTO 0); --- SIGNAL BRANCHING
      push_signal : OUT STD_LOGIC; -- not initlized
      STACK_SIGNAL : OUT STD_LOGIC;
      SIGNAL_MUX_ALU_TO_MEM : OUT STD_LOGIC;
      out_enable : OUT STD_LOGIC;
      In_Enable : OUT STD_LOGIC;
      control_data_mem : OUT STD_LOGIC
    );
  END COMPONENT;

  COMPONENT register_file IS
    GENERIC (
      bits : INTEGER := 32;
      RegNo : INTEGER := 8
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
  END COMPONENT;

  COMPONENT mux_rs2 IS
    PORT (
      rs2, rd : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      ra2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      rs2_rd : IN STD_LOGIC
    );
  END COMPONENT;

  COMPONENT mux_rs1 IS
    PORT (
      rs1, rd : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      ra1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      rs1_rd : IN STD_LOGIC
    );
  END COMPONENT;

  COMPONENT mux_regFile_out IS
    PORT (
      ra2, IMM, Pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ra2_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ra2_Sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT Decode_Execute IS
    PORT (
      clk, reset, enable : IN STD_LOGIC;
      dataIn1, dataIn2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --
      alu_control_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0); --
      RA_In : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --
      RD_In : IN STD_LOGIC_VECTOR(2 DOWNTO 0); --
      RS1_In, RS2_In : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- to forward unit
      MEM_READ_In, MEM_WRITE_In, WRITE_BACK_In : IN STD_LOGIC;
      WRB_S_In : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      Signal_br_control_In : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      Push_signal_DEC_EX_IN : IN STD_LOGIC;
      Protect_signal_DEC_EX_IN : IN STD_LOGIC;
      Free_signal_DEC_EX_IN : IN STD_LOGIC;
      STACK_DEC_EX_IN : IN STD_LOGIC;
      Free_P_Enable_IN : IN STD_LOGIC;
      out_enable_IN : IN STD_LOGIC;
      In_enable_IN : IN STD_LOGIC;
      controll_mem_data_In : IN STD_LOGIC;

      RA_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      alu_control_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); --
      dataOut1, dataOut2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      RD_Out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      MEM_READ_Out, MEM_WRITE_Out, WRITE_BACK_Out : OUT STD_LOGIC;
      RS1_out, RS2_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      WRB_S_Out : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
      Signal_br_control_Out : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
      Push_signal_DEC_EX_OUT : OUT STD_LOGIC;
      Protect_signal_DEC_EX_OUT : OUT STD_LOGIC;
      Free_signal_DEC_EX_OUT : OUT STD_LOGIC;
      STACK_DEC_EX_OUT : OUT STD_LOGIC;
      Free_P_Enable_OUT : OUT STD_LOGIC;
      out_enable_OUT : OUT STD_LOGIC;
      In_enable_OUT : OUT STD_LOGIC;
      controll_mem_data_OUT : OUT STD_LOGIC
    );
  END COMPONENT;
  -------------------------------------------- EXECUTE STAGE 
  COMPONENT ALU IS
    PORT (
      input1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      input2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      sel : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
      outpt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

      Zero_flag : OUT STD_LOGIC;
      Negative_flag : OUT STD_LOGIC;
      Overflow_flag : OUT STD_LOGIC;
      Carry_flag : OUT STD_LOGIC

    );
  END COMPONENT;

  COMPONENT mux_source_alu1 IS
    PORT (
      RA, SRC_DATA_EXE, SRC_DATA_MEM : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      DATA_OUT_TO_ALU : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ForwardUnit_sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT Execute_Mememory_Register IS

    PORT (
      clk, reset, enable : IN STD_LOGIC;
      MEM_READ_In, MEM_WRITE_In, WRITE_BACK_In : IN STD_LOGIC;
      WRB_S_In : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      Rd_address_In : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      Ra_In : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      AluOut_In : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      RA2_DATA_WB_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      Push_signal_EX_MEM_IN : IN STD_LOGIC;
      Protect_signal_EX_MEM_IN : IN STD_LOGIC;
      Free_signal_EX_MEM_IN : IN STD_LOGIC;
      STACK_EX_MEM_IN : IN STD_LOGIC;
      Free_P_Enable_IN : IN STD_LOGIC;
      In_port_data_In : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      Signal_br_control_IN : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      RA_1_IN : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

      MEM_READ_Out, MEM_WRITE_Out, WRITE_BACK_Out : OUT STD_LOGIC;
      WRB_S_Out : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
      Rd_address_Out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      Ra_Out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      AluOut_Out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      RA2_DATA_WB_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      Push_signal_EX_MEM_OUT : OUT STD_LOGIC;
      Protect_signal_EX_MEM_OUT : OUT STD_LOGIC;
      Free_signal_EX_MEM_OUT : OUT STD_LOGIC;
      STACK_EX_MEM_OUT : OUT STD_LOGIC;
      Free_P_Enable_OUT : OUT STD_LOGIC;
      In_port_data_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      Signal_br_control_OUT : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
      RA_1_OUT : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
  END COMPONENT;
  COMPONENT mux_data_address IS
    PORT (
      alu_data, ra : IN unsigned(11 DOWNTO 0);
      address_out : OUT unsigned(11 DOWNTO 0);
      sel : IN STD_LOGIC
    );
  END COMPONENT;
  COMPONENT ExeceptionBranch IS
    PORT (
      clk : IN STD_LOGIC;
      signal_br : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      bit_predict : IN STD_LOGIC;
      Flush_F : OUT STD_LOGIC
    );
  END COMPONENT;
  COMPONENT mux_ra2_data_mem IS
    PORT (
      ra2_forwarderd, ra2_alu : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ra2_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      sel : IN STD_LOGIC
    );
  END COMPONENT;
  -------------------------------------------- WRITE BACK STAGE
  COMPONENT Memory IS
    PORT (
      clk : IN STD_LOGIC;
      reset : IN STD_LOGIC;
      address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
      data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      MEM_READ : IN STD_LOGIC;
      MEM_WRITE : IN STD_LOGIC;
      Protect : IN STD_LOGIC;
      Free : IN STD_LOGIC;
      Push_PC : IN STD_LOGIC;
      alu_src : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      PC_RST : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      PC_Interrupt : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT sp_addressmux IS
    PORT (
      push_enable : IN STD_LOGIC;
      sp_enable : IN STD_LOGIC;
      stack_pointer : IN unsigned(31 DOWNTO 0);
      EA : IN unsigned(11 DOWNTO 0);

      data_out : OUT unsigned(11 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT stackpointer IS
    PORT (
      clk : IN STD_LOGIC;
      reset : IN STD_LOGIC;
      push_pop : IN STD_LOGIC;
      enable : IN STD_LOGIC;
      stackpointer : OUT unsigned (31 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT Mem_WB_reg IS
    PORT (
      clk, reset, enable : IN STD_LOGIC;
      Ra2_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      Mem_data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      Alu_data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      Rd_address_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      WBS_in : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      WB_EN_in : IN STD_LOGIC;
      In_port_data_In : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

      Ra2_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      Mem_data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      Alu_data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      Rd_address_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      WBS_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      WB_EN_out : OUT STD_LOGIC;
      In_port_data_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT mux_WB IS
    PORT (
      InPortData, Mem_data, Alu_Data, RA2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      DataWriteBack : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      WBW_s : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
    );

  END COMPONENT;
  ------------------------------------------- HAZARDS COMPONENTS 
  COMPONENT ForwardUnit IS
    PORT (
      RS1_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      RS2_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      Rd_address_EM_reg : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      WRB_EN_EM_reg : IN STD_LOGIC;
      Rd_address_MW_reg : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      WRB_EN_MW_reg : IN STD_LOGIC;

      Alu_src2_sel : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      Alu_src1_sel : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
  END COMPONENT;
  COMPONENT MemoryBranch IS
    PORT (
      clk : IN STD_LOGIC;
      signal_br : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
      bit_predict : IN STD_LOGIC;
      ZF : IN STD_LOGIC;
      Flush_MEM : OUT STD_LOGIC;
      predicted_out : OUT STD_LOGIC
    );
  END COMPONENT;
  --------------------------------------------- OUTPUT INPUTS PORT ---------------------------------------------
  COMPONENT Output IS
    PORT (
      enable : IN STD_LOGIC;
      reset : IN STD_LOGIC;
      datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
  END COMPONENT;

  COMPONENT input IS
    PORT (
      enable : IN STD_LOGIC;
      reset : IN STD_LOGIC;
      datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
  END COMPONENT;

  SIGNAL controller_pc_Enable : STD_LOGIC;
  SIGNAL Reset_Pc_Value, Interrupt_PC_Value : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL Reset_Pc_Value_32 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL Interrupt_PC_Value_32 : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL PC_value_selected, PC_VALUE_OUT : unsigned(11 DOWNTO 0);
  SIGNAL PC_INSTRUCTION_INCREMNTED : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL PC_VALUE_SELECTED_STD_LOGIC : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL IMM_CONCATENATED : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL PC_VALUE_SELECTED_CONCATENATED : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL PC_VALUE_CONCATENATED : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL PC_VALUE_OUT_STD_LOGIC : STD_LOGIC_VECTOR(11 DOWNTO 0);
  SIGNAL PC_MUX_OUT : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL PC_next_Instruction, PC_BR_Ra_value, PC_Ret_value : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL flushEx_signal, flushMem_signal : STD_LOGIC;
  SIGNAL Instruction_from_memory : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL Intermediate_Enable_controller : STD_LOGIC;
  SIGNAL Instruction_from_Fetch_Decode : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL PC_value_from_Fetch_Decode : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL Rs1, Rd, Rs2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL Rs1_output_Mux, Rs2_output_Mux : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL rs1_rd_controll, rs2_rd_controll : STD_LOGIC;
  SIGNAL Ra1_value_RegisterFile, Ra2_value_RegisterFile : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL ra2_sel_controll : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL Ra2_value_enter_Decode_Execute : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL Enable_Decode_Execute, Enable_Execute_Memory, Enable_Mem_Wb : STD_LOGIC;
  SIGNAL RA_out_Decode_Execute, RA1_Decode_Execute, RA2_Decode_Execute : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL alu_control_out_Decode_Execute : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL RD_Out_Decode_Execute, RS1_out_Decode_Execute, RS2_out_Decode_Execute : STD_LOGIC_VECTOR(2 DOWNTO 0);
  -- SIGNAL controller_alu_operation:STD_LOGIC_VECTOR (3 DOWNTO 0);
  SIGNAL interrupt_signal_controller_out : STD_LOGIC;
  SIGNAL Alu_output_data : STD_LOGIC_VECTOR(31 DOWNTO 0);

  SIGNAL Cary_flag, Z_flag, Neg_flag, OF_flag, Free_P_Enable_DEC_EX : STD_LOGIC;
  SIGNAL MEM_READ_IN_Decode_Execute, MEM_WRITE_IN_Decode_Execute, WRITE_BACK_IN_Decode_Execute : STD_LOGIC;
  SIGNAL MEM_READ_out_Decode_Execute, MEM_WRITE_out_Decode_Execute, WRITE_BACK_out_Decode_Execute : STD_LOGIC;
  SIGNAL MEM_READ_out_Execute_Mem, MEM_WRITE_out_Execute_Mem, WRITE_BACK_out_Execute_Mem : STD_LOGIC;
  SIGNAL Rd_out_Execute_Mem : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL Ra_Out_Execute_Mem, AluOut_Out_Execute_Mem : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL WRB_S_Out_Execute_Mem : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL Ra2_out_mem_wb, Mem_data_out_mem_wbt, Alu_data_out_mem_wb : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL Rd_address_out_mem_wb : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL WBS_out_mem_wb : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL WB_EN_out_mem_wb, enableControll : STD_LOGIC;
  -- controll signals
  SIGNAL Free_P_Enable_con, Mem_protect_enable_con, Mem_free_enable_con, Free_P_Enable_EX_MEM : STD_LOGIC;
  SIGNAL alu_controll_signal : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL WRB_S_con, WRB_S_Decode_Execute : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL Data_write_back_out_muxWB : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL InPortData_MUX_WB, RA2_DATA_WB_OUT_DATA : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL Signal_br_control : STD_LOGIC_VECTOR(1 DOWNTO 0);
  -- Forward Unit
  SIGNAL RA1_TO_ALU, RA2_TO_ALU : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL SEL1_FU, SEL2_FU : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL DATA_OUT_MUX_IMM_RA_PC, pc_value_corrected : STD_LOGIC_VECTOR(31 DOWNTO 0);

  -- Branch_prediction
  SIGNAL predicted, flush_f : STD_LOGIC;
  SIGNAL resetD, resetF : STD_LOGIC;
  SIGNAL Signal_br_control_DE, Signal_br_control_MEM : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL MEM_DATA_OUT, PUSH_DATA, OUT_PORT, input_data_port_ex_mem, input_data_port : STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL DATA_OUT_SP_MUX_TO_MEM : unsigned(11 DOWNTO 0);
  SIGNAL STACK_CON_ENABLE, STACK_DEC_EX, STACK_EX_MEM, STACK_EX_MEM_OUT : STD_LOGIC;
  SIGNAL FREE_SIGNAL_DEC_EX_OUT, PROTECT_SIGNAL_DEC_EX_OUT, PUSH_SIGNAL_DEC_EX_OUT : STD_LOGIC;
  SIGNAL Push_signal_EX_MEM_OUT, Protect_signal_EX_MEM_OUT, Free_signal_EX_MEM_OUT, signal_push_controller : STD_LOGIC;
  SIGNAL stack_value : unsigned(31 DOWNTO 0);
  SIGNAL EA_UNSIGNED, EA_UNSIGNED_RA : unsigned(11 DOWNTO 0);
  SIGNAL SIGNAL_MUX_ALU_TO_MEM : STD_LOGIC;
  SIGNAL Address_In_EX_MEM : unsigned(11 DOWNTO 0);
  SIGNAL stallHazard, notStallHazard, enableFetch, out_enable, out_enable_dec_ex, In_enable_dec_ex : STD_LOGIC;
  SIGNAL In_Enable, controll_mem_data : STD_LOGIC;
  SIGNAL DATA_IN_PORT : STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000000000001110";
  SIGNAL flushF, flushMEM, flushD, flush_MEM : STD_LOGIC;
  SIGNAL predicted_out, controll_mem_data_DEC_EX : STD_LOGIC;
  SIGNAL PC_DATA_MEM_BR_CON, RA_out_mem_ex_mem : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN

  Rs1 <= Instruction_from_Fetch_Decode(6 DOWNTO 4);
  Rs2 <= Instruction_from_Fetch_Decode(3 DOWNTO 1);
  Rd <= Instruction_from_Fetch_Decode(9 DOWNTO 7);
  flushF <= flush_f AND reset AND flush_MEM;
  flushD <= flush_f AND reset AND flush_MEM;
  flushMEM <= reset AND flush_MEM;
  -- notStallHazard <= NOT stallHazard;
  -- Enable_Decode_Execute <= NOT stallHazard;
  -- enableFetch <= NOT stallHazard;
  -- controller_pc_Enable <= NOT stallHazard;
  PC1 : PCregister
  PORT MAP(
    clk => clk, reset => reset, Interrupt => interrupt_signal_controller_out,
    writeEnable => stallHazard,
    ResetValue => unsigned(Reset_Pc_Value), InterruptValue => unsigned(Interrupt_PC_Value),
    PCValue => unsigned(PC_MUX_OUT(11 DOWNTO 0)),
    PCout => (PC_VALUE_OUT)
  );

  PC_MUX : PCmux
  PORT MAP(
    PCnext => PC_INSTRUCTION_INCREMNTED,
    PC_BR_Ra => RA1_TO_ALU, PC_Ret => PC_Ret_value, -------------aloooo
    PC_value => pc_value_corrected,
    PC_DATA_MEM_BR_COND => PC_DATA_MEM_BR_CON,
    SIGNAL_COND => Signal_br_control_MEM,
    flushEX => flush_f,
    flushMem => flush_MEM,
    predicted => '1', --------   to be edited
    ZF => '0',
    PC => PC_MUX_OUT
  );
  pcvalueUnit : PCValuecontrolbox PORT MAP(
    PC_nextInstruc => PC_MUX_OUT,
    signal_cond => Signal_br_control,
    PCValue => pc_value_corrected
  );

  InstructionMemory1 : InstructionMemory
  PORT MAP(
    clk => clk, reset => reset,
    address => PC_VALUE_OUT_STD_LOGIC, data => Instruction_from_memory);

  FetchDecodeReg1 : FetchDecodeReg
  PORT MAP(
    clk => clk, reset => flushF, enable => stallHazard, ---- THERE NO ENABLE 
    Interrupt => interrupt_signal_controller_out, IntermediateEnable => Intermediate_Enable_controller,
    pc => PC_MUX_OUT, instructionIn => Instruction_from_memory, ------------- CHECK PC VALUE 
    instructionOut => Instruction_from_Fetch_Decode,
    PC_data => PC_value_from_Fetch_Decode
  );

  muxRS1 : mux_rs1 PORT MAP(rs1 => Rs1, rd => Rd, ra1 => Rs1_output_Mux, rs1_rd => rs1_rd_controll);

  muxRS2 : mux_rs2 PORT MAP(rs2 => Rs2, rd => Rd, ra2 => Rs2_output_Mux, rs2_rd => rs2_rd_controll);

  mux_regFile_ra2 : mux_regFile_out
  PORT MAP(
    ra2 => Ra2_value_enter_Decode_Execute,
    IMM => IMM_CONCATENATED, ------------------------------------------------------------CHECK
    Pc => PC_value_from_Fetch_Decode,
    ra2_out => DATA_OUT_MUX_IMM_RA_PC,
    ra2_Sel => ra2_sel_controll);

  Registerfilecomp1 : register_file
  PORT MAP(
    clk => clk, reset => reset,
    data_write => Data_write_back_out_muxWB,
    read_address1 => Rs1_output_Mux,
    read_address2 => Rs2_output_Mux,
    write_enable => WB_EN_out_mem_wb,
    write_address => Rd_address_out_mem_wb,
    data_out1 => Ra1_value_RegisterFile,
    data_out2 => Ra2_value_enter_Decode_Execute
  );

  HazardUnit : hazarddectionunit PORT MAP(
    oldRD => Rd_out_Execute_Mem,
    currentRS1 => Rs1_output_Mux,
    currentRS2 => Rs2_output_Mux,
    MEMRead => MEM_READ_out_Execute_Mem,
    WriteBack => WRITE_BACK_out_Execute_Mem,
    stall => stallHazard
  );

  DecodeExecute : Decode_Execute
  PORT MAP(
    clk => clk, reset => flushD, enable => stallHazard,
    dataIn1 => Ra1_value_RegisterFile,
    dataIn2 => DATA_OUT_MUX_IMM_RA_PC,
    alu_control_in => alu_controll_signal,
    RA_In => Ra2_value_enter_Decode_Execute,
    RD_In => Rd,
    Rs1_In => Rs1_output_Mux,
    RS2_In => Rs2_output_Mux,
    MEM_READ_In => MEM_READ_IN_Decode_Execute,
    MEM_WRITE_In => MEM_WRITE_IN_Decode_Execute,
    WRITE_BACK_In => WRITE_BACK_IN_Decode_Execute,
    WRB_S_In => WRB_S_con,
    Signal_br_control_In => Signal_br_control,
    Push_signal_DEC_EX_IN => signal_push_controller,
    Protect_signal_DEC_EX_IN => Mem_protect_enable_con,
    Free_signal_DEC_EX_IN => Mem_free_enable_con,
    STACK_DEC_EX_IN => STACK_CON_ENABLE,
    Free_P_Enable_IN => Free_P_Enable_con,
    out_enable_IN => out_enable,
    In_enable_IN => IN_enable,
    controll_mem_data_In => controll_mem_data,
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
    WRB_S_Out => WRB_S_Decode_Execute,
    Signal_br_control_Out => Signal_br_control_DE,
    Push_signal_DEC_EX_OUT => PUSH_SIGNAL_DEC_EX_OUT,
    Protect_signal_DEC_EX_OUT => PROTECT_SIGNAL_DEC_EX_OUT,
    Free_signal_DEC_EX_OUT => FREE_SIGNAL_DEC_EX_OUT,
    STACK_DEC_EX_OUT => STACK_DEC_EX,
    Free_P_Enable_OUT => Free_P_Enable_DEC_EX,
    out_enable_out => out_enable_dec_ex,
    In_enable_out => In_enable_dec_ex,
    controll_mem_data_OUT => controll_mem_data_DEC_EX
  );

  alucomp1 : ALU
  PORT MAP(
    input1 => RA1_TO_ALU,
    input2 => RA2_TO_ALU,
    sel => alu_control_out_Decode_Execute,
    outpt => Alu_output_data,
    Carry_flag => Cary_flag,
    Zero_flag => Z_flag,
    Negative_flag => Neg_flag,
    Overflow_flag => OF_flag
  );
  muxsourcealu1 : mux_source_alu1 PORT MAP(
    RA => RA1_Decode_Execute,
    SRC_DATA_EXE => AluOut_Out_Execute_Mem,
    SRC_DATA_MEM => Data_write_back_out_muxWB, ---Alu_data_out_mem_wb
    DATA_OUT_TO_ALU => RA1_TO_ALU,
    ForwardUnit_sel => SEL1_FU
  );

  muxsource_alu2 : mux_source_alu1 PORT MAP(
    RA => RA2_Decode_Execute,
    SRC_DATA_EXE => AluOut_Out_Execute_Mem,
    SRC_DATA_MEM => Alu_data_out_mem_wb, ---Alu_data_out_mem_wb
    DATA_OUT_TO_ALU => RA2_TO_ALU,
    ForwardUnit_sel => SEL2_FU
  );
  Forwardunit1 : ForwardUnit PORT MAP(
    RS1_address => RS1_out_Decode_Execute,
    RS2_address => RS2_out_Decode_Execute,
    Rd_address_EM_reg => Rd_out_Execute_Mem,
    WRB_EN_EM_reg => WRITE_BACK_out_Execute_Mem,
    Rd_address_MW_reg => Rd_address_out_mem_wb,
    WRB_EN_MW_reg => WB_EN_out_mem_wb,
    Alu_src2_sel => SEL2_FU,
    Alu_src1_sel => SEL1_FU
  );

  outputPort : Output PORT MAP(
    enable => out_enable_dec_ex,
    reset => reset,
    datain => RA1_TO_ALU,
    dataout => OUT_PORT
  );
  InputPort : input PORT MAP(
    enable => In_enable_dec_ex,
    reset => reset,
    datain => DATA_IN_PORT,
    dataout => input_data_port
  );

  muxRA2 : mux_ra2_data_mem PORT MAP(
    ra2_forwarderd => RA_out_Decode_Execute,
    ra2_alu => RA2_Decode_Execute,
    ra2_out => RA_out_mem_ex_mem,
    sel => controll_mem_data_DEC_EX
  );

  --------- NEED TO ADD MUXES OF FREE/PROTECTED ENABLES AND FORWARD UNITS 
  ExecuteMememoryRegister : Execute_Mememory_Register
  PORT MAP(
    clk => clk, reset => flushMEM, enable => Enable_Execute_Memory,
    MEM_READ_In => MEM_READ_out_Decode_Execute,
    MEM_WRITE_In => MEM_WRITE_out_Decode_Execute,
    WRITE_BACK_In => WRITE_BACK_out_Decode_Execute,
    WRB_S_In => WRB_S_Decode_Execute,
    Rd_address_In => RD_Out_Decode_Execute,
    Ra_In => RA_out_mem_ex_mem,
    AluOut_In => Alu_output_data,
    RA2_DATA_WB_IN => RA2_Decode_Execute,
    Push_signal_EX_MEM_IN => PUSH_SIGNAL_DEC_EX_OUT,
    Protect_signal_EX_MEM_IN => PROTECT_SIGNAL_DEC_EX_OUT,
    Free_signal_EX_MEM_IN => FREE_SIGNAL_DEC_EX_OUT,
    STACK_EX_MEM_IN => STACK_DEC_EX,
    Free_P_Enable_IN => Free_P_Enable_DEC_EX,
    In_port_data_In => input_data_port,
    Signal_br_control_IN => Signal_br_control_DE,
    RA_1_IN => RA1_TO_ALU,
    MEM_READ_Out => MEM_READ_out_Execute_Mem,
    MEM_WRITE_Out => MEM_WRITE_out_Execute_Mem,
    WRITE_BACK_Out => WRITE_BACK_out_Execute_Mem,
    WRB_S_Out => WRB_S_Out_Execute_Mem,
    Rd_address_Out => Rd_out_Execute_Mem,
    Ra_Out => Ra_Out_Execute_Mem,
    AluOut_Out => AluOut_Out_Execute_Mem,
    RA2_DATA_WB_OUT => RA2_DATA_WB_OUT_DATA,
    Push_signal_EX_MEM_OUT => Push_signal_EX_MEM_OUT,
    Protect_signal_EX_MEM_OUT => Protect_signal_EX_MEM_OUT,
    Free_signal_EX_MEM_OUT => Free_signal_EX_MEM_OUT,
    STACK_EX_MEM_OUT => STACK_EX_MEM_OUT,
    Free_P_Enable_OUT => Free_P_Enable_EX_MEM,
    In_port_data_OUT => input_data_port_ex_mem,
    Signal_br_control_OUT => Signal_br_control_MEM,
    RA_1_OUT => PC_DATA_MEM_BR_CON
  );

  MUXDATA : mux_data_address PORT MAP(
    alu_data => EA_UNSIGNED,
    ra => EA_UNSIGNED_RA,
    address_out => Address_In_EX_MEM,
    sel => Free_P_Enable_EX_MEM
  );

  DataMemory : Memory PORT MAP(
    clk => clk, reset => reset,
    address => STD_LOGIC_VECTOR(DATA_OUT_SP_MUX_TO_MEM),
    data_in => Ra_Out_Execute_Mem,
    MEM_READ => MEM_READ_out_Execute_Mem,
    MEM_WRITE => MEM_WRITE_out_Execute_Mem,
    Protect => Protect_signal_EX_MEM_OUT,
    Free => Free_signal_EX_MEM_OUT,
    Push_PC => Push_signal_EX_MEM_OUT,
    alu_src => PUSH_DATA,
    data_out => MEM_DATA_OUT,
    PC_RST => Reset_Pc_Value_32,
    PC_Interrupt => Interrupt_PC_Value_32
  );

  SP_MUX : sp_addressmux PORT MAP(
    push_enable => Push_signal_EX_MEM_OUT,
    sp_enable => STACK_EX_MEM_OUT,
    stack_pointer => stack_value,
    EA => Address_In_EX_MEM,
    data_out => DATA_OUT_SP_MUX_TO_MEM
  );

  stackPoint : stackpointer PORT MAP(
    clk => clk,
    reset => reset,
    push_pop => Push_signal_EX_MEM_OUT,
    enable => STACK_EX_MEM_OUT,
    stackpointer => stack_value
  );
  MemWBregister : Mem_WB_reg
  PORT MAP(
    clk => clk, reset => reset, enable => Enable_Mem_Wb,
    Ra2_in => RA2_DATA_WB_OUT_DATA,
    Mem_data_in => MEM_DATA_OUT, ----------------------------------------------------------- TO BE EDITED WITH MEMERY ACUTALLY DATA 
    Alu_data_in => AluOut_Out_Execute_Mem,
    Rd_address_in => Rd_out_Execute_Mem,
    WBS_in => WRB_S_Out_Execute_Mem,
    WB_EN_in => WRITE_BACK_out_Execute_Mem,
    In_port_data_In => input_data_port_ex_mem,
    Ra2_out => Ra2_out_mem_wb,
    Mem_data_out => Mem_data_out_mem_wbt,
    Alu_data_out => Alu_data_out_mem_wb,
    Rd_address_out => Rd_address_out_mem_wb,
    WBS_out => WBS_out_mem_wb,
    WB_EN_out => WB_EN_out_mem_wb,
    In_port_data_OUT => InPortData_MUX_WB
  );

  ----------------------------- Controller
  Controller1 : Controller
  PORT MAP(
    enable => enableControll, oppCode => Instruction_from_Fetch_Decode(15 DOWNTO 13),
    Func => Instruction_from_Fetch_Decode(12 DOWNTO 10),
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
    Interrupt_Signal => interrupt_signal_controller_out,
    STALL_FETCH_IMM => Intermediate_Enable_controller,
    Signal_br => Signal_br_control,
    push_signal => signal_push_controller,
    STACK_SIGNAL => STACK_CON_ENABLE,
    SIGNAL_MUX_ALU_TO_MEM => SIGNAL_MUX_ALU_TO_MEM,
    out_enable => out_enable,
    IN_enable => In_Enable,
    control_data_mem => controll_mem_data
  );

  ExeceptionBranch1 : ExeceptionBranch
  PORT MAP(
    clk => clk,
    signal_br => Signal_br_control_DE,
    bit_predict => '1',
    Flush_F => flush_f
  );

  MemBranch : MemoryBranch PORT MAP(
    clk => clk,
    signal_br => Signal_br_control_MEM,
    bit_predict => '1',
    ZF => '0',
    Flush_MEM => flush_MEM,
    predicted_out => predicted_out
  );

  ------------------------------ MUX WRITE BACK ----------------------------------------
  muxWB : mux_WB
  PORT MAP(
    InPortData => InPortData_MUX_WB,
    Mem_data => Mem_data_out_mem_wbt,
    Alu_Data => Alu_data_out_mem_wb,
    RA2 => Ra2_out_mem_wb,
    DataWriteBack => Data_write_back_out_muxWB,
    WBW_s => WBS_out_mem_wb
  );

  PC_VALUE_SELECTED_STD_LOGIC <= STD_LOGIC_VECTOR(PC_value_selected);
  EA_UNSIGNED <= unsigned(STD_LOGIC_VECTOR(AluOut_Out_Execute_Mem(11 DOWNTO 0)));
  EA_UNSIGNED_RA <= unsigned(STD_LOGIC_VECTOR(RA2_DATA_WB_OUT_DATA(11 DOWNTO 0)));
  PC_VALUE_OUT_STD_LOGIC <= STD_LOGIC_VECTOR(PC_VALUE_OUT);
  PC_VALUE_CONCATENATED <= x"00000" & PC_VALUE_OUT_STD_LOGIC;-- TO BE 32 
  Reset_Pc_Value_32 <= x"00000" & Reset_Pc_Value;
  Interrupt_PC_Value_32 <= x"00000" & Interrupt_PC_Value;
  IMM_CONCATENATED <= x"0000" & Instruction_from_memory;
  PC_VALUE_SELECTED_CONCATENATED <= x"00000" & PC_VALUE_SELECTED_STD_LOGIC;
  PC_INSTRUCTION_INCREMNTED <= STD_LOGIC_VECTOR(unsigned(PC_VALUE_CONCATENATED) + 1);
END ARCHITECTURE;