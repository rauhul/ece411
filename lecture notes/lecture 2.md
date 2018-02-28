# lecture 2

#### instruction set architecture

interface between software and hardware

ISA is how software/programs can tell the hardware what actions to perform

#### instruction set design considerations

where are operands stored

-   registers, memory, stack, accumulator

how many operands per instruction (0-N)

how do you specify an operand

-   register, immediate value, indirect value

what sizes and types of operands are supported

-   byte, int, float, double, etc

what operations are supported

-   Add, subtract, multiply etc

#### instruction length

-   variable
    -   x86, instructions are 1-17 bytes long
    -   VAX, 1- 54 bytes
    -   require mutlistep fetch and decode, due to the complex instruction formats
    -   allows for smaller binary programs that use very specific instructions
    -   less DRAM at runtime, lower required memory and bandwidth and better cache efficieny 
-   fixed
    -   MIPS, PowerPC and most RISCs, all instructions are 4 bytes long
    -   really simple fetch and decode 
    -   simplifies pipelining and parallelism
    -   however, requires more space for the same program vs CISC, basiclaly opposite of CISC
-   memory/disk usage matters because its relatively slow compared to registers

#### ARM case study

Advanced RISC machine

started with fixed 32 bit instructions

added thumb instructions, 16 bit instructions, converted to 32 bit when fetched

only has 8 general purpose registers

motivated by embedded aplications with little memory and low memory bandwidth

#### how many registers

small set of registers

-   hold values that will be used soon
-   usually instructions use 2 to 3 registers

fewer registers

-   fewer bits to specify which to use
-   less hardware
-   faster access (fewer gates, faster combinational logic)
-   faster context switch (saving registers, fewer to save)

more registers

-   fewer load/stores to memory (slow operation)
-   easier to express several operations in parallel

#### where operands reside

stack machine

-   push
    -   loads memory into 1st register
    -   top of stack
    -   moves other registers down
    -   presumably moves the last register value out to memory
    -   can just be a stack in memory
-    pop
    -   opposite of push
-   add combines the top two registers and moves registers up

accumulator machine

-   only one register called the accumulator 
-   Instructions for store and sum ie
    -   ACC <- ACC + MEM

register-memory machine

-   arithmetic instructions can use data in registers or in memory directly

register-register machine

-   arithmetic instructions can only use data in registers

#### operand locations in ISA classes

![IMG_F748186339DE-1](/Users/rauhul/Downloads/IMG_F748186339DE-1.jpeg)

#### comparing ISA classes

given this code: `C = A + B`

| stack machine                          | accumulator                    | register-memory                            | register-register                                            |
| -------------------------------------- | ------------------------------ | ------------------------------------------ | ------------------------------------------------------------ |
| PUSH A<br />PUSH B<br />ADD<br />POP C | LOAD A<br />ADD B<br />STORE C | LOAD R1, A<br />ADD R1, B<br />STORE C, R1 | LOAD R1, A<br />LOAD R2, B<br />ADD R3, R1, R2<br />STORE C, R3 |

given this code: `A = X*Y + X*Z`

| stack machine                                               | accumulator                               | register-memory                                           | register-register                                            |
| ----------------------------------------------------------- | ----------------------------------------- | --------------------------------------------------------- | ------------------------------------------------------------ |
| PUSH Y<br />PUSH Z<br />ADD<br />PUSH X<br />MUL<br />POP A | LOAD Y<br />ADD Z<br />MUL X<br />STORE A | LOAD R1, Y<br />ADD R1, Z<br />MUL R1, X<br />STORE A, R1 | LOAD R1, Y<br />LOAD R2, Z<br />LOAD R3, X<br />ADD R4, R1, R2<br />MUL R4, R4, R3<br />STORE A, R4 |

#### general purpose registers

-   registers are much faster to access than memory
-   no stall when memory isnt ready
-   require fewer bits to reference
    -   more compact code
-   compiler can assign variables to registers, no need to ever be stored in memory

#### stack machine

example: `A * B - (A + C * B)`

```assembly
PUSH A
PUSH B
MUL
PUSH A
PUSH C
PUSH B
MUL
ADD
SUB [TOS-1] - [TOS] #not sure why this is backwards
```

pros

-   code is dense
    -   all ops implicitly reference the top of the stack so no bits are waste describing the destination
-   little required hardware to implement
-   easy to make simple compiler (not necessarily smart)

cons

-   stack is the bottlenck
-   little to no abillity for parallelism/pipelining
-   data isnt always at the top of the stack so instructions like top/swap are required
-   difficult to write a smart compiler

#### accumulator machine

example: `A * B - (A + C * B)`

```assembly
LOAD C
MUL B
ADD A
STORE D
LOAD A
MUL B
SUB D
```

pros

-   similar to stack, low hardware requirements
    -   easy to understand
-   no bit required to define destination becuase there is only one register

cons

-   accumulator is the bottleneck
-   little to no ability for parallelism/pipelining
-   high memory traffic

#### memory-memory architecture

example: `A * B - (A + C * B)`

3 Operand
```assembly
MUL D A B
MUL E C B 
ADD E E A
SUB D D E
```
2 Operand
```assembly
MOV D A
MUL D B
MOV E C
MUL E B
ADD E A
SUB E D #not sure why this is backwards
```

pros

-   very fewer required instructions (esp for 3 operands)
-   easy to write compilers

cons

-   Super high memory traffic (esp for 3 operands)
-   variable number of clock cycles per instruction
-   lots of memory acceses for 2 operand

#### register-memory machine

example: `A * B - (A + C * B)`

```assembly
LOAD R1 A
MUL R1 B
STORE D R1
LOAD R2 B
MUL R2 C
ADD R2 A
SUB R2 D #not sure why this is backwards
```

pros

-   data can be accessed without needing to be loaded first
-   instructions easy to encode + good code density

cons

-   operands are not equivalent
-   variable number of clocks per instruction
-   limit number of registers

#### register-register machine

example: `A * B - (A + C * B)`

```assembly
LOAD R1 A
LOAD R2 B
LOAD R3 C
MUL R3 R3 R2
ADD R3 R3 R1
MUL R1 R1 R2
SUB R1 R1 R3
```

pros

-   simple, fixed length instructions
-   instrucitons all take roughly the same number of cycles
-   relatively easy to pipeline and make superscalar

cons

-   more instructions for the same code
-   Not all instructions need 3 operands
-   requires smart compiler

cannot do `R1 = R2 + m[addr]`, this leads to more instructions, but also makes it easier to pipeline

#### registers vs memory

advantages

-   faster than cache or memory
-   deterministic (no cache misses)
-   allows for multiple read ports
-   short identifier (few bits required to specify the register)
-   reduce memory traffic

disadvantages

-   have to save/restore on context switch
-   cannot use pointers to registers
-   fixed size make storing strings/structs bad
-   need a smart compiler
-   limited quantity

#### word oriented memory organization

// byte addressible, can access byte (8), half (16), word (32), double (64)

#### byte ordering

big endian, least significant byte has the highest address

-   0x44332211 @ 0x0


-   0x0 @ 0x44; 0x1 @ 0x33; 0x2 @ 0x22; 0x3 @ 0x11

little endian, least significant byte has the lowest address 

-   0x44332211 @ 0x0


-   0x0 @ 0x11; 0x1 @ 0x22; 0x2 @ 0x33; 0x3 @ 0x44

#### releative frequency of control instructions

| Operation   | SPECint92 | SPECfp92 |
| ----------- | --------- | -------- |
| Call/Return | 13%       | 11%      |
| Jumps       | 6%        | 4%       |
| Branches    | 81%       | 87%      |

design hardware to handle branches efficiently because they are the most frequenct control instruction

#### instruction formats

// doesnt really matter, MIPS vs LC-3b, MIPS opcode defines format

only thing that matters is that it must be fast to decode, more formats can slow this down, tradeoff here

#### conditional branching

theoretically you could branch to any address (16bits in LC-3b). however studies show that branches are usually very short jumps from the PC so we can use a relative offset from the PC instead and use much fewer bits

use condition codes to determine branching, in MIPS beq, bne, etc

#### jumps

sometimes we need to jump to an address with all 16 bits or most, can be used during procedure calls and returns.