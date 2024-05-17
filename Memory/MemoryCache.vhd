LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;
ENTITY Memory IS
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
END Memory;

ARCHITECTURE Behavioral OF Memory IS
  TYPE memory IS ARRAY (0 TO 4095) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL mem : memory;
  TYPE ProtecedMemory IS ARRAY (0 TO 4095) OF STD_LOGIC;
  SIGNAL ProtectedMem : ProtecedMemory;
  SIGNAL read_flag : STD_LOGIC := '1';
BEGIN
  PROCESS (clk, reset)
    -- reading from cahce file 
    FILE file_in : text OPEN read_mode IS "D:\ss\Computer-Architecture\cache.txt";
    VARIABLE line : line;
    VARIABLE data : STD_LOGIC_VECTOR(15 DOWNTO 0);

  BEGIN

    IF (reset = '1') THEN
      FOR i IN 0 TO 4095 LOOP
        mem(i) <= (OTHERS => '0');
        ProtectedMem(i) <= '0';
      END LOOP;
      PC_RST <= (OTHERS => '0');
      PC_Interrupt <= (OTHERS => '0');
      DATA_OUT <= (OTHERS => '0');
      read_flag <= '1';
    END IF;
    -- reading from cache file once 
    IF (read_flag = '1') THEN
      FOR i IN 0 TO 4095 LOOP
        IF NOT endfile(file_in) THEN
          readline(file_in, line);
          read(line, data);
          mem(i) <= data;
        ELSE
          EXIT; -- Exit the loop if there are no more lines to read
        END IF;
      END LOOP;
      read_flag <= '0';
    END IF;

    IF falling_edge(clk) THEN
      IF Mem_Write = '1' AND protectedMem(to_integer(unsigned(address))) = '0' THEN

        -- we will use big endian
        IF push_PC = '1' THEN
          mem(to_integer(unsigned(address))) <= alu_src(31 DOWNTO 16);
          mem(to_integer(unsigned(address)) + 1) <= alu_src(15 DOWNTO 0);
        ELSE
          mem(to_integer(unsigned(address))) <= data_in(31 DOWNTO 16);
          mem(to_integer(unsigned(address)) + 1) <= data_in(15 DOWNTO 0);
        END IF;
      END IF;
      IF protect = '1' THEN
        ProtectedMem(to_integer(unsigned(address))) <= '1';
      END IF;
      IF free = '1' THEN
        ProtectedMem(to_integer(unsigned(address))) <= '0';
      END IF;

    END IF;
    -- using big endian
    IF (MEM_READ = '1') THEN
      data_out <= mem(to_integer(unsigned(address))) & mem(to_integer(unsigned(address)) + 1);
    END IF;
    PC_RST <= mem(0) & mem(1);
    PC_Interrupt <= mem(2) & mem(3);
  END PROCESS;
END Behavioral;