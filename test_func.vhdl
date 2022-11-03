library ieee;
use ieee.std_logic_1164.all;

use work.SAP_types.all;

package test_func is
    
    procedure test_register (
        signal clk : in std_logic;
        signal reset, get, set : out bit;
        signal dbus : inout BUS_type);

    procedure test_bus (
        signal clk : in std_logic;
        signal get0, set0 : out bit;
        signal get1, set1 : out bit;
        signal dbus : inout BUS_type);

    procedure test_alu (
        signal clk : in std_logic;
        signal flag : in bit_vector(1 downto 0);
        signal op : out bit_vector(1 downto 0);
        signal get, set, rst : out bit;
        signal dbus : inout BUS_type);

end package test_func;

package body test_func is
    
    procedure test_register (signal clk : in std_logic;
                signal reset, get, set : out bit;
                signal dbus : inout BUS_type
            ) is
        begin
            assert false report "testing register" severity note;

            dbus <= "00000001";

            wait until clk = '0'; --falling edge
            
            set <= '1';
            
            wait until clk = '1'; --rising edge
            wait until clk = '0'; --falling edge
            
            dbus <= "LLLLLLLL";
            set <= '0';

            wait until clk = '1'; --rising edge
            wait until clk = '0'; --falling edge

            get <= '1';

            wait until clk = '1'; --rising edge
            assert dbus = "00000001" report "data not stored or not on bus"
                severity note;
            wait until clk = '0'; --falling edge
            
            reset <= '1';

            wait until clk = '1'; --rising edge
            wait for 1 ns;
            assert dbus = "00000000" report "data not reseted"
                severity note;
            wait until clk = '0'; --falling edge

            get <= '0';
            reset <= '0';

    end test_register;

    procedure test_bus (signal clk : in std_logic;
                signal get0, set0 : out bit;
                signal get1, set1 : out bit;
                signal dbus : inout BUS_type
            ) is
        begin
            assert false report "testing bus" severity note;

            dbus <= "00000001";

            wait until clk = '0'; --falling edge
            
            set0 <= '1';
            
            wait until clk = '1'; --rising edge
            wait until clk = '0'; --falling edge
            
            dbus <= "LLLLLLLL";
            set0 <= '0';

            wait until clk = '1'; --rising edge
            wait until clk = '0'; --falling edge

            get0 <= '1';
            set1 <= '1';

            wait until clk = '1'; --rising edge
            assert dbus = "00000001" report "data not on bus (get r1 set r2)"
                severity note;
            wait until clk = '0'; --falling edge
            
            get0 <= '0';
            set1 <= '0';
            get1 <= '1';

            wait until clk = '1'; --rising edge
            
            assert dbus = "00000001" report "data not on bus (get r2)"
                severity note;
            
            wait until clk = '0'; --falling edge

    end test_bus;

    --not 100% done, only test flag and add
    procedure test_alu (
        signal clk : in std_logic;
        signal flag : in bit_vector(1 downto 0);
        signal op : out bit_vector(1 downto 0);
        signal get, set, rst : out bit;
        signal dbus : inout BUS_type) is
        begin

        assert false report "testing bus" severity note;

        op <= "00"; -- +
        rst <= '0';

        dbus <= "LLLLLLLL";

        wait until clk = '0'; --falling edge
        
        set <= '1';
        
        wait until clk = '1'; --rising edge
        wait until clk = '0'; --falling edge

        assert flag(0) = '1' report "zero flag not detecting 0" severity warning;
        assert flag(1) = '0' report "neg flag false detection of neg" severity warning;
        
        dbus <= "11111111";

        wait until clk = '1'; --rising edge
        wait until clk = '0'; --falling edge

        assert flag(0) = '0' report "zero flag false detection of 0" severity warning;
        assert flag(1) = '1' report "neg flag not detecting neg" severity warning;
        
        dbus <= x"01";

        wait until clk = '1'; --rising edge
        wait until clk = '0'; --falling edge
        wait until clk = '1'; --rising edge
        wait until clk = '0'; --falling edge
        wait until clk = '1'; --rising edge
        wait until clk = '0'; --falling edge
        wait until clk = '1'; --rising edge
        wait until clk = '0'; --falling edge

        set <= '0';
        get <= '1';
        dbus <= "LLLLLLLL";

        wait until clk = '1'; --rising edge
        wait until clk = '0'; --falling edge

        set <= '0';
        get <= '0';
        op <= "00";
        assert dbus = x"03" report "adding not working" severity warning;

    end test_alu;

end package body test_func;