--includes
LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;
ENTITY mini_processor IS
    GENERIC (bits : INTEGER := 16);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        data_in : IN STD_LOGIC_VECTOR (bits - 1 DOWNTO 0);
        data_out : OUT STD_LOGIC_VECTOR (bits - 1 DOWNTO 0);
        wePC : IN STD_LOGIC := '0';
        weR : IN STD_LOGIC := '0';
        weDD1, weDD2 : IN STD_LOGIC := '0'
    );
END mini_processor;

ARCHITECTURE Behavioral OF mini_processor IS
    COMPONENT counter IS
        GENERIC (N : INTEGER := 6);
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            enable : IN STD_LOGIC;
            PC : OUT STD_LOGIC_VECTOR (N - 1 DOWNTO 0));
    END COMPONENT;
    SIGNAL Program_Counter : STD_LOGIC_VECTOR(5 DOWNTO 0);

    COMPONENT register_ram IS
        PORT (
            clk : IN STD_LOGIC;
            rest : IN STD_LOGIC;
            we1 : IN STD_LOGIC;
            we2 : IN STD_LOGIC;
            readaddress1 : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
            readaddress2 : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
            writeaddress1 : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
            writeaddress2 : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
            data_in1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            data_in2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            data_out1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            data_out2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );

    END COMPONENT;
    SIGNAL Inst1, Inst2 : STD_LOGIC_VECTOR(15 DOWNTO 0);

    COMPONENT my_nDFF IS
        GENERIC (n : INTEGER := 16);
        PORT (
            Clk, Rst : IN STD_LOGIC;
            d : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            q : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            en_write : IN STD_LOGIC
        );
    END COMPONENT;
    SIGNAL OutFD1, OutFD2, OutDD2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL OutWB : STD_LOGIC_VECTOR(19 DOWNTO 0);
    SIGNAL OutDD1 : STD_LOGIC_VECTOR(40 DOWNTO 0);

    COMPONENT register_file IS
        GENERIC (bits : INTEGER := 16);
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            data_in1 : IN STD_LOGIC_VECTOR(bits - 1 DOWNTO 0);
            data_in2 : IN STD_LOGIC_VECTOR(bits - 1 DOWNTO 0);
            data_out1 : OUT STD_LOGIC_VECTOR(bits - 1 DOWNTO 0);
            data_out2 : OUT STD_LOGIC_VECTOR(bits - 1 DOWNTO 0);
            write_enable : IN STD_LOGIC;
            read_address1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            read_address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            write_address1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            write_address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT ALU IS
        GENERIC (bits : INTEGER := 16);
        PORT (
            input1 : IN STD_LOGIC_VECTOR (bits - 1 DOWNTO 0);
            input2 : IN STD_LOGIC_VECTOR (bits - 1 DOWNTO 0);
            selections : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            C_in : IN STD_LOGIC;
            output1 : OUT STD_LOGIC_VECTOR (bits - 1 DOWNTO 0);
            C_out : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT controller IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            opcode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            selalu : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            cin : OUT STD_LOGIC;
            write_en : OUT STD_LOGIC
        );

    END COMPONENT;

    SIGNAL Reg1, Reg2, OutputALU : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Cout, Cin : STD_LOGIC;
    SIGNAL Sel : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL weWB : STD_LOGIC := '0';
    --reg1 , reg2 ,sel , OutFD1(12 down to 10) will be contcatenated to form the input for decode_execute_reg
    -- reg1 is 16 bits , reg2 is 16 bits , sel is 4 bits , OutFD1(12 down to 10) is 3 bits
    -- so the input for decode_execute_reg will be 39 bits
    SIGNAL decode_execute_reg_input : STD_LOGIC_VECTOR(40 DOWNTO 0);

    -- writeback will contain writeback data and writeaddress
    -- writeback data is 16 bits and writeaddress is 3 bits
    -- so the input for writeback will be 19 bits
    SIGNAL writeback_input : STD_LOGIC_VECTOR(19 DOWNTO 0);
    signal outrest : std_logic_vector(0 downto 0);
    signal inrest : std_logic_vector(0 downto 0);
    signal Writebackaddress: std_logic_vector(2 downto 0);
BEGIN


            PC : counter PORT MAP(clk, reset, wePC, Program_Counter);
            Instruction_Cashe : register_ram PORT MAP(clk, reset, '0', '0', Program_Counter, "111111", "111111", "111111", x"0000", x"0000", Inst1, Inst2);
            Fetch_Decode_Reg : my_nDFF GENERIC MAP(16) PORT MAP(clk, reset, Inst1, OutFD1, '1');
            Register_Files : register_file GENERIC MAP(16) PORT MAP(clk, reset, OutWB(18 DOWNTO 3), x"0000", Reg1, Reg2, outWb(19), OutFD1(9 DOWNTO 7), OutFD1(6 DOWNTO 4), OutWB(2 DOWNTO 0), "111");
            controller1 : controller PORT MAP(clk, reset, OutFD1(15 DOWNTO 13), Sel, Cin, weWB);
            decode_execute_reg_input <= weWB & Reg1 & Reg2 & Sel & OutFD1(12 DOWNTO 10) & Cin;
            Decode_Execute_Reg : my_nDFF GENERIC MAP(41) PORT MAP(clk, outrest(0), decode_execute_reg_input, OutDD1, weDD1);
            -- alu will take the output of decode_execute_reg as 3 inputs , 2 of them are inputs and 3rd is sel to choose the operation
            Alu : ALU GENERIC MAP(16) PORT MAP(OutDD1(39 DOWNTO 24), OutDD1(23 DOWNTO 8), OutDD1(7 DOWNTO 4), OutDD1(0), OutputALU, Cout);
    
            writeback_input <= OutDD1(40) & OutputALU & OutDD1(3 DOWNTO 1);
            Write_Back : my_nDFF GENERIC MAP(20) PORT MAP(clk, reset, writeback_input, OutWB, '1');
            u1:my_nDFF GENERIC MAP(1) PORT MAP(clk, '0',inrest,outrest,OutDD1(40));

    data_out <= OutWB(18 DOWNTO 3);
END Behavioral;