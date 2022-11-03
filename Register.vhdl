library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.SAP_types.all;

entity Reg is
    port (
        --ctrl
        clk : in std_logic;
        op : in bit_vector(1 downto 0); -- get, set

        --Bus
        dbus : inout BUS_type := (others => 'Z')
    );
end Reg;


architecture behaviour of Reg is
    signal data : SAP_byte := (others => '0');
begin

    dbus <= Std_Logic_Vector(data) when (op(0) = '1') else
        (others => 'Z');

    process(clk) 
        --drive data
    begin
        if (rising_edge(clk) and op(1) = '1') then
            data <= signed(dbus);
        end if;
    end process;

end behaviour;