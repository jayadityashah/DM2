library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.ALU_Pkg.all;

entity tb_ex04 is
end entity tb_ex04;

architecture Behavioral of tb_ex04 is

    -- Signals to drive the ALU
    signal operand_A : std_logic_vector(7 downto 0);
    signal operand_B : std_logic_vector(7 downto 0);
    signal op        : alu_op_t;
    signal bit_select: std_logic_vector(2 downto 0);
    signal status_in : std_logic_vector(2 downto 0);
    signal result    : std_logic_vector(7 downto 0);
    signal status_out: std_logic_vector(2 downto 0);

    -- Component declaration for the ALU
    component ALU
        port(
            operand_A : in  std_logic_vector(7 downto 0);
            operand_B : in  std_logic_vector(7 downto 0);
            operation : in  alu_op_t;
            bit_select: in  std_logic_vector(2 downto 0);
            status_in : in  std_logic_vector(2 downto 0);
            result    : out std_logic_vector(7 downto 0);
            status_out: out std_logic_vector(2 downto 0)
        );
    end component;

    -- File declarations
    file input_file : text open read_mode is "input.txt";
    file output_file : text open write_mode is "output.txt";

    -- A helper function to convert a string to the ALU operation type.
    function to_alu_op(op_str: string) return alu_op_t is
    begin
        if op_str = "ADDWF" then
            return ADDWF;
        elsif op_str = "ANDWF" then
            return ANDWF;
        elsif op_str = "CLRF" then
            return CLRF;
        elsif op_str = "CLRW" then
            return CLRW;
        elsif op_str = "COMF" then
            return COMF;
        elsif op_str = "DECF" then
            return DECF;
        elsif op_str = "INCF" then
            return INCF;
        elsif op_str = "IORWF" then
            return IORWF;
        elsif op_str = "MOVF" then
            return MOVF;
        elsif op_str = "MOVWF" then
            return MOVWF;
        elsif op_str = "NOP" then
            return NOP;
        elsif op_str = "RLF" then
            return RLF;
        elsif op_str = "RRF" then
            return RRF;
        elsif op_str = "SUBWF" then
            return SUBWF;
        elsif op_str = "SWAPF" then
            return SWAPF;
        elsif op_str = "XORWF" then
            return XORWF;
        elsif op_str = "BCF" then
            return BCF;
        elsif op_str = "BSF" then
            return BSF;
        elsif op_str = "ADDLW" then
            return ADDLW;
        elsif op_str = "ANDLW" then
            return ANDLW;
        elsif op_str = "IORLW" then
            return IORLW;
        elsif op_str = "MOVLW" then
            return MOVLW;
        elsif op_str = "SUBLW" then
            return SUBLW;
        elsif op_str = "XORLW" then
            return XORLW;
        elsif op_str = "CALL" then
            return CALL;
        elsif op_str = "RETLW" then
            return RETLW;
        elsif op_str = "RETURN_OP" then
            return RETURN_OP;
        else
            return NOP;
        end if;
    end function;

begin

    -- Instantiate the ALU
    UUT: ALU
        port map(
            operand_A => operand_A,
            operand_B => operand_B,
            operation => op,
            bit_select=> bit_select,
            status_in => status_in,
            result    => result,
            status_out=> status_out
        );

    -- Stimulus process: reads the input file, applies stimulus, and writes results.
    stim_proc: process
        variable in_line     : line;
        variable out_line    : line;
        variable line_content: string(1 to 100);
        variable line_length : natural;
        variable op_name     : string(1 to 10);
        variable op_int      : integer;
        variable op2_int     : integer;
        variable bs_int      : integer;
        variable st_int      : integer;
        variable idx         : natural;
    begin
        while not endfile(input_file) loop
            readline(input_file, in_line);
            
            -- Read entire line as a string for simplicity
            line_content := (others => ' ');
            line_length := in_line'length;
            if line_length > 100 then
                line_length := 100;
            end if;
            line_content(1 to line_length) := in_line.all(1 to line_length);
            
            -- Find the first space to extract operation name
            idx := 1;
            while idx <= line_length and line_content(idx) /= ' ' loop
                idx := idx + 1;
            end loop;
            
            -- Extract operation name
            op_name := (others => ' ');
            op_name(1 to idx-1) := line_content(1 to idx-1);
            
            -- Skip spaces
            while idx <= line_length and line_content(idx) = ' ' loop
                idx := idx + 1;
            end loop;
            
            -- Extract operand_A
            op_int := 0;
            while idx <= line_length and line_content(idx) >= '0' and line_content(idx) <= '9' loop
                op_int := op_int * 10 + character'pos(line_content(idx)) - character'pos('0');
                idx := idx + 1;
            end loop;
            
            -- Skip spaces
            while idx <= line_length and line_content(idx) = ' ' loop
                idx := idx + 1;
            end loop;
            
            -- Extract operand_B
            op2_int := 0;
            while idx <= line_length and line_content(idx) >= '0' and line_content(idx) <= '9' loop
                op2_int := op2_int * 10 + character'pos(line_content(idx)) - character'pos('0');
                idx := idx + 1;
            end loop;
            
            -- Skip spaces
            while idx <= line_length and line_content(idx) = ' ' loop
                idx := idx + 1;
            end loop;
            
            -- Extract bit_select
            bs_int := 0;
            while idx <= line_length and line_content(idx) >= '0' and line_content(idx) <= '9' loop
                bs_int := bs_int * 10 + character'pos(line_content(idx)) - character'pos('0');
                idx := idx + 1;
            end loop;
            
            -- Skip spaces
            while idx <= line_length and line_content(idx) = ' ' loop
                idx := idx + 1;
            end loop;
            
            -- Extract status_in
            st_int := 0;
            while idx <= line_length and line_content(idx) >= '0' and line_content(idx) <= '9' loop
                st_int := st_int * 10 + character'pos(line_content(idx)) - character'pos('0');
                idx := idx + 1;
            end loop;
            
            -- Apply signals
            op <= to_alu_op(op_name);
            operand_A <= std_logic_vector(to_unsigned(op_int, 8));
            operand_B <= std_logic_vector(to_unsigned(op2_int, 8));
            bit_select <= std_logic_vector(to_unsigned(bs_int, 3));
            status_in  <= std_logic_vector(to_unsigned(st_int, 3));

            wait for 10 ns;  -- Allow time for the ALU to compute

            -- Write a summary to the output file
            write(out_line, string'("Operation: ") & op_name &
                           string'(" | operand_A: ") & integer'image(op_int) &
                           string'(" | operand_B: ") & integer'image(op2_int) &
                           string'(" | Result: ") & integer'image(to_integer(unsigned(result))) &
                           string'(" | Status: ") & integer'image(to_integer(unsigned(status_out))));
            writeline(output_file, out_line);
        end loop;
        
        wait;
    end process stim_proc;

end architecture Behavioral;
