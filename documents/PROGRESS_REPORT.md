# Progress Report

> Exact details can be found in the [commit logs](https://gitlab.engr.illinois.edu/ece411_mp3_sp2018/ece411_team_3/commits/dev)

## Checkpoint 1
Mar 7, 2018 – Mar 11, 2018

We completed all instructions required for this checkpoint (ADD, AND, NOT, LDR, STR, and BR) with pipeline support for most.
As it stands the cpu should support all register/memory operations, however the jump logic and design still needs to be fleshed out. 

We tested each of the simple ALU instructions first using our own test cases, these can be found in the [testcode](https://gitlab.engr.illinois.edu/ece411_mp3_sp2018/ece411_team_3/tree/master/testcode) folder.
A segment of the add test is seen here
``` asm
SEGMENT  CodeSegment:

   ADD  R1, R0, -16 ; R1 = -16
   ADD  R2, R0,  -9 ; R1 =  -9
...
   ADD  R6, R0,  15 ; R1 =  15
   ADD  R7, R0,   0 ; R1 =   0
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   ADD  R1, R1, R7  ; R1 = -16 +  0 = -16
   ADD  R2, R2, R6  ; R1 =  -9 + 15 =   6
```
We used these simple testcases to help identify and easily fix bugs in our pipeline and control rom.

After ensuring that ADD, AND, and NOT worked properly, we used the checkpoint 1 code as testcode for LDR, STR, and BR.
We wrote down what every relev1nt signal was before stepping through the program execution in modelsim and checked against our hand simulation.
This allowed us to very quickly identify errors and fix them.

- Rauhul primarily worked on the pipline
- Kyung Jae assisted with the pipeline and helped test it
- WonJae worked on how the caches will fit into the pipeline for the next checkpoint

## Checkpoint 2
Mar 12, 2018 – Mar 18, 2018

We updated our pipeline to handle all of the LC3b instructions. We also implemented a split L1 caches to cache instructions and data; additionally we implemented an arbiter to connect these caches to physical memory, the arbiter also introduces a cycle delay to prevent a critical path from extending from our L1 caches to the physical memory.

We tested every LC3b instruction individually against test code specifically designed to exercise that instruction. We then walked through all 1000+ lines of the mp3cp2b test code, and annotated 15000+ ns of simulation while comparing against expected results. We ensured that every instruction works exactly as spec'd before integrating the caches.

After adding the caches we tested each instruction again and then ran through the mp3cp2a test code and annotated it as well. After passing all of those tests, we re-ran through all of the mp3cp2b test code ensuring every instruction worked exactly as expected.

- Rauhul wrote the test cases, updated the pipeline for new instructions, implemented the caches, and tested everything
- Kyung Jae worked on the data forwarding diagram and how it will into the pipeline for the next checkpoint

## Checkpoint 3
Mar 19, 2018 – Apr 8, 2018

We updated the pipeline to detect and handle control, data, and structural hazards. We also refactored the cache design so the number of lines and associativity can be chosen during module instantiation. As a result the d_cache is been expanded to contain 8 cache lines with 4-way set associativity. Additionally, we have added a unified L2 cache with 8 cache lines with 8-way set associativity.

We also refactored the way stalls and resets are propogated through the pipeline. We now use a (purely combinational) stall arbiter to take pipeline control requests from the various subcomponents that can modify the pipeline's execution and based on preassigned priority/exclusivity propgate those signals to the pipeline.

During this checkpoint, we used all the tests from previous checkpoints as regression tests. We also identified the locations in the checkpoint 3 code, that would cause issues in checkpoint 2 pipeline and used them as small unit tests for our checkpoint 3 implementation.

- Rauhul redesigned the caches for parameterized instantiation, implemented the control hazard detection, implemented data forwarding, redeisgned the pipeline control propogation, created the branch prediction/eviction write buffer/performance counters design diagrams, and tested everything
- Kyung Jae started the data forwarding logic

## Checkpoint 4
Mar 9, 2018 – Apr 15, 2018

This week we added 3 features to our pipeline, a set of software-visible performance counters, an eviction write buffer and static branch prediction.

We added the performance counters to our stage_MEM, so that they can intercept reads and writes to the memory addresses assigned to each counter. Each counter is accessible through its assigned memory address and can be read via a load instruction and reset via a store instruction.

We added an eviction write buffer to our L2 cache, which allows new cache data to be read into the cache before the writeback occurs. We also cache miss and hit signals coming from all the caches, these signals are consumed by the performance counters.

Lastly we refactored the branch_controller to take a prediction from the branch_predictor and handle correct and incorrect predictions. Additionally it reports whether or not the prediction was correct, these signals are consumed by the performance counters.

- Rauhul implemented the performance counters, eviction write buffer, static branch prediction, wrote the testcode and tested the design.
