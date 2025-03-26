library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;

entity RippleCarryAdder_Nbit is
    Generic (N: integer := 8);
    Port(
        A  : in  STD_LOGIC_VECTOR(N-1 downto 0);
        B  : in  STD_LOGIC_VECTOR(N-1 downto 0);
        S  : out STD_LOGIC_VECTOR(N-1 downto 0);
        CO : out STD_LOGIC
    );
end entity RippleCarryAdder_Nbit;

architecture Structural of RippleCarryAdder_Nbit is
    -- Internal carry chain: N+1 bits (carry(0) is the initial carry-in)
    signal carry : STD_LOGIC_VECTOR(N downto 0);
begin
    -- No external carry-in
    carry(0) <= '0';
    
    gen_fulladders: for i in 0 to N-1 generate
    begin
        FA_inst: entity work.FullAdder port map(
            A  => A(i),
            B  => B(i),
            CI => carry(i),
            S  => S(i),
            CO => carry(i+1)
        );
    end generate;
    
    -- Final carry-out
    CO <= carry(N);
end architecture Structural;

	

