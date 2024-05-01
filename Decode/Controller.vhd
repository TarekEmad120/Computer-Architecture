
library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.numeric_std.all;

entity Controller is

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
    Interrupt_Signal                    : out  STD_LOGIC;
    STALL_FETCH_IMM                     : out  STD_LOGIC;
    Signal_br                           : out STD_LOGIC_VECTOR (1 DOWNTO 0)   --- SIGNAL BRANCHING
  );

end entity;

architecture IMP of Controller is

begin
  PROCESS (oppCode, Func,one_two_attrib) IS
  BEGIN
  case oppCode is
    when "001" =>
      aluControl    <= Func & one_two_attrib;
      WRB_S         <= "10";
      Free_P_Enable <= '0';
      RA2_SEL       <= "00";
      RS2_RD_SEL    <= '0';
      MEM_READ      <= '0';
      MEM_WRITE     <= '0';
      Mem_protect_enable <= '0';
      Mem_free_enable    <= '0';
      STALL_FETCH_IMM    <= '0';
      Signal_br          <= "00";
      case one_two_attrib is 
        when  '0' =>
          RS1_RD_SEL <= '1';
        when others => RS1_RD_SEL <= '0';
      end case;
      case Func IS
	    when "110" =>
       	WRITE_BACK    <= '0';
      when others => WRITE_BACK    <= '1';
      end case;
    when "100" => 
      case Func is
        when "011" =>
        aluControl   <= (others =>'0');
        WRB_S        <= "11";
        RA2_SEL      <= "01";
        MEM_READ      <= '0';
        MEM_WRITE     <= '0';
        Mem_protect_enable <= '0';
        Mem_free_enable    <= '0';
        RS1_RD_SEL         <= '0';
        RS2_RD_SEL         <= '0';
        WRITE_BACK         <= '1';
        Free_P_Enable      <= '0';
        STALL_FETCH_IMM    <= '1';
        Signal_br          <= "00";
        when others=>
        end case;
    when "000" =>
        STALL_FETCH_IMM    <= '0';
        Mem_protect_enable <= '0';
        Mem_free_enable    <= '0';
        RS1_RD_SEL         <= '0';
        RS2_RD_SEL         <= '0';
        WRITE_BACK         <= '0';
        Free_P_Enable      <= '0';
        WRB_S              <= "00";
        RA2_SEL            <= "00";
        Signal_br          <= "00";
    when "010" =>            --- ADDI , SUBI
        Mem_protect_enable <= '0';
        Mem_free_enable    <= '0';
        STALL_FETCH_IMM    <= '1';
        Free_P_Enable      <= '0';
        MEM_READ           <= '0';
        MEM_WRITE          <= '0';
        RS1_RD_SEL         <= '0';
        RS2_RD_SEL         <= 'X';
        WRITE_BACK         <= '1';
        WRB_S              <= "10";
        RA2_SEL            <= "01";
        Signal_br          <= "00";
        case Func is
          when "001" =>
           aluControl   <= "0111";
          when "010"=>
          aluControl   <= "0101";
          when others =>
          end case;
    when "110" =>
          case Func is
            when "010" =>
              Signal_br          <= "01";
            when "011" =>
              Signal_br          <= "10";
          when others =>
          end case;
          RS1_RD_SEL         <= '1';
          Mem_protect_enable <= '0';
          Mem_free_enable    <= '0';
          STALL_FETCH_IMM    <= '0';
          Free_P_Enable      <= '0';
          MEM_READ           <= '0';
          MEM_WRITE          <= '0';
          RS2_RD_SEL         <= 'X';
          WRB_S              <= "XX";
          RA2_SEL            <= "XX";
        
    when others=>
  end case;




  end process;


end architecture;
