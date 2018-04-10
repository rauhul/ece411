# midterm 2 review

eceb 1002 7:30 tuesday

5 big questions

2 bonus questions

### lecture 7, virtual memory

##### understand advantages

- translation
  - pretend like you have a much larger memory space
- protection
  -  ​
- sharing
  - map the same physical page to mutliple user
  - shared libraries do not have to included by each program

##### understand translation process

-  virtual address contains
  - page number and offset
- translated to a physical page and offset
  - using a mmu, translates virtual page to physical page
- virual and physcial memeory share the same page size

##### page table structure 
one-to-one maping

- Large pages
  - size of the table is larger than the actual memory available
- use small pages with a multi level table so we dont need to load the entire table at once

##### handle page faults

Read/understand steps

##### tlb/cache

every memory access requires translation and two memory accesses

use translation look-aside buffer to cache translations

##### four different caching/virtual memoery
!! question on this

VIVT

- fastest cache access, no translation requried
- only need translation on miss
- issues
  - !!aliasing

PIPT

- need to translate before cache access
- Slowest, but no homonym/synonym problem

VIPT

- parallel access to TLB and 
- access data array and tag array with virtual tag
  - translate tag while while this is happening (using tlb)

### lecture 8, pipeline

!! understand multicycle cpu vs pipeline cpu

same latency (little worse), much higher throughput

- mutliple instructions in flight, none complete
- try to maximize utilization of pipeline resources

##### !! how much speed up

- overall speed up = #stages as intructions become large
- each instruction speed up
- speed up improves as stages increase, however eventually flip flop overhead becomes the limitting factor

##### hazard

structure hazard

- required resource is busy
- example one cache, contention bewteen instruction memeory access and data memory access

data hazard

- need to wait for instruction to complete before executing next instruction
- next instruction must be stalled
- easy solution is to add nop's
- better solution is to forward to the required location
- forwarding does not remove all data hazards
  - for loads we have to wait another (or more) cycles to access the memory
- restructure code to reduce hazards

EXAM PROBLEM
$$
m = num instructions \\
n = num stages \\
num cycles = m + n - 1
$$

!! control hazard due to branches

- supposed to continously feed instructions
- couple solutions
- stall untill branch occurs
  - Bad - wasted cycles
- static branch prediction
  - assume branch not taken
    - how to implement
  - assume taken
    - how to implement
- delayed branch
  - LEARN

simplest branch prediction

- record what happened on last branch by address subset (ie 0x01244ef) -> 0xf
- use that to determine to do next

strong/weak

two level branch prediction

Generalized correlated branch predictor

- pattnered history table

per address history scheme

.

##### btb operaton

branch target buffer

- use pc for lookup
- cache for computed branch address

### lecture 10, improving energy efficiency

understand energy and power equations

Dynamic power, short circuit power, leakage power

how to reduce each component

- many logic gates
- use higher voltage for more important transitors
- power gating
  - turn off power to ip cores as needed

### lecture 11, instruction level paralleism

ILP with and without speculation

understand how to compute this value

tomoasulo's algorithm 

- issues, CDB at high speed
- precise exception issues
- speculative instuctions
  - brnach prediciton enlargers
  - no wheel buffer (in final exam)

EXAM QUESTION














