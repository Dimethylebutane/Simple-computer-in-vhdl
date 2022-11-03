library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package SAP_types is

    subtype SAP_byte is signed(7 downto 0); --bit 0 is lsb
    subtype BUS_type is STD_LOGIC_VECTOR(7 downto 0); --bit 0 is lsb
    
end SAP_types;