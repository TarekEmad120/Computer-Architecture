LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY ALU IS
    PORT (
        input1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        input2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

        sel : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        outpt : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        carryout : OUT STD_LOGIC;

        Zero_flag : OUT STD_LOGIC;
        Negative_flag : OUT STD_LOGIC;
        Overflow_flag : OUT STD_LOGIC;
        Carry_flag : OUT STD_LOGIC

    );
END ALU;

ARCHITECTURE My_imp_of_ALU OF ALU IS

    COMPONENT n_bit_adder IS
        PORT (
            a,b : IN  std_logic_vector(31 downto 0);
            cin : in std_logic;
            s : out std_logic_vector(31 downto 0);
            cout : OUT std_logic);
    END COMPONENT;
    SIGNAL ax, bx: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL temp : STD_LOGIC_VECTOR(31 DOWNTO 0);
    
    --SIGNAL a2, b2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    --SIGNAL temp2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    
    SIGNAL temp_cout : STD_LOGIC;
    SIGNAL cin : STD_LOGIC;

    signal outpt_signal : STD_LOGIC_VECTOR(31 DOWNTO 0);

    --SIGNAL temp_cout2 : STD_LOGIC;
    --SIGNAL cin2 : STD_LOGIC;

BEGIN
    -- output <= not input1 when s = "0010" NOT
    -- output <=  -input1 when s = "0100"  NEG    input2 - input1 at (input2 0)  input2 + not input1 + 1
    -- output <= input1 +1  when s = "0110"  inc
    -- output <= input1 -1 when s = "1000"           DEC   input1 - 1    input1 + not 1 + 1
    -- output <= input1  when s = "0001"  move
    -- output <= input1 - input2 when s = "0011"  SWAPPPPPPPPPPP
    -- output <= input1 + input2 when s = "0101"  ADD
    -- output <= input1 - input2 when s = "0111"  SUB    input1 + not input2 + 1
    -- output <= input1 AND input2 when s = "1001"  AND
    -- output <= input1 OR input2 when s = "1011"  OR
    -- output <= input1 XOR input2 when s = "1111"  XOR
    -- output <= input1 - input2 when s = "1101"  Cmp

    

    
    outpt_signal <= NOT input1 WHEN sel = "0010" ELSE
        temp WHEN sel = "0100" ELSE
        temp WHEN sel = "0110" ELSE
        temp WHEN sel = "1000" ELSE
        input1 WHEN sel = "0001" ELSE
        temp WHEN sel = "0011" ELSE---------------------SWAP
        temp WHEN sel = "0101" ELSE
        temp WHEN sel = "0111" or sel = "1101" ELSE
        input1 AND input2 WHEN sel = "1001" ELSE
        input1 OR input2 WHEN sel = "1011" ELSE
        input1 XOR input2 WHEN sel = "1111" ELSE
        x"00000000";

    ax <=
        x"00000000" WHEN sel = "0100" ELSE
        input1 WHEN sel = "0110" ELSE
        input1 WHEN sel = "1000" ELSE
        input1 WHEN sel = "0101" ELSE
        input1 WHEN (sel = "0111" or sel = "1101") ELSE
        x"00000000";

    bx <=
        NOT input2 WHEN sel = "0100" ELSE
        x"00000000" WHEN sel = "0110" ELSE
        NOT x"00000001" WHEN sel = "1000" ELSE
        input2 WHEN sel = "0101" ELSE
        NOT input2 WHEN (sel = "0111" or sel = "1101") ELSE
        x"00000000";

    cin <=
        '1' WHEN sel = "0100" ELSE
        '1' WHEN sel = "0110" ELSE
        '1' WHEN sel = "1000" ELSE
        '0' WHEN sel = "0101" ELSE
        '1' WHEN (sel = "0111" or sel = "1101") ELSE
        '0';
    
    outpt <= outpt_signal;
    Zero_flag <= '1' WHEN outpt_signal = x"00000000" ELSE '0';
    Carry_flag <= temp_cout;
    Negative_flag <= temp(31);
    Overflow_flag <= temp(31) XOR temp_cout;

    adder0 : n_bit_adder  PORT MAP(ax, bx, cin, temp, temp_cout);
    --adder1 : n_bit_adder PORT MAP(a2, b2, cin2, temp2, temp_cout2);

END ARCHITECTURE My_imp_of_ALU;