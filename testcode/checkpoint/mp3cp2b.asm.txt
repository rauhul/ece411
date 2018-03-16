SEGMENT CodeSegment:    ; Version 0.11  1/13/2005
    LEA R0, DataSegment
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BRnzp skip
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
SEGMENT DataSegment:
ZERO:       DATA2 0
ONETWELVE:  DATA2 112
ENT:        DATA2 10
NINER:      DATA2 9999
GECKO:      DATA2 42
NOT6:       DATA2 4xBAC8
THREE:      DATA2 7
TREE:       DATA2 3
BADBAD:     DATA2 4x0BAD
PAT1:       DATA2 4x0D0D
PAT2:       DATA2 4x9884
PAT3:       DATA2 4xAE85
GOOD:       DATA2 4x5460
five:       DATA2 5
TT:         DATA2 4x646
RES1:       DATA2 0
RES2:       DATA2 0
RES3:       DATA2 0
RES4:       DATA2 0
RES5:       DATA2 0
RES6:       DATA2 0
RES7:       DATA2 0
RES8:       DATA2 0
RES9:       DATA2 0
RES10:      DATA2 0
RES11:      DATA2 0
RES12:      DATA2 0
RES13:      DATA2 0
RES14:      DATA2 0
RES15:      DATA2 0
RES16:      DATA2 0
Bear:       DATA2 CatchMe
Owl:        DATA2 paris

skip:
    LDR R1, R0, ZERO
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R2, R0, ONETWELVE
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R7, R0, ENT
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R1, R2, R7
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R3, R1, -4
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R1, R1, R3
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R1, R1, R1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R1, R0, RES1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R1, R0, NINER
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R2, R0, GECKO
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    AND R6, R1, R2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    AND R5, R6, 10
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R5, R0, RES2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R7, R0, NOT6
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOT R7, R7
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R7, R0, RES3
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R1, R0, PAT1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LSHF R2, R1, 4
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    RSHFL R3, R1, 2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LSHF R2, R2, 1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    RSHFL R3, R3, 1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R2, R2, R3
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R2, R2, 1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    RSHFA R4, R1, 3
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R1, R0, PAT2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    RSHFA R5, R1, 6
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R2, R0, RES4
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R4, R0, RES5
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R5, R0, RES6
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LEA R1, RES7
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R1, R0, RES8
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R5, R5, 13
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STI R5, R0, RES8
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R1, R0, TREE
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R2, R0, THREE
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    AND R3, R3, 0
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
loop1:
    ADD R2, R2, 5
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R1, R1, -1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BRp loop1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
loop2:
    ADD R1, R1, 7
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R2, R2, -6
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BRp loop2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BRz loop1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BRn miami
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R2, R0, five
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
miami:
    ADD R2, R2, R1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R2, R0, RES8
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R6, R0, ZERO
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JSR dallas
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R6, R0, RES9
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    AND R5, R5, 13
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LEA R3, portland
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JMP R3
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R5, R0, BADBAD
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
portland:
    STR R5, R0, RES10
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R5, R0, BADBAD
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    TRAP Bear
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R5, R0, RES11
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    AND R1, R1, 0
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R1, R1, 8
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R1, R1, 9
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDB R2, R0, PAT3
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDB R3, R1, PAT3
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R4, R3, R2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R4, R0, RES12
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R2, R2, 11
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R3, R3, -2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LEA R1, DataSegment2
    ;the following STB instructions store to mem[RES17]
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BRnzp skip2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP

SEGMENT DataSegment2:
TS:     DATA2 4x646
RES17:  DATA2 0
RES18:  DATA2 0
RES19:  DATA2 0
CatchMe:
    LDR R5, R0, PAT3
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOT R5, R5
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    RET
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
OverHere:
    LDR R3, R0, GOOD
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R1, R1, R3
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    RET
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP

skip2:
    STB R2, R1, 3
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STB R3, R1, 2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R4, R1, RES17
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R4, R0, RES13
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LEA R3, TS
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R3, R0, RES15
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDI R3, R0, RES15
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R3, R0, RES14
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
SEGMENT CodeSegment2:
    LEA R4, DataSegment4
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R2, R4, Indy
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R2, R2, 3
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    AND R1, R1, 0
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ; To test self-modifying code, uncomment
    ; the following lines and use the first 'Indy'
    ; STR R2, R4, Indy
    ; NOP
    ; NOP
    ; NOP
    ; NOP
    ; NOP
    ; NOP
SEGMENT DataSegment4:
; Indy:
;     ADD R1, R1, 9
Indy:
    ADD R1, R1, 12
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R1, R0, RES16
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R1, R0, 1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R3, R1, PAT3
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LEA R6, DataSegment2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R3, R6, RES17
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R1, R0, PAT3
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BRn Nati
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    TRAP Owl
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
Nati:
    LDR R1, R0, BADBAD
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LEA R2, OverHere
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JSRR R2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R1, R6, RES18
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R1, R0, 2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    AND R6, R6, 0
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BRz dulles
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R1, R1, R1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
dulles:
    LEA R6, DataSegment2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R1, R6, RES19
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP

bloomington:
    LEA R5, DataSegment3
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R6, R5, DSP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R0, R6, RES1
    LDR R1, R6, RES2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JSR atlanta
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R1, R6, RES3
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JSR atlanta
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R0, R5, CS1
    LDR R0, R6, RES4
    LDR R1, R6, RES5
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JSR atlanta
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R1, R6, RES6
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JSR atlanta
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R0, R5, CS2
    LDR R0, R6, RES7
    LDR R1, R6, RES8
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JSR atlanta
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R0, R5, CS3
    LDR R0, R6, RES9
    LDR R1, R6, RES10
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JSR atlanta
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R0, R5, CS4
    LDR R0, R6, RES11
    LDR R1, R6, RES12
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JSR atlanta
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R0, R5, CS5
    LDR R0, R6, RES13
    LDR R1, R6, RES14
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JSR atlanta
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R0, R5, CS6
    LDR R0, R6, RES15
    LDR R1, R6, RES16
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JSR atlanta
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R0, R5, CS7
    LDR R6, R5, DS2P
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R0, R6, RES17
    LDR R1, R6, RES18
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JSR atlanta
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R1, R6, RES19
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JSR atlanta
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R0, R5, CS8
    LEA R7, DataSegment3
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R0, R7, CS1
    LDR R1, R7, CS2
    LDR R2, R7, CS3
    LDR R3, R7, CS4
    LDR R4, R7, CS5
    LDR R5, R7, CS6
    LDR R6, R7, CS7
    LDR R7, R7, CS8
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
Nowhere:
    BRnzp nowhere
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP

SEGMENT DataSegment3:
NINE:       DATA2 4x0009
BIGNUMBER:  DATA2 4x70CF
BYP1:       DATA2 4x0000
BYP2:       DATA2 4x0000
CS1:        DATA2 4x0000
CS2:        DATA2 4x0000
CS3:        DATA2 4x0000
CS4:        DATA2 4x0000
CS5:        DATA2 4x0000
CS6:        DATA2 4x0000
CS7:        DATA2 4x0000
CS8:        DATA2 4x0000
DSP:        DATA2 DataSegment
DS2P:       DATA2 DataSegment2

dallas:
    NOT R6, R7
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    RET
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
atlanta:
    AND R2, R0, R1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOT R2, R2
    NOT R0, R0
    NOT R1, R1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    AND R0, R0, R1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOT R0, R0
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    AND R0, R0, R2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    RET
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
paris:
    LDR R1, R0, BADBAD
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDB R1, R0, NINER
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDB R2, R0, GECKO
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R3, R0, THREE
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R4, R0, ZERO
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
