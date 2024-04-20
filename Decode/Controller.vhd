
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
    Interrupt_Signal                    : out  STD_LOGIC
  );

end entity;

architecture IMP of Controller is

begin
  PROCESS (oppCode) IS
  BEGIN
  case oppCode is
    when "001" =>
      aluControl    <= Func & one_two_attrib;
      WRB_S         <= "10";
      WRITE_BACK    <= '1';
      Free_P_Enable <= '0';
      RA2_SEL       <= "00";
      RS2_RD_SEL    <= '0';
      MEM_READ      <= '0';
      MEM_WRITE     <= '0';
      Mem_protect_enable <= '0';
      Mem_free_enable    <= '0';
      case one_two_attrib is 
        when  '0' =>
          RS1_RD_SEL <= '1';
        when others => RS1_RD_SEL <= '0';
      end case;
      when others=>
  end case;

  if (oppCode = "100" and Func = "011") then
    Interrupt_Signal <= '1';
  else
    Interrupt_Signal <= '0';
  end if;


  end process;




--   aluControl    <= Func & one_two_attrib when oppCode = "001";
--   WRB_S         <= "10" when oppCode = "001"; -- select ALU Data to write Back
--   WRITE_BACK    <= '1' when oppCode = "001";
--   Free_P_Enable <= '0' when oppCode = "001";

--   -- to be edited --
-- RA2_SEL <= "00" when oppCode = "001" else
--     "01";

--   -- to be edited --
--   RS2_RD_SEL <= '0' when oppCode = "001";
--   RS1_RD_SEL <= '1' when one_two_attrib = '0' else
--                  '0';

--   MEM_READ           <= '0' when oppCode = "001";
--   MEM_WRITE          <= '0' when oppCode = "001";
--   Mem_protect_enable <= '0' when oppCode = "001";
--   Mem_free_enable    <= '0' when oppCode = "001";
--   -- LDM OPERATION 
--   WRITE_BACK         <= '1' when oppCode = "100" and Func = "011";
--   WRB_S              <= "11" when oppCode = "100" and Func = "011";
--   MEM_READ           <= '0' when oppCode = "100" and Func = "011";
--   MEM_WRITE          <= '0' when oppCode = "100" and Func = "011";
--   Mem_protect_enable <= '0' when oppCode = "100" and Func = "011";
--   Mem_free_enable    <= '0' when oppCode = "100" and Func = "011";

end architecture;
