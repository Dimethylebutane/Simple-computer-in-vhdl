library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use IEEE.numeric_std.all;

use work.SAP_types.all;
use work.test_func.all;

entity test_bench is
end entity;

architecture test of test_bench is
--definition des signaux
        --clock
        signal clk : std_logic;
        --bus
        signal dbus : BUS_type;

        --reg 0
        signal opR2 : bit_vector(1 downto 0);
        --reg 1
        signal opR1 : bit_vector(1 downto 0);

        --alu ctrl
        signal flag : bit_vector(1 downto 0);
        signal aluCtrl : bit_vector(1 downto 0);
        signal aluOp : bit_vector(1 downto 0);
        
        --PC
        signal pcRst: bit;
        signal pcOp : bit_vector(1 downto 0);
        --RAM
        signal RamOp : STD_LOGIC_VECTOR(2 downto 0);

begin
        --instance of module
        clk0: entity work.heartbeat(behaviour) port map(clk => clk);

        R2: entity work.Reg(behaviour) port map (clk => clk,
                        op => opR2,
                        dbus => dbus);
        R1: entity work.Reg(behaviour) port map (clk => clk,
                        op => opR1,
                        dbus => dbus);

        alu: entity work.ALU(behaviour) port map(ctrl => aluCtrl,
                        op => aluOp,
                        dbus => dbus,
                        flag => flag,
                        clk => clk);
        pc : entity work.PC(behaviour) port map(clk => clk,
                        reset => pcRst, op => pcOp,
                        dbus => dbus);
        
        CU: entity work.Ctrl(behaviour) port map(clk => clk,
                opR2 => opR2,
                opR1 => opR1,

                aluFlag => flag,
                aluCtrl => aluCtrl,
                aluOp => aluOp,

                dbus => dbus,

                pcRst => pcRst, pcOp => pcOp,

                memOp => RamOp);
        
        Ram: entity work.Memory(behaviour) port map(clk => clk,
                op => RamOp,
                dbus => dbus
        );

        process is
                variable v : integer;
        begin
                --test_register(clk,
                --        rst0, get0, set0,
                --        dbus);
                
                --test_bus (clk,
                --        get0, set0,
                --        get1, set1,
                --        dbus);

                --test_alu (
                --        clk,
                --        flag,
                --        aluOp,
                --        aluOe, aluStoreResult, aluRst,
                --        dbus);

                

                --assert false report "end of test" severity failure;
                --  Wait forever; this will finish the simulation.
                wait for 1000 ns;
                assert false report "too long, killing process..." severity failure;
                
                wait;
        end process;

end test;