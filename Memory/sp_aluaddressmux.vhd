LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

ENTITY sp_addressmux IS
  PORT (
    push_enable : IN STD_LOGIC;
    sp_enable : IN STD_LOGIC;
    stack_pointer : IN unsigned(31 DOWNTO 0);
    EA : IN unsigned(11 DOWNTO 0);

    data_out : OUT unsigned(11 DOWNTO 0)
  );
END ENTITY;
ARCHITECTURE memoryaddressmux OF sp_addressmux IS
  SIGNAL sp_minus_1 : unsigned(31 DOWNTO 0);
  SIGNAL sp_plus_1 : unsigned(31 DOWNTO 0);

BEGIN
  sp_minus_1 <= stack_pointer - 1;
  sp_plus_1 <= stack_pointer + 1;

  data_out <= sp_minus_1(11 DOWNTO 0) WHEN push_enable = '0' AND sp_enable = '1' ELSE
    sp_plus_1(11 DOWNTO 0) WHEN push_enable = '1' AND sp_enable = '1' ELSE
    EA;

END ARCHITECTURE;