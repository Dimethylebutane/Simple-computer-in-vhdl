SAP-1 inspired computer;
First time using vhdl, if the code is ugly or un-optimized please tell it to me.
untested for fpga

# Documentation:

## RAM:
256 bytes
Instructions must be stored in ram before launching simulation
in memory.vhdl, just edit the initial ram content

## ISA:
    OpCode Dst, Src
- MV D, S : 0000 DD SS : Move data of register S to register D
- ST A, R : 0110 AA RR : Store data of register R to ram at adress pointed by register A
- LD R, A : 0111 AA RR : Load data from ram adress of register A to register R
- LDI R : 001_10 RR DDDDDDDD : load register R with value D
- GPC R : 0001_11 RR : load register R with program counter
- ALU OP, R : 0010 OO RR : X <- X Op R, Op the operation (see section ALU)
- JMP C, A, F : 010 C AA FF : jmp to adress stored in register A if a condition based on FF and C is verified (see section condition)

## Register:
    This computer has 4 register:
        R0 : always 0                           binary 00 in instruction
        R1 : general purpose Register           binary 01 in instruction
        R2 : general purpose Register           binary 10 in instruction
        X : accumulator, store result of ALU    binary 11 in instruction

note that because X is at the en of the ALU, MV and ST instruction will add the data to X

*yes I know that on the vhdl program, R2 is 01 and R1 is 10 but it's the same just a name*

## ALU:
    ALU support 3 operation:
        00 is +
        01 is -
        10 is and
        11 is or
    and set 2 flag: 
        Z if X = 0
        N if X < 0 (MSB = 1)

## Condition:
    This section is here to clarify the JMP instruction.

JMP C, A, F : 010 C AA FF

- FF in instruction is 2 bits, LSB is Z flag and MSB is N flag;
- C define the condition of the jump
- if a bit is set to 1, that means we care about this flag and want it to be equal to I to jump;

exemple:
    - if FF = 00 -> always jump \n
    - if I = 1 and FF = 01 -> jump if Z flag is set
    - if I = 0 and FF = 10 -> jump if N flag is not set
    - if I = 1 and FF = 11 -> jump if Z or N flag is set       ( not strict inequality )
    - if I = 0 and FF = 11 -> jump if Z and N flag are not set ( strict inequality )
            why and at this? if or -> if X=0 => Z=1 N=0 => jmp if null so not strict inequality

truth table:
    1 = jumping
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

# Critics

- Lack of output
- hard to program
- end with failure because I don't know how to do it properly ¯\_(ツ)_/¯
- only 256 bytes of ram
