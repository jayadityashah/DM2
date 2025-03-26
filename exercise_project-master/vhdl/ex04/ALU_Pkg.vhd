library ieee;
use ieee.std_logic_1164.all;

package ALU_Pkg is
    -- Define the ALU operation type (enumeration)
    type alu_op_t is (
        ADDWF, ANDWF, CLRF, CLRW, COMF, DECF, INCF, IORWF,
        MOVF, MOVWF, NOP, RLF, RRF, SUBWF, SWAPF, XORWF,
        BCF, BSF, ADDLW, ANDLW, IORLW, MOVLW, SUBLW, XORLW,
        CALL, RETLW, RETURN_OP
    );
end package ALU_Pkg;

package body ALU_Pkg is
end package body ALU_Pkg;
