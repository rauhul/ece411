# ECE 411 Midterm 1 review

ECEB 1002 7:30 pm Thursday

Up to lecture 7

Yes calculator 

## lecture 1

role of computer archect

exponentential increase of clock rate undertsand 3 reasons

-   und

why it has stagnated

  -   power
  -   temputature

$P=CV^2f$

understand dennard scaling

-   why dennard scaling ended
-   chip speed is porportional to capabillity

## lecture 2

ISA: serves as an interface b/w software and hardware

### Instruction Length

-   trade-off between SISC 
    -   variable length Instruction length
        -   limited memory <-> SISC + why are they related
        -   way more instructions, dont need a good compiler (ie high level semantics into assembly)
        -   compilers did not used to be good
    -   x86
-    and RISC
    -   fixed instrustion length
        -   all instructions are 4 bytes one
        -   Smaller instruction set, smarter compiler
        -   more instrucutions for the same `c` code, uses more memory
    -   MIPS

### Stacks

**!!** stack, accumulator, register (register-memory), register (load-store)

-   understand pros and cons
-   one will be given, need to come up with instructions for it

### General purpose registers

registers

-   advantages and disadvantages

## lecture 3

understand CPU performance equation 

$\frac{instructions}{program}*\frac{cycles}{instruction}*\frac{seconds}{cycle}$

computeing effective CPI

	- be able to do this

Evaluate effectivenes of architecture

-   determine applications
-   determine what to use as a benchmark

How to report performance

use geometric mean

-   arthimatic mean effected strongly by a single suit
-   geometric mean cannoted by strongly affected by a single test

**!!** Amdahl's Law

-   equation given
-   law of deminsioning returns
-   understand the rule

## lecture 4

instructions can 3 to 5 cycles (problem leveraging this)

flip-flop overhead

why can mutlicycle by faster

**!!** combine multicycle with effective CPI (compare single cycle with multicycle)

## lecture 5

types of memories

understand all slides

-   average memory access time
-   Hit time + miss rate * miss penality
    -   always have penalty for cache access even for miss
-   no 1-miss rate

memory hierarchy performance(41)

reducing penalty

-   usualy perfer cache architecture with low miss rate
-   everything has a cost
-   be able to do math for trade-offs
-   Consider miss rate and miss penalty

**!!** one question direct mapping

one big cache problem

-   given size of cache, direct map, 2 way, 4 way
-   calculate bits for tag, for index, for block offset,
-   given sequence addresses, decide if hit or miss
-   similar to quiz problem
-   **know** lru for any number of ways (4, 8, 16)

biggest porblem direct map cache

-   **3cs** (conflict misses and cache misses??, comply misses??)
-   set associative mapping, fewer conlifcted misses
    -   dont increase associativity too much
    -   adds more comparisions, makes slower

## lecture 6

replacement policies 

**!!** understand LRU policies 

-   for this memory access sequence what will be evicted



## other problems

2 mp assignment problems

first problem is LC3b ISA

second if debugging skills

-   given wave and assembly
-   identify first sign in the waveform that signals something is wrong

bonus problem

-   mp related
    -   implementing a given lc3b instruciton in verilog
-   HW1 related
    -   should be able to do this problem is you did hw1
