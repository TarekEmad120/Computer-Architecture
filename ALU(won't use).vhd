LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY ALU IS
generic (bits: integer := 16);
    PORT (
        input1 : IN STD_LOGIC_VECTOR (bits-1 DOWNTO 0);
        input2 : IN STD_LOGIC_VECTOR (bits-1 DOWNTO 0);
        selections : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        C_in : IN STD_LOGIC;
        output1 : OUT STD_LOGIC_VECTOR (bits-1 DOWNTO 0);
        C_out : OUT STD_LOGIC
    );
END ALU;

ARCHITECTURE ALU_Arch OF ALU IS

    COMPONENT ALUB IS
    generic (bits: integer := 16);
        PORT (
            A : IN STD_LOGIC_VECTOR (bits-1 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR (bits-1 DOWNTO 0);
            S : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            Cin : IN STD_LOGIC;
            F : OUT STD_LOGIC_VECTOR (bits-1 DOWNTO 0);
            Cout : OUT STD_LOGIC);
    END COMPONENT;
    COMPONENT ALUD IS
    generic (bits: integer := 16);
        PORT (
            A : IN STD_LOGIC_VECTOR (bits-1 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR (bits-1 DOWNTO 0);
            S : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            Cin : IN STD_LOGIC;
            F : OUT STD_LOGIC_VECTOR (bits-1 DOWNTO 0);
            Cout : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT ALUC IS
    generic (bits: integer := 16);
        PORT (
            A : IN STD_LOGIC_VECTOR (bits-1 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR (bits-1 DOWNTO 0);
            S : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            Cin : IN STD_LOGIC;
            F : OUT STD_LOGIC_VECTOR (bits-1 DOWNTO 0);
            Cout : OUT STD_LOGIC);
    END COMPONENT;
    
    COMPONENT ALUA IS
    generic (bits: integer := 16);
        PORT (
            A : IN STD_LOGIC_VECTOR (bits-1 DOWNTO 0);
            B : IN STD_LOGIC_VECTOR (bits-1 DOWNTO 0);
            C_in : IN STD_LOGIC;
            S : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            result : OUT STD_LOGIC_VECTOR (bits-1 DOWNTO 0);
            Cout : OUT STD_LOGIC);
    END COMPONENT;

    --SIGNAL mux : STD_LOGIC_VECTOR (15 DOWNTO 0);
    --SIGNAL C_out_mux : STD_LOGIC;
    SIGNAL output_ALUd, output_ALUc, output_ALU, output_ALU0 : STD_LOGIC_VECTOR (bits-1 DOWNTO 0);
    SIGNAL C_out_ALUd, C_out_ALUc, C_out_ALU, C_out_ALU0 : STD_LOGIC;
BEGIN
    --we need to check on first bit of selections to choose between ALUd , ALUc,and ALU

    ALUd1 : ALUD
    PORT MAP(
        A => input1,
        B => input2,
        S => selections,
        Cin => C_in,
        F => output_ALUd,
        Cout => C_out_ALUd);

    ALUc1 : ALUC
    PORT MAP(
        A => input1,
        B => input2,
        S => selections,
        Cin => C_in,
        F => output_ALUc,
        Cout => C_out_ALUc);

    ALU1 : ALUB
    PORT MAP(
        A => input1,
        B => input2,
        S => selections,
        Cin => C_in,
        F => output_ALU,
        Cout => C_out_ALU);
    ALU0 : ALUA
    PORT MAP(
        A => input1,
        B => input2,
        C_in => C_in,
        S => selections,
        result => output_ALU0,
        Cout => C_out_ALU0);

    -- output1 <= output_ALU0 WHEN selections(3 DOWNTO 2) = "00"
    --     ELSE
    --     output_ALU WHEN selections(3 DOWNTO 2) = "01"
    --     ELSE
    --     output_ALUc WHEN selections(3 DOWNTO 2) = "10"
    --     ELSE
    --     output_ALUd WHEN selections(3 DOWNTO 2) = "11";
    -- C_out <= C_out_ALU0 WHEN selections(3 DOWNTO 2) = "00"
    --     ELSE
    --     C_out_ALU WHEN selections(3 DOWNTO 2) = "01"
    --     ELSE
    --     C_out_ALUc WHEN selections(3 DOWNTO 2) = "10"
    --     ELSE
    --     C_out_ALUd WHEN selections(3 DOWNTO 2) = "11";

        with selections(3 DOWNTO 2) select
        output1 <= output_ALU0 WHEN "00",
        output_ALU WHEN "01",
        output_ALUc WHEN "10",
        output_ALUd WHEN "11",
        (others => '0') when others;

        with selections(3 DOWNTO 2) select
        C_out <= C_out_ALU0 WHEN "00",
        C_out_ALU WHEN "01",
        C_out_ALUc WHEN "10",
        C_out_ALUd WHEN "11",
        '0' when others;




END ALU_Arch;