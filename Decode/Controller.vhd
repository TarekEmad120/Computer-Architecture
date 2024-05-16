
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Controller IS

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
    In_Enable : OUT STD_LOGIC
  );

END ENTITY;

ARCHITECTURE IMP OF Controller IS

BEGIN
  PROCESS (oppCode, Func, one_two_attrib) IS
  BEGIN
    CASE oppCode IS
      WHEN "001" =>
        aluControl <= Func & one_two_attrib;
        WRB_S <= "10";
        Free_P_Enable <= '0';
        RA2_SEL <= "00";
        RS2_RD_SEL <= '0';
        MEM_READ <= '0';
        MEM_WRITE <= '0';
        Mem_protect_enable <= '0';
        Mem_free_enable <= '0';
        STALL_FETCH_IMM <= '0';
        Signal_br <= "00";
        SIGNAL_MUX_ALU_TO_MEM <= '0';
        push_signal <= '0';
        STACK_SIGNAL <= '0';
        out_enable <= '0';
        In_Enable <= '0';
        CASE one_two_attrib IS
          WHEN '0' =>
            RS1_RD_SEL <= '1';
          WHEN OTHERS => RS1_RD_SEL <= '0';
        END CASE;
        CASE Func IS
          WHEN "110" =>
            WRITE_BACK <= '0';
          WHEN OTHERS => WRITE_BACK <= '1';
        END CASE;
      WHEN "100" =>
        CASE Func IS
          WHEN "011" => --- LDI operation
            aluControl <= (OTHERS => '0');
            WRB_S <= "11";
            RA2_SEL <= "01";
            MEM_READ <= '0';
            MEM_WRITE <= '0';
            Mem_protect_enable <= '0';
            Mem_free_enable <= '0';
            RS1_RD_SEL <= '0';
            RS2_RD_SEL <= '0';
            WRITE_BACK <= '1';
            Free_P_Enable <= '0';
            STALL_FETCH_IMM <= '1';
            Signal_br <= "00";
            SIGNAL_MUX_ALU_TO_MEM <= '0';
            push_signal <= '0';
            STACK_SIGNAL <= '0';
            out_enable <= '0';
            In_Enable <= '0';
          WHEN "100" => --- LDM operation
            aluControl <= "0101";
            WRB_S <= "01";
            MEM_READ <= '1';
            MEM_WRITE <= '0';
            Mem_protect_enable <= '0';
            Mem_free_enable <= '0';
            RA2_SEL <= "01";
            RS1_RD_SEL <= '0';
            RS2_RD_SEL <= '0';
            WRITE_BACK <= '1';
            Free_P_Enable <= '0';
            STALL_FETCH_IMM <= '1';
            Signal_br <= "00";
            STACK_SIGNAL <= '0';
            SIGNAL_MUX_ALU_TO_MEM <= '0';
            out_enable <= '0';
            In_Enable <= '0';
          WHEN "001" => ---- PUSH operation
            aluControl <= (OTHERS => '0');
            MEM_READ <= '0';
            MEM_WRITE <= '1';
            push_signal <= '0';
            STACK_SIGNAL <= '1';
            Mem_protect_enable <= '0';
            Mem_free_enable <= '0';
            WRITE_BACK <= '0';
            WRB_S <= "00";
            RA2_SEL <= "00";
            STALL_FETCH_IMM <= '0';
            Signal_br <= "00";
            RS1_RD_SEL <= '0';
            RS2_RD_SEL <= '1';
            SIGNAL_MUX_ALU_TO_MEM <= '0';
            Free_P_Enable <= '0';
            out_enable <= '0';
            In_Enable <= '0';
          WHEN "010" => ---- POP operation
            aluControl <= (OTHERS => '0');
            MEM_READ <= '1';
            MEM_WRITE <= '0';
            push_signal <= '1';
            STACK_SIGNAL <= '1';
            Mem_protect_enable <= '0';
            Mem_free_enable <= '0';
            WRB_S <= "01";
            RA2_SEL <= "00";
            RS1_RD_SEL <= '0';
            RS2_RD_SEL <= '1';
            Signal_br <= "00";
            STALL_FETCH_IMM <= '0';
            SIGNAL_MUX_ALU_TO_MEM <= '0';
            WRITE_BACK <= '1';
            Free_P_Enable <= '0';
            out_enable <= '0';
            In_Enable <= '0';
          WHEN "101" => --- STD operation
            MEM_READ <= '0';
            MEM_WRITE <= '1';
            push_signal <= '0';
            STACK_SIGNAL <= '0';
            Mem_protect_enable <= '0';
            Mem_free_enable <= '0';
            WRB_S <= "00";
            RA2_SEL <= "01";
            RS1_RD_SEL <= '0';
            RS2_RD_SEL <= '1';
            aluControl <= "0101";
            WRITE_BACK <= '0';
            Free_P_Enable <= '0';
            Signal_br <= "00";
            STALL_FETCH_IMM <= '0';
            out_enable <= '0';
            SIGNAL_MUX_ALU_TO_MEM <= '0';
            In_Enable <= '0';
          WHEN OTHERS =>
        END CASE;
      WHEN "000" =>
        STALL_FETCH_IMM <= '0';
        Mem_protect_enable <= '0';
        Mem_free_enable <= '0';
        MEM_READ <= '0';
        MEM_WRITE <= '0';
        RS1_RD_SEL <= '0';
        RS2_RD_SEL <= '0';
        WRITE_BACK <= '0';
        Free_P_Enable <= '0';
        WRB_S <= "00";
        RA2_SEL <= "00";
        Signal_br <= "00";
        SIGNAL_MUX_ALU_TO_MEM <= '0';
        push_signal <= '0';
        STACK_SIGNAL <= '0';
        out_enable <= '0';
        In_Enable <= '0';
      WHEN "010" => --- ADDI , SUBI
        Mem_protect_enable <= '0';
        Mem_free_enable <= '0';
        STALL_FETCH_IMM <= '1';
        Free_P_Enable <= '0';
        MEM_READ <= '0';
        MEM_WRITE <= '0';
        RS1_RD_SEL <= '0';
        RS2_RD_SEL <= 'X';
        WRITE_BACK <= '1';
        WRB_S <= "10";
        RA2_SEL <= "01";
        Signal_br <= "00";
        SIGNAL_MUX_ALU_TO_MEM <= '0';
        push_signal <= '0';
        STACK_SIGNAL <= '0';
        out_enable <= '0';
        In_Enable <= '0';
        CASE Func IS
          WHEN "001" =>
            aluControl <= "0111";
          WHEN "010" =>
            aluControl <= "0101";
          WHEN OTHERS =>
        END CASE;
      WHEN "110" =>
        CASE Func IS
          WHEN "010" =>
            Signal_br <= "01";
            RS1_RD_SEL <= '1';
            Mem_protect_enable <= '0';
            Mem_free_enable <= '0';
            STALL_FETCH_IMM <= '0';
            Free_P_Enable <= '0';
            MEM_READ <= '0';
            MEM_WRITE <= '0';
            RS2_RD_SEL <= 'X';
            WRB_S <= "XX";
            RA2_SEL <= "XX";
            SIGNAL_MUX_ALU_TO_MEM <= '0';
            push_signal <= '0';
            STACK_SIGNAL <= '0';
            out_enable <= '0';
            In_Enable <= '0';
          WHEN "011" =>
            Signal_br <= "01";
            RS1_RD_SEL <= '1';
            Mem_protect_enable <= '0';
            Mem_free_enable <= '0';
            STALL_FETCH_IMM <= '0';
            Free_P_Enable <= '0';
            MEM_READ <= '0';
            MEM_WRITE <= '0';
            RS2_RD_SEL <= 'X';
            WRB_S <= "XX";
            RA2_SEL <= "XX";
            SIGNAL_MUX_ALU_TO_MEM <= '0';
            push_signal <= '0';
            STACK_SIGNAL <= '0';
            out_enable <= '0';
            In_Enable <= '0';
          WHEN "001" => ----- JZ ------
            Signal_br <= "10";
            RS1_RD_SEL <= '1';
            Mem_protect_enable <= '0';
            Mem_free_enable <= '0';
            STALL_FETCH_IMM <= '0';
            Free_P_Enable <= '0';
            MEM_READ <= '0';
            MEM_WRITE <= '0';
            RS2_RD_SEL <= 'X';
            WRB_S <= "XX";
            RA2_SEL <= "XX";
            SIGNAL_MUX_ALU_TO_MEM <= '0';
            push_signal <= '0';
            STACK_SIGNAL <= '0';
            out_enable <= '0';
            In_Enable <= '0';
          WHEN OTHERS =>
        END CASE;
      WHEN "101" =>
        CASE Func IS -- protect operation
          WHEN "001" =>
            aluControl <= (OTHERS => '0');
            MEM_READ <= '0';
            MEM_WRITE <= '0';
            push_signal <= '0';
            STACK_SIGNAL <= '0';
            Mem_protect_enable <= '1';
            Mem_free_enable <= '0';
            WRB_S <= "01";
            RA2_SEL <= "00";
            RS1_RD_SEL <= '0';
            RS2_RD_SEL <= '0';
            Signal_br <= "00";
            STALL_FETCH_IMM <= '0';
            SIGNAL_MUX_ALU_TO_MEM <= '0';
            WRITE_BACK <= '0';
            Free_P_Enable <= '1';
            out_enable <= '0';
            In_Enable <= '0';
          WHEN OTHERS =>
        END CASE;
      WHEN "111" =>
        CASE Func IS--interrupt
          WHEN "100" =>
            MEM_READ <= '1';
            MEM_WRITE <= '1';
            push_signal <= '0';
            STACK_SIGNAL <= '1';
            WRB_S <= "01";
            RA2_SEL <= "00";
            RS1_RD_SEL <= '0';
            RS2_RD_SEL <= '0';
            aluControl <= "0000";
            WRITE_BACK <= '1';
            Free_P_Enable <= '0';
            Mem_protect_enable <= '0';
            Mem_free_enable <= '0';
            Signal_br <= "00";
            STALL_FETCH_IMM <= '0';
            SIGNAL_MUX_ALU_TO_MEM <= '0';
            out_enable <= '0';
            In_Enable <= '0';
          WHEN OTHERS =>
        END CASE;
      WHEN "011" =>
        CASE Func IS -- OUT operation
          WHEN "001" =>
            out_enable <= '1';
            MEM_READ <= '0';
            MEM_WRITE <= '0';
            push_signal <= '0';
            STACK_SIGNAL <= '0';
            WRB_S <= "00";
            RA2_SEL <= "00";
            RS1_RD_SEL <= '1';
            RS2_RD_SEL <= '0';
            aluControl <= "0000";
            WRITE_BACK <= '0';
            Free_P_Enable <= '0';
            Mem_protect_enable <= '0';
            Mem_free_enable <= '0';
            Signal_br <= "00";
            STALL_FETCH_IMM <= '0';
            SIGNAL_MUX_ALU_TO_MEM <= '0';
            In_Enable <= '0';
          WHEN "010" =>
            In_Enable <= '1';
            WRB_S <= "00";
            WRITE_BACK <= '1';
            aluControl <= "0000";
            RS1_RD_SEL <= '0';
            RS2_RD_SEL <= '0';
            Free_P_Enable <= '0';
            Mem_protect_enable <= '0';
            Mem_free_enable <= '0';
            Signal_br <= "00";
            STALL_FETCH_IMM <= '0';
            SIGNAL_MUX_ALU_TO_MEM <= '0';
            out_enable <= '0';
            MEM_READ <= '0';
            MEM_WRITE <= '0';
            push_signal <= '0';
            STACK_SIGNAL <= '0';
            RA2_SEL <= "00";
          WHEN OTHERS =>
        END CASE;

      WHEN OTHERS =>
    END CASE;
  END PROCESS;
END ARCHITECTURE;