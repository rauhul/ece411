ORIGIN 0
SEGMENT
CodeSegment:    ; Version 0.12  7/21/2014
    LEA R0, DataSegment
    LDR R1, R0, ZERO
    LDR R2, R0, ONETWELVE
    LDR R7, R0, ENT
    ADD R1, R2, R7
    ADD R3, R1, -4
    ADD R1, R1, R3
    ADD R1, R1, R1
    STR R1, R0, RES1
    LDR R1, R0, NINER
    LDR R2, R0, GECKO
    AND R6, R1, R2
    AND R5, R6, 10
    STR R5, R0, RES2
    LDR R7, R0, NOT6
    NOT R7, R7
    STR R7, R0, RES3
    LDR R1, R0, PAT1
    LSHF R2, R1, 4
    RSHFL R3, R1, 2
    LSHF R2, R2, 1
    RSHFL R3, R3, 1
    ADD R2, R2, R3
    ADD R2, R2, 1
    RSHFA R4, R1, 3
    LDR R1, R0, PAT2
    RSHFA R5, R1, 6
    STR R2, R0, RES4
    STR R4, R0, RES5
    STR R5, R0, RES6
    LEA R1, RES7
    STR R1, R0, RES8
    ADD R5, R5, 13
    STI R5, R0, RES8
    LDR R1, R0, TREE
    LDR R2, R0, THREE
    AND R3, R3, 0
loop1:  ADD R2, R2, 5
    ADD R1, R1, -1
    BRp loop1
loop2:  ADD R1, R1, 7
    ADD R2, R2, -6
    BRp loop2
    BRz loop1
    BRn miami
    LDR R2, R0, five
miami:  ADD R2, R2, R1
    STR R2, R0, RES8
    LDR R6, R0, ZERO
    JSR dallas
    STR R6, R0, RES9
    AND R5, R5, 13
    LEA R3, portland
    JMP R3
    LDR R5, R0, BADBAD
portland:
    STR R5, R0, RES10
    LDR R5, R0, BADBAD
    TRAP Bear
    STR R5, R0, RES11
    LEA R1, DataSegment
    ADD R1, R1, 1
    LDB R2, R0, PAT3
    LDB R3, R1, PAT3
    ADD R4, R3, R2
    STR R4, R0, RES12
    ADD R2, R2, 11
    ADD R3, R3, -2
    LEA R1, DataSegment2
        ;the following STB instructions store to mem[RES13]
        ;the offsets -7,-8 are used to overcome 6-bit signed offset limitation w/o creating a new Data Segment
    STB R2, R1, -7
    STB R3, R1, -8
    LDR R4, R0, RES13
    STR R4, R0, RES12
    LEA R3, TT
    STR R3, R0, RES15
    LDI R3, R0, RES15
    STR R3, R0, RES14
SEGMENT CodeSegment2:
    LEA R4, CodeSegment2
    LDR R2, R4, Indy
    ADD R2, R2, 3
    AND R1, R1, 0
    STR R2, R4, Indy
Indy:   ADD R1, R1, 9
    STR R1, R0, RES16
    ADD R1, R0, 1
    LDR R3, R1, PAT3
    LEA R6, DataSegment2
    STR R3, R6, RES17
    LDR R1, R0, PAT3
    BRzp paris
    LDR R1, R0, BADBAD
    LEA R2, OverHere
    JSRR R2
    STR R1, R6, RES18
    ADD R1, R0, 2
    LEA R6, CodeSegment
    BRz dulles
    ADD R1, R1, R1
dulles: LEA R6, DataSegment2
    STR R1, R6, RES19
FINISH: BRnzp FINISH

dallas: NOT R6, R7
    RET;
paris:  LDR R1, R0, BADBAD
    LDB R1, R0, NINER
    LDB R2, R0, GECKO
    LDR R3, R0, THREE
    LDR R4, R0, ZERO

SEGMENT        DataSegment:
ZERO:    DATA2 0
ONETWELVE:   DATA2 112
ENT:    DATA2 10
NINER:  DATA2 9999
GECKO:  DATA2 42
NOT6:   DATA2 4xBAC8
THREE:  DATA2 7
TREE:   DATA2 3
BADBAD: DATA2 4x0BAD
PAT1:   DATA2 4x0D0D
PAT2:   DATA2 4x9884
PAT3:   DATA2 4xAE85
GOOD:   DATA2 4x5460
five:   DATA2 5
TT: DATA2 4x646
RES1:   DATA2 0;
RES2:   DATA2 0;
RES3:   DATA2 0;
RES4:   DATA2 0;
RES5:   DATA2 0
RES6:   DATA2 0;
RES7:   DATA2 0;
RES8:   DATA2 0;
RES9:   DATA2 0;
RES10:  DATA2 0;
RES11:  DATA2 0;
RES12:  DATA2 0;
RES13:  DATA2 0;
RES14:  DATA2 0;
RES15:  DATA2 0
RES16:  DATA2 0;
SEGMENT DataSegment2:
RES17:  DATA2 0
RES18:  DATA2 0
RES19:  DATA2 0
Bear:   DATA2 CatchMe
CatchMe:LDR R5, R0, PAT3
    NOT R5, R5
    RET
OverHere:LDR R3, R0, GOOD
    ADD R1, R1, R3
    RET
PRODUCT:DATA2 0