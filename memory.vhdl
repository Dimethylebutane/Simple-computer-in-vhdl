library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.SAP_types.all;

entity Memory is
    port (
        --clock
        clk : in std_logic;

        --ctrl
        op : in STD_LOGIC_VECTOR(2 downto 0);
        -- 001 : read memory
        -- 011 : read addr
        -- 101 : set addr
        -- 111 : set data
        -- --0 : NOP

        --bus
        dbus : inout BUS_type
    );
end Memory;

architecture behaviour of Memory is
    signal addr : unsigned(7 downto 0) := x"00"; --drived by set addr from bus

    type ram_type is array (0 to 256) of BUS_type;
    signal RAM : ram_type := (  "00011011",   --LDI X, 0x05
                                x"05",
                                "00011010", --LDI R1, 0x06
                                x"06",
                                "00011001", --LDI R2, 0x01
                                x"01",
                                "00100101", --ALU -, R2
                                "01001010", --JMP P, R1, N
                                "00000000", --MV 0, 0
                                "00000101", --MV R2, R2
                                "00011101", --GPC R2
                                x"FF",      --kill
                                others => (others => '0'));

    function get_mem(address : unsigned(7 downto 0)) return BUS_type is
    begin
        return RAM( to_integer( address ) );
    end function;

begin
    -- tri-state
    dbus <= (others => 'Z') when (op(0) = '0' or op(2) = '1' ) else 
            get_mem( addr ) when op = "001" else
            STD_LOGIC_VECTOR(addr);

    --drive addr
    process(clk)
    begin
        
        if (rising_edge(clk)) then
            if op = "101" then --inAddr
                addr <= unsigned(dbus); 

            elsif op = "111" then --inData
                RAM( to_integer( addr ) ) <= dbus;
            end if;
        end if;
        
    end process;
    
end behaviour;