library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;

entity sp_addressmux is
  port (
    push_enable   : in  std_logic;
    sp_enable     : in  std_logic;
    stack_pointer : in  unsigned(31 downto 0);
    EA            : in  unsigned(11 downto 0);

    data_out      : out unsigned(11 downto 0)
  );
end entity;


architecture memoryaddressmux of sp_addressmux is
    signal sp_minus_1 : unsigned(31 downto 0);
    signal sp_plus_1  : unsigned(31 downto 0);

begin
    sp_minus_1 <= stack_pointer - 1;
    sp_plus_1  <= stack_pointer + 1;

    data_out <= sp_minus_1(11 downto 0)  when push_enable = '0' and sp_enable = '1' else
                sp_plus_1(11 downto 0) when push_enable = '1' and sp_enable = '1' else
                EA;

end architecture;
