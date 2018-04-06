ORIGIN 4x0000

SEGMENT  CodeSegment:
    ADD   R1, R0, -16 ; R1 =   -16
    ADD   R2, R0,  -9 ; R2 =    -9
    ADD   R3, R0,  -2 ; R3 =    -2
    ADD   R4, R0,   5 ; R4 =     5
    ADD   R5, R0,  12 ; R5 =    12
    ADD   R6, R0,  15 ; R6 =    15
    ADD   R7, R0,   0 ; R7 =     0
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    RSHFA R1, R1,   1 ; R1 =    -8
    RSHFL R2, R2,   3 ; R2 =  8190
    LSHF  R3, R3,   5 ; R3 =   -64
    RSHFA R4, R4,   7 ; R4 =     0
    RSHFL R5, R5,   9 ; R5 =     0
    LSHF  R6, R6,  11 ; R6 = 30720
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP

DONE:
    BRnzp DONE
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
