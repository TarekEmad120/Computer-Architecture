LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY register_12bits_tb IS
END register_12bits_tb;

ARCHITECTURE behavior OF register_12bits_tb IS 

    COMPONENT register_12bits
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        data_in1 : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        data_in2 : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        data_out1 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
        data_out2 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
        write_enable : IN STD_LOGIC;
        read_address1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        read_address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_address1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
    END COMPONENT;

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal data_in1 : std_logic_vector(11 downto 0) := (others => '0');
   signal data_in2 : std_logic_vector(11 downto 0) := (others => '0');
   signal write_enable1 : std_logic := '0';
   signal read_address1 : std_logic_vector(2 downto 0) := (others => '0');
   signal read_address2 : std_logic_vector(2 downto 0) := (others => '0');
   signal write_address1 : std_logic_vector(2 downto 0) := (others => '0');
   signal write_address2 : std_logic_vector(2 downto 0) := (others => '0');

    --Outputs
   signal data_out1 : std_logic_vector(11 downto 0);
   signal data_out2 : std_logic_vector(11 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;

BEGIN


    -- Instantiate the Unit Under Test (UUT)
   uut: register_12bits PORT MAP (clk, reset, data_in1, data_in2, data_out1, data_out2, write_enable1, read_address1, read_address2, write_address1, write_address2);

   -- Clock process definitions
   clk_process :process
   begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin

      -- o Reset all registers, set all read addresses to zero.
      -- o Read Reg(0) on port 0, Read Reg(1) on port 1 
      -- o Write 0x0F0 to Reg(0), Write 0xAAA to Reg(3).
      -- o Read Reg(4) on port 0, Read Reg(3) on port 1
      -- o Write 0x123 to Reg(6), Write 0xCCC to Reg(1).
      -- o Read Reg(1) on port 0, Read Reg(6) on port 1 
      -- o Write 0x456 to Reg(4), Donât write on the 2nd port.
      -- o Read Reg(6) on port 0, Read Reg(0) on port 1
      -- o Donât write on the 1st port, Write 0x789 to Reg(1).
      -- o Read Reg(1) on port 0, Read Reg(2) on port 1, Donât write anything.
      -- o Read Reg(3) on port 0, Read Reg(4) on port 1, Donât write anything.

      -- Reset all registers, set all read addresses to zero.
      reset <= '1';
      wait for  clk_period;
      reset <= '0';
      wait for clk_period;


      -- Read Reg(0) on port 0, Read Reg(1) on port 1
      read_address1 <= "000";
      read_address2 <= "001";
    wait for clk_period/2;

      -- Write 0x0F0 to Reg(0), Write 0xAAA to Reg(3).
      data_in1 <= "000011110000";
      data_in2 <= "101010101010";   
      write_enable1 <= '1';
      write_address1 <= "000";
      write_address2 <= "011";
      wait for clk_period;
      write_enable1 <= '0';
      wait for clk_period;
      
    

      -- Read Reg(4) on port 0, Read Reg(3) on port 1
      read_address1 <= "100";
      read_address2 <= "011";
       -- wait for clk_period/2;

      -- Write 0x123 to Reg(6), Write 0xCCC to Reg(1).
      data_in1 <= "000100100011";
      data_in2 <= "110011001100";
      write_enable1 <= '1';
      write_address1 <= "110";
      write_address2 <= "001";
      wait for clk_period;
      write_enable1 <= '0';
        wait for clk_period;
        

      -- Read Reg(1) on port 0, Read Reg(6) on port 1
      read_address1 <= "001";
      read_address2 <= "110";
        --wait for clk_period/2;

      -- Write 0x456 to Reg(4), Donât write on the 2nd port.
      data_in1 <= "010001010110";
      write_enable1 <= '1';
      write_address1 <= "100";
      wait for clk_period;
      write_enable1 <= '0';
       wait for clk_period;

      -- Read Reg(6) on port 0, Read Reg(0) on port 1
      read_address1 <= "110";
      read_address2 <= "000";
     -- wait for clk_period/2;

      -- Donât write on the 1st port, Write 0x789 to Reg(1).
      data_in2 <= "011110001001";
      write_enable1 <= '1';
      write_address2 <= "001";
      wait for clk_period;
      write_enable1 <= '0';
        wait for clk_period;


      -- Read Reg(1) on port 0, Read Reg(2) on port 1, Donât write anything.
      read_address1 <= "001";
      read_address2 <= "010";
      wait for clk_period;

      -- Read Reg(3) on port 0, Read Reg(4) on port 1, Donât write anything.
      read_address1 <= "011";
      read_address2 <= "100";
      wait for clk_period;

      wait;
      end process;


END;