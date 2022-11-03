library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.SAP_types.all;

entity PC is
    port (
        --ctrl
        clk : in std_logic;
        reset : in bit;
        op : in bit_vector(1 downto 0);--NOP, get, set, inc

        --Bus
        dbus : inout BUS_type := (others => 'Z')
    );
end PC;


architecture behaviour of PC is
    signal counter : SAP_byte := (others => '0');
begin

    dbus <= Std_Logic_Vector(counter) when (op = "01") else
        (others => 'Z');

    process(clk) 
        --drive data
    begin
        if reset='1' then
            counter <= (others => '0');
        
        elsif rising_edge(clk) then

            case op is
                when "00" => counter <= counter;
                when "01" => counter <= counter;
                when "10" => counter <= signed(dbus);
                when "11" => counter <= counter + 1;
            end case;
        end if;
    end process;
end behaviour;