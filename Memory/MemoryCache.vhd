library IEEE;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_textio.all;
  use IEEE.STD_LOGIC_UNSIGNED.all;
  use IEEE.numeric_std.all;
  use std.textio.all;


  entity Memory is
    port(
      clk: in std_logic;
      reset: in std_logic;
        address: in std_logic_vector(11 downto 0);
        data_in: in std_logic_vector(31 downto 0);
        MEM_READ: in std_logic;
        MEM_WRITE: in std_logic;
        Protect: in std_logic;
        Free : in std_logic;
        Push_PC : in std_logic;
        alu_src : in std_logic_vector(31 downto 0);
        data_out: out std_logic_vector(31 downto 0);
        PC_RST : out std_logic_vector(31 downto 0);
        PC_Interrupt : out std_logic_vector(31 downto 0)

    );
  end Memory;

  architecture Behavioral of Memory is
  Type memory is array (0 to 4095) of std_logic_vector(15 downto 0);
    signal mem : memory;
  Type ProtecedMemory is array (0 to 4095) of std_logic;
    signal ProtectedMem : ProtecedMemory;
    signal read_flag : std_logic:='1';
    begin
    process(clk, reset)
-- reading from cahce file 
    file file_in : text open read_mode is "F:\Computer Archectiture\project\Computer-Architecture\Computer-Architecture\cache.txt";
    variable line : line;
    variable data : std_logic_vector(15 downto 0);

    begin

    if (reset = '1') then
      for i in 0 to 4095 loop
        mem(i) <= (others => '0');
        ProtectedMem(i) <= '0';
      end loop;
      PC_RST <= (others => '0');
        PC_Interrupt <= (others => '0');
        DATA_OUT <= (others => '0');
        read_flag <= '1';
    end if;
    -- reading from cache file once 
    if (read_flag = '1') then
      for i in 0 to 4095 loop
        readline(file_in, line);
        read(line, data);
        mem(i) <= data;
      end loop;
        read_flag <= '0';

    end if;

    if falling_edge(clk) then
        if Mem_Write ='1' and protectedMem(to_integer(unsigned(address))) = '0' then

            -- we will use big endian
            if push_PC = '1' then
                mem(to_integer(unsigned(address))) <= alu_src(31 downto 16);
                mem(to_integer(unsigned(address))+1) <= alu_src(15 downto 0);
            else
                mem(to_integer(unsigned(address))) <= data_in(31 downto 16);
                mem(to_integer(unsigned(address))+1) <= data_in(15 downto 0);
            end if;
        end if;
        if protect = '1' then
            ProtectedMem(to_integer(unsigned(address))) <= '1';
        end if;
        if free = '1' then
            ProtectedMem(to_integer(unsigned(address))) <= '0';
        end if;

    end if;
    -- using big endian
    if (MEM_READ = '1') then
        data_out <= mem(to_integer(unsigned(address))) & mem(to_integer(unsigned(address))+1);
    end if;
    PC_RST <= mem(0) & mem(1);
    PC_Interrupt <= mem(2) & mem(3);
    end process;
    end Behavioral;