library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.SAP_types.all;

entity Ctrl is
    port (
        --clock
        clk : in std_logic;

        --reg 2
        opR2 : out bit_vector(1 downto 0) := "00";
        --reg 1
        opR1 : out bit_vector(1 downto 0) := "00";

        --alu ctrl
        aluFlag : in bit_vector(1 downto 0);
        aluCtrl : out bit_vector(1 downto 0);
        aluOp : out bit_vector(1 downto 0) := (others => '0');

        --bus
        dbus : inout BUS_type;

        --PC
        pcRst: out bit := '0';
        pcOp : out bit_vector(1 downto 0) := (others => '0');

        --memory
        memOp : out STD_LOGIC_VECTOR(2 downto 0) := (others => '0')

    );
end Ctrl;

architecture behaviour of Ctrl is
    signal counter : SAP_byte := (others => '0');

     --IR
     signal setIr : bit := '0';
     signal instr : BUS_type := (others => '0');

begin

    IR: entity work.IReg(behaviour) port map (clk => clk,
                        set => setIr,
                        Instr => instr,
                        dbus => dbus);

    dbus <= (others => 'L');

    process(clk)
    begin
        if falling_edge(clk) then

            counter <= counter + 1;

            pcOp <= "00";   -- NOP PC
            pcRst <= '0';

            memOp <= "000"; -- NOP RAM

            setIr <= '0';   -- NOP IR

            opR2 <= "00";
            opR1 <= "00";

            aluCtrl <= "00";
            aluOp <= "00";

            -- fetch
            if counter = x"00" then
                pcOp <= "01";   -- get PC
                memOp <= "101"; -- set addr
                report "fetching";
            elsif counter = x"01" then
                pcOp <= "11";   -- inc PC
                memOp <= "001"; -- get data
                setIr <= '1';  -- store instr
            else

                -- execute
                

                if instr(7 downto 5) =    "010" then --JMP I R, F
                    report "JMP " & integer'image( to_integer(unsigned(instr(3 downto 2)) ) ) & " " & integer'image( to_integer(unsigned(instr(1 downto 0)) ) );
                    case instr(3 downto 2) is --get adress
                        when "01" => opR2 <= "01";
                        when "10" => opR1 <= "01";
                        when "11" => aluCtrl <= "01";
                        when others => opR2 <= "00";
                    end case;
                    
                    pcOp <= "00";
                    
                    if instr(4) = '1' then
                        if (aluFlag="11" or instr(1 downto 0)="00" or aluFlag=to_BitVector(instr(1 downto 0)) or (instr(1 downto 0)="11" and aluFlag/="00") )
                            then
                            report "flag is not set";
                            pcOp <= "10";
                        end if;
                    else
                        if (aluFlag="00" or instr(1 downto 0)="00" or (instr(1 downto 0)="10" and aluFlag="01") or (instr(1 downto 0)="01" and aluFlag="10"))
                            then
                            report "flag is set";
                            pcOp <= "10";
                        end if;
                    end if;
                    
                    counter <= x"00";
                elsif instr(7 downto 4) = "0000" then --Move
                    
                    if instr(3 downto 2) = "01" then
                        opR2 <= "01";
                    elsif instr(3 downto 2) = "10" then
                        opR1 <= "01";
                    elsif instr(3 downto 2) = "11" then
                        aluCtrl <= "01";
                    end if;

                    report "MV " & integer'image( to_integer(unsigned(instr(3 downto 2)) ) ) & " " &integer'image( to_integer(unsigned(instr(3 downto 2)) ) );
                    if instr(1 downto 0) = "01" then
                        opR2 <= "10";
                    elsif instr(1 downto 0) = "10" then
                        opR1 <= "10";
                    elsif instr(1 downto 0) = "11" then
                        aluCtrl <= "10";
                    end if;
            
                    counter <= x"00";
                elsif instr(7 downto 4) = "0010" then --ALU
                    report "ALU " & integer'image( to_integer(unsigned(instr(3 downto 2)) ) ) & " " & integer'image( to_integer(unsigned(instr(1 downto 0)) ) );

                    case instr(1 downto 0) is --get register value
                        when "01" => opR2(0) <= '1';
                        when "10" => opR1(0) <= '1';
                        when "11" => aluCtrl(0) <= '1';
                        when others => opR2(0) <= '1';
                    end case;

                    aluOp <= to_Bitvector( instr(3 downto 2) );
                    aluCtrl(1) <= '1';

                    counter <= x"00";

                elsif instr(7 downto 4) = "0110" then --ST
                    if counter = x"02" then
                        report "ST " & integer'image( to_integer(unsigned(instr(3 downto 2)) ) ) & " " & integer'image( to_integer(unsigned(instr(1 downto 0)) ) );
                        case instr(3 downto 2) is
                            when "01" => opR2 <= "01";
                            when "10" => opR1 <= "01";
                            when "11" => aluCtrl <= "01";
                            when others => opR2 <= "00";
                        end case;
                        memOp <= "101"; -- set addr
                    elsif counter = x"03" then
                        memOp <= "111"; -- set data
        
                        case instr(1 downto 0) is
                            when "01" => opR2 <= "01";
                            when "10" => opR1 <= "01";
                            when "11" => aluCtrl <= "01";
                            when others => opR2 <= "00";
                        end case;
                        
                        counter <= x"00";
                    end if;
                elsif instr(7 downto 4) = "0111" then --LD
                    if counter = x"02" then
                        report "LD " & integer'image( to_integer(unsigned(instr(3 downto 2)) ) ) & " " & integer'image( to_integer(unsigned(instr(1 downto 0)) ) );
                        case instr(1 downto 0) is
                            when "01" => opR2 <= "01";
                            when "10" => opR1 <= "01";
                            when "11" => aluCtrl <= "01";
                            when others => opR2 <= "00";
                        end case;
                        memOp <= "101"; -- set addr
                    elsif counter = x"03" then
                        memOp <= "001"; -- get data
        
                        case instr(3 downto 2) is
                            when "01" => opR2 <= "10";
                            when "10" => opR1 <= "10";
                            when "11" => aluCtrl <= "10";
                            when others => opR2 <= "00";
                        end case;
                        
                        counter <= x"00";
                    end if;

                elsif instr(7 downto 2) = "000110" then --LDI
                    if counter = x"02" then
                        report "LDI " & integer'image( to_integer(unsigned(instr(1 downto 0)) ) );
                        pcOp <= "01";   -- get PC
                        memOp <= "101"; -- set addr
                    elsif counter = x"03" then
                        pcOp <= "11";   -- inc PC
                        memOp <= "001"; -- get data
        
                        case instr(1 downto 0) is
                            when "01" => opR2 <= "10";
                            when "10" => opR1 <= "10";
                            when "11" => aluCtrl <= "10";
                            when others => opR2 <= "00";
                        end case;
        
                        counter <= x"00";
                    end if;
                elsif instr(7 downto 2) = "000111" then --GPC R
                    report "GPC " & integer'image( to_integer(unsigned(instr(1 downto 0)) ) );
                    pcOp <= "01";   -- get PC

                    case instr(1 downto 0) is --set register value
                        when "01" => opR2 <= "10";
                        when "10" => opR1 <= "10";
                        when "11" => aluCtrl <= "10";
                        when others => opR2 <= "10";
                    end case;

                    counter <= x"00";
                elsif instr = x"FF" then --kill
                    assert false report "end of test, kill encounter" severity failure;
                else --NOP
                    report "unreferenced instr " & integer'image( to_integer(unsigned(instr) ) );
                    counter <= x"00";
                end if;
            end if;
        end if;

    end process;

end behaviour;