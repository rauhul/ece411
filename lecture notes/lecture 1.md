# lecture 1 notes

#### what is computer architecture?

hardware organization of computers including the Instruction Set Architecture (ISA)

role of computer architects is to make design trade-offs across hardware-software interface to satisfy functional performance, power/engery, and cost requirements 

#### processor architecture 

clock rates increased exponentially from 1990 to 2008 due to:

-   improvements to semiconductor manufacturing and technology
-   deeper piplines
-   better circuit design techniques

This trend sagnated over the last 10 years (clock rates would be around 30 GHz)

#### power efficiency challenges

// doesnt matter, things need to be more efficient due to mobile devices

#### classic Dennard's scaling

every generation physical transistor size decreases 

-   0.7x per edge 
    -   2.0x density
-   1.4x times as fast per transistor
-   overal 2.8x speed
-   $\sqrt{2}^3=2.828$

since $P=CfV^2$

-   voltage and current are porportional to the linear dimensions of a tansistor
-   capacitance is a function of area
-   $P=(\frac{\sqrt{2}}{2})^3=0.3535$
-   overally power remains constant $0.3535*2.828 = 1$

#### end of Dennard's scaling

every generation physical transistor size decreases 

-   0.7x per edge 
    -   2.0x density
-   but transistors could not be opperated at higher frequencies with same power
-   NOT SURE WHY: led to only 1.4x speed increase 

#### computing landscape and challenges

diminishing returns on GP-CPU systems

moving towards GPGPU computing

#### emerging apps and characteristics

// doesnt matter

#### Von-Nuemann computrer organization

Processor

-   connects to extneral memory
-   internally contains a control unit with
    -   program counter
    -   instruction register
-   and a datapath with
    -   register file and alu used for computation
-   executres instructions which are expressed as bit patners with various ranges used as specific idenitifiers
-   can access random memory by address
-   time per access is independent of address
-   Connects to IO through memory
    -   Keyboard, mouse, display, network
    -   Long term data storage

#### instruction execution cycles

-   fetch
    -   fetch instruction from program storage (main memory)
-   decode
    -   decode the fetched instruction and determine the required actions
-   fetch operand
    -   locate and obtain operand data
-   execute
    -   compute result of instruction
-   store result
    -   places the result of the computation into the desired location

#### LC-3b instrustion set encoding 

instructions are 16 bits long

-   opcode is upper 4 bits
    -   simpiler than commerical ISAs, which can gave mutliple opcode formats for different types of instrucitons
-   few instruction formats
    -   Does not vary much, if at all, between opcodes

// explaination of RTL

// various descriptions of opcodes, should already know from mps/ece385

