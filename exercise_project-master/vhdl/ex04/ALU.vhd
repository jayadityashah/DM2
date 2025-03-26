library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ALU_Pkg.all;

entity ALU is
    port(
        operand_A : in  std_logic_vector(7 downto 0);
        operand_B : in  std_logic_vector(7 downto 0);
        operation : in  alu_op_t;
        bit_select: in  std_logic_vector(2 downto 0);
        status_in : in  std_logic_vector(2 downto 0);
        result    : out std_logic_vector(7 downto 0);
        status_out: out std_logic_vector(2 downto 0)
    );
end entity ALU;

architecture Behavioral of ALU is

    -- A helper procedure for performing 8-bit addition.
    -- It calculates both the result and the flags: C (carry out),
    -- DC (carry from lower nibble) and Z (zero flag).
    procedure add_with_flags(
        a, b       : in std_logic_vector(7 downto 0);
        res : out std_logic_vector(7 downto 0);
        flags : out std_logic_vector(2 downto 0)
    ) is
        variable sum     : unsigned(8 downto 0);
        variable low_a   : unsigned(3 downto 0);
        variable low_b   : unsigned(3 downto 0);
        variable low_sum : unsigned(4 downto 0);
        variable res_temp: std_logic_vector(7 downto 0);
    begin
        sum := ('0' & unsigned(a)) + ('0' & unsigned(b));
        res_temp := std_logic_vector(sum(7 downto 0));
        res := res_temp;
        -- Carry flag (bit 0)
        if sum(8) = '1' then
            flags(0) := '1';
        else
            flags(0) := '0';
        end if;
        -- Digit carry flag (bit 1): carry from bit 3
        low_a := unsigned(a(3 downto 0));
        low_b := unsigned(b(3 downto 0));
        low_sum := ('0' & low_a) + ('0' & low_b);
        if low_sum(4) = '1' then
            flags(1) := '1';
        else
            flags(1) := '0';
        end if;
        -- Zero flag (bit 2)
        if res_temp = "00000000" then
            flags(2) := '1';
        else
            flags(2) := '0';
        end if;
    end procedure add_with_flags;

begin

    -- Combinational ALU process
    process(operand_A, operand_B, operation, bit_select, status_in)
        variable temp_result : std_logic_vector(7 downto 0);
        variable flags       : std_logic_vector(2 downto 0);
        variable sum         : unsigned(8 downto 0);
        variable low_sum     : unsigned(4 downto 0);
    begin
        case operation is

            -- Arithmetic operations using the helper procedure.
            when ADDWF | ADDLW =>
                add_with_flags(operand_A, operand_B, temp_result, flags);
                result <= temp_result;
                status_out <= flags;

            -- Logical AND operations.
            when ANDWF | ANDLW =>
                temp_result := operand_A and operand_B;
                -- For logic operations we assume no carry or digit carry.
                flags(0) := '0';
                flags(1) := '0';
                if temp_result = "00000000" then
                    flags(2) := '1';
                else
                    flags(2) := '0';
                end if;
                result <= temp_result;
                status_out <= flags;

            -- Clear file register (or working register) operations.
            when CLRF | CLRW =>
                temp_result := (others => '0');  -- assignment is allowed
                -- Zero flag is set when the result is zero.
                flags := "001";  -- Example: only Z flag is '1'
                result <= temp_result;
                status_out <= flags;

            -- Complement file register.
            when COMF =>
                temp_result := not operand_A;
                if temp_result = "00000000" then
                    flags := "001";
                else
                    flags := "000";
                end if;
                result <= temp_result;
                status_out <= flags;

            -- Decrement file register.
            when DECF =>
                sum := ('0' & unsigned(operand_A)) - 1;
                temp_result := std_logic_vector(sum(7 downto 0));
                -- Flag calculation could be enhanced.
                if temp_result = "00000000" then
                    flags(2) := '1';
                else
                    flags(2) := '0';
                end if;
                flags(0) := '0';
                flags(1) := '0';
                result <= temp_result;
                status_out <= flags;

            -- Increment file register.
            when INCF =>
                add_with_flags(operand_A, x"01", temp_result, flags);
                result <= temp_result;
                status_out <= flags;

            -- Inclusive OR operations.
            when IORWF | IORLW =>
                temp_result := operand_A or operand_B;
                flags(0) := '0';
                flags(1) := '0';
                if temp_result = "00000000" then
                    flags(2) := '1';
                else
                    flags(2) := '0';
                end if;
                result <= temp_result;
                status_out <= flags;

            -- Move file register.
            when MOVF | MOVWF | MOVLW =>
                temp_result := operand_A; -- or operand_B in case of MOVWF/MOVLW
                if temp_result = "00000000" then
                    flags := "001";
                else
                    flags := "000";
                end if;
                result <= temp_result;
                status_out <= flags;

            -- No operation.
            when NOP =>
                result <= operand_A;
                status_out <= status_in;

            -- Rotate left: for example, a left shift with the high bit going into the C flag.
            when RLF =>
                temp_result := operand_A(6 downto 0) & operand_A(7);
                flags(0) := operand_A(7);  -- Carry flag gets the MSB
                if temp_result = "00000000" then
                    flags(2) := '1';
                else
                    flags(2) := '0';
                end if;
                flags(1) := '0';
                result <= temp_result;
                status_out <= flags;

            -- Rotate right: similarly, the low bit is shifted out.
            when RRF =>
                temp_result := operand_A(0) & operand_A(7 downto 1);
                flags(0) := operand_A(0);  -- Carry flag gets the LSB
                if temp_result = "00000000" then
                    flags(2) := '1';
                else
                    flags(2) := '0';
                end if;
                flags(1) := '0';
                result <= temp_result;
                status_out <= flags;

            -- Subtraction: this is a simple subtraction example.
            when SUBWF | SUBLW =>
                -- Note: In an actual PIC design, subtraction is defined in a specific way.
                sum := ('0' & unsigned(operand_A)) - ('0' & unsigned(operand_B));
                temp_result := std_logic_vector(sum(7 downto 0));
                flags(0) := sum(8);  -- Carry/borrow flag may need further refinement.
                if temp_result = "00000000" then
                    flags(2) := '1';
                else
                    flags(2) := '0';
                end if;
                flags(1) := '0';
                result <= temp_result;
                status_out <= flags;

            -- Swap nibbles.
            when SWAPF =>
                temp_result := operand_A(3 downto 0) & operand_A(7 downto 4);
                if temp_result = "00000000" then
                    flags := "001";
                else
                    flags := "000";
                end if;
                result <= temp_result;
                status_out <= flags;

            -- XOR operations.
            when XORWF | XORLW =>
                temp_result := operand_A xor operand_B;
                flags(0) := '0';
                flags(1) := '0';
                if temp_result = "00000000" then
                    flags(2) := '1';
                else
                    flags(2) := '0';
                end if;
                result <= temp_result;
                status_out <= flags;

            -- Bit Clear File: clear the bit indicated by bit_select.
            when BCF =>
                temp_result := operand_A;
                temp_result(to_integer(unsigned(bit_select))) := '0';
                if temp_result = "00000000" then
                    flags := "001";
                else
                    flags := "000";
                end if;
                result <= temp_result;
                status_out <= flags;

            -- Bit Set File: set the bit indicated by bit_select.
            when BSF =>
                temp_result := operand_A;
                temp_result(to_integer(unsigned(bit_select))) := '1';
                if temp_result = "00000000" then
                    flags := "001";
                else
                    flags := "000";
                end if;
                result <= temp_result;
                status_out <= flags;

            -- For commands that involve the stack (CALL, RETLW, RETURN)
            -- the ALU does not handle these; so we treat them as NOP here.
            when CALL | RETLW | RETURN_OP =>
                result <= operand_A;
                status_out <= status_in;

            when others =>
                result <= operand_A;
                status_out <= status_in;
        end case;
    end process;
    
end architecture Behavioral;
