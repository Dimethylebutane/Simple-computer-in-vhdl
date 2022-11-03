SAP-1 inspired computer;<br/>
First time using vhdl, if the code is ugly or un-optimized please tell it to me. Untested for fpga.<br/>
First time with a public repos, idk how it works.

# Documentation:

## RAM:
- 256 bytes
- Instructions must be stored in ram before launching simulation. In memory.vhdl, just edit the initial ram content

## ISA:

    OpCode Dst, Src
- MV D, S : 0000 DD SS : Move data from register S to register D
- ST A, R : 0110 AA RR : Store data from register R to ram at adress stored by register A
- LD R, A : 0111 AA RR : Load data from ram (adress in register A) to register R
- LDI R : 000110 RR DDDDDDDD : load register R with value D
- GPC R : 000111 RR : load register R with program counter
- ALU OP, R : 0010 OO RR : X <- X Op R, Op the operation (see section ALU)
- JMP C, A, F : 010 C AA FF : jmp to adress stored in register A if a condition based on FF and C is verified (see section condition)

## Register:
    This computer has 4 register:
        R0 : always 0                           binary 00 in instruction
        R1 : general purpose Register           binary 01 in instruction
        R2 : general purpose Register           binary 10 in instruction
        X : accumulator, store result of ALU    binary 11 in instruction

note that because X is at the end of the ALU, MV, LD, LDI, and GPC instructions will add the data to X

*yes I know that on the vhdl program, R2 is 01 and R1 is 10 but it's the same just a name*

## ALU:
    ALU can do 3 operations:
        00 is +
        01 is -
        10 is and
        11 is or
    and set 2 flag: 
        Z if X = 0
        N if X < 0 (MSB = 1)
        
exemple: <br/>
    ALU +, R1 => 0010 00 01

## Condition:
    This section is here to clarify the JMP instruction.

JMP C, A, F : 010 C AA FF

- FF in instruction is 2 bits, LSB is Z flag and MSB is N flag;
- C define the condition of the jump (it negate the condition)
- if a bit is set to 1, that means we care about this flag and want it to be equal to I to jump;

exemple:<br/>
    - if FF = 00 -> always jump <br/>
    - if C = 1 and FF = 01 -> jump if Z flag is set             ( X = 0 )<br/>
    - if C = 0 and FF = 10 -> jump if N flag is not set         ( X >= 0 )<br/>
    - if C = 1 and FF = 11 -> jump if Z or N flag is set        ( X <= 0 )<br/>
    - if C = 0 and FF = 11 -> jump if Z and N flag are not set  ( X > 0 )<br/>
            note: not(a or b) = not(a) and not(b)

truth table:
    1 = jumping <br/>
    0 = not jumping

    if I = 1:
            Flag \ FF | 00 | 01 | 11 | 10
            -----------------------------
                   00 | 1  | 0  | 0  | 0
                   01 | 1  | 1  | 1  | 0
                   11 | 1  | 1  | 1  | 1
                   10 | 1  | 0  | 1  | 1
    if I = 0:
            Flag \ FF | 00 | 01 | 11 | 10
            -----------------------------
                   00 | 1  | 1  | 1  | 1
                   01 | 1  | 0  | 0  | 1
                   11 | 1  | 0  | 0  | 0
                   10 | 1  | 1  | 0  | 0


## random information

**By default, test_bench limits simulation time to avoid infinite loop, see test_bench.vhdl line 97**

Fetching an instruction takes 2 clk cycles, <br/>
Longest instructions (ST, LD, and LDI) are 4 clk cycles long in total (fetch + execute), others are 3 clk cycles. <br/>

Control unit works at falling edge of clk, other modules at rising edge. <br/>
Due to the implementation, bus content is set at falling edge of clk because getting data out of modules is independant of clk.


# Critics

- Lacks of output
- Hard to program
- End with failure because I don't know how to do it properly ¯\\_(ツ)_/¯
- Only 256 bytes of ram
