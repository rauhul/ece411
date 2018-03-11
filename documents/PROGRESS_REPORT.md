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

