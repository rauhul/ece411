# final review

#### midterm 1 & 2 problems

!! 4 problems on cache + tlb interaction

!! estimating performance (combine cache and average memory acces latency)

- ask overall execution time

#### lecture 12 dynamic scheduling and recovery

##### support for speculation

!! problem

basic tomasulo cannot support this

needs intermediate stage

- Re-order buffer ROB
- not sure whether or not we need to update register with these results

##### hardware speculative execution

ROB can also be operand source

- regfile, reservation station, ROB

good slide for multiple choice question, what is true

all instructions are commited in order

##### four steps speculative tomasulo

solve number of cycles for execution

where is banch misprediction, which entires from ROB get flushed

same as slide format

##### speculative execution

Know all the bullets in this slide

writeback != commit

writeback storeing result in ROB

commit storing into regfile

- unrecoverable if you commit incorreclty

#### lecture 13 dynamic scheduling with renaming

centralized revervation center

more registers 

eleminate RAW/WAR cases (first dependencies, might be copied down wrong)

register alias table records results of instrucition immediately and knows mapping of regfile to alias entry

!! need to learn this

##### register renaming

problem just like slide

given set of instructions, show how registers are renamed and how things are stored

##### explicit register renaming vs reservation station

- advantages/disadvantages


still have ROB (just has mapping)

does not store executed buffer

#### lecture 14 IEEE flop

understand floating point representation

3 parts

- Sign
- exponent
- mantissa

!! convert into/from floating point <-> base 10

#### lecture 15 IO subsystem

most important concept memory mapped IO

ask about mmio vs programmed io

##### Programmed IO

Multiple choice problem

Requires special instructions

##### Communication method

how do we know device is done

- polling
- interupts

undersatnd differences, when do you want to use each one

when do you use both

- polling is only good when there are lots of requests
- heavy for the cpu if low number can reduce latency

interrupt good for infrequent 

bursts = good combination of both methods

initially interrupt based, then polls 

##### io data tranfer

how do transfer lots of data efficiently

cpu is stuck doing loads

change to use DMA (simple accelerator)

- os provides starting address and length of data to be transfered
- controller/device transfers data async to cpu
- interrupt on compeltion or error

how dma works for programming io and mmio

##### DMA issues addressing

biggest problem is virtual addresses

solutions

- pin to physical address, directly used physical address
  - dont translate
- every time data might be placed into different location, so used physical so page/translation doesnt change

caching issue

- DmA to mem, cache is stale
- Mem to DMA, dev gets stale data

solution

- before responding, need to flush cache
- mark pages as uncacheable

not hard problem

#### lecture 16 storage system

problem

determine disk latency + disk scheduling 

determine seek time, data transfer time

Look at slide disk performance examples

FIFO

- same order as request 
- pro
  - fair among requesters
- cons
  - dont know about order so seek time can be really bad

SSTF

- pick request thats closes to head on the disk 
- 2, 1, 3, 6, 2, 5
  - if we start at 5, then 5, 6, 3, 2, 2, 1
- con
  - can cause starvation where an earlier request doesnt get serviced untik much later
  - bad fairness

SCAN

- elevator operation
- up and down tracks
- 2, 1, 3, 6, 2, 5
- starting at 5 moving in
  - 5, 3, 2, 2, 1, 6
- low seek times
- but favors middle tracks, becuase it zig-zags
- no starvation

#### SSD

much faster, no moving parts

low energy

Lot of nand chips combined

has microcontroller

- DRAM buffer

latency = queuetime + controllertime + transfer time

##### writes

write takes much longer than read

can only write to clean/earsed blocks

Can only delete full block at a time not individual pages

write a b c d

write e f g h, a' b' c' d'

mark a b c d as obsolete

- get completely new block
- copy revelent data
- clean old block
- new block is more free space

!! one problem on how state of indivitual pages changes during writes

#### why multi-core

~hard to make single-core clock frequency higher

hard to extract more ILP b/c larger instruction windows are very expensive/slow/power-hungry

##### simultaneous multi threads SMT

multi threads can run concurrently 

each thread uses distinct free pipeline components

combine SMT with multicore

2-way SMT vs 2-core

- 2 physical cores are better
- physical cores will not have structural hazards/resource conflict

SMT sometime non-determinstic

- statistical applications will turn hyperthreading off

##### memory hierarchy

multichoice on pros/cons on private/shared caches

cache corherence is an issue, dont need to know much more

- get inconsistencies across cores
- no questions on this

!! ask about amdar's law, (parallelism)

$$
\text{speed up } \alpha \frac{1}{S + \frac{t}{N}}
$$

S is portition non parallelizable

t is parallelizeable

asymetric archecture to support this

- mix of big and little cores

20% s, 80% t -> one big core, couple small cores

- what configuration gives the best speedup

##### SIMD

why is SIMD more effiecient

specific archecture, what applications benefit

- know this

!! mutliple choice on slide WHY SIMD

##### exploiting TLP and SIMD

benefits

- multiple ALU -> one SIMD
- multi load/store -> one wide mem op

what are the overheads

high level GPU

- how to hide memory access latency (CPU) 
  - used OOO execution to mask this
- In-order processor
  - all threads are stalled by misses
- very very large regfile
  - each thread gets small subset of regfile


control divergence in thread-warp

- insert nops into threads that arent in the branch

##### VLIW 

key difference SIMD, single instruction shared by many execution units on different data

VLIW more like parallel process with many sub instructions within an instruction

Why?

- rely on complier to make the instructions more parallelizable
- nothing we use, uses this

used in embeded sometimes

- when the workload is very very well known

!! multiple choice pros/cons

#### lecture 20 impact of technology

predict how performance changes as die size reduces

table with scaling factors

one problem CMOSE inverter

multiple choice on device reliabillity 

transient faults SEU

- ​

Time dependent dieletric break down

- chip damaged permenantly 

large wasted voltage, b/c frequency is based on worst voltage flucuations

- why overclocking is possible
- becuase we can ignore this dip and take the potential errors/failures

##### V_ddmin challenges

SRAM needs minimum voltage

- failures if below
















