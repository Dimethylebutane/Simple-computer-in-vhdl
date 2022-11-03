library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.SAP_types.all;

entity IReg is
    port (
        --ctrl
        clk : in std_logic;
        set : in bit;

        --Bus
        dbus : in BUS_type := (others => 'Z');
        Instr : out BUS_type
    );
end IReg;


architecture behaviour of IReg is
    signal data : SAP_byte := (others => '0');
begin

    Instr <= Std_Logic_Vector(data);

    process(clk) 
        --drive data
    begin
        if (rising_edge(clk) and set = '1') then
            data <= signed(dbus);
        end if;
    end process;

end behaviour;