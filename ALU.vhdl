library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.SAP_types.all;

entity ALU is
    port (
        --clock
        clk : in std_logic;

        --control
        --aluOe, aluStoreResult, rst : in bit;
        ctrl : in bit_vector(1 downto 0); --Oe, Set
        op : in bit_vector(1 downto 0); -- +, -, and, or

        --Bus
        dbus : inout BUS_type := (others => 'Z');

        --flag
        flag : out bit_vector(1 downto 0) --0: Z, 1: N
    );
end ALU;

architecture behaviour of ALU is
    signal ALU_reg, ALU_res : SAP_byte := (others => '0');
begin
    
    dbus <= std_logic_vector(ALU_reg) when ctrl(0) = '1' else (others => 'Z');

    flag(0) <=  '1' when std_logic_vector(ALU_reg) = x"00" else '0';
    flag(1) <=  '1' when std_logic(ALU_reg(7)) = '1' else '0';

    process(op, dbus, clk, ctrl, ALU_reg)
    begin
        case op is
            when "00" => ALU_res <= ALU_reg + signed(dbus);
            when "01" => ALU_res <= ALU_reg - signed(dbus);
            when "10" => ALU_res <= ALU_reg and signed(dbus);
            when "11" => ALU_res <= ALU_reg or signed(dbus);
        end case;

        if (ctrl(1) = '1' and rising_edge(clk)) then
            ALU_reg <= ALU_res;
            end if;
    end process;

end behaviour;