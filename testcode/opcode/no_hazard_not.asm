ORIGIN 4x0000

SEGMENT  CodeSegment:
    ADD  R1, R0, -16 ; R1 = -16
    ADD  R2, R0,  -9 ; R1 =  -9
    ADD  R3, R0,  -2 ; R1 =  -2
    ADD  R4, R0,   5 ; R1 =   5
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOT  R1, R1 ; R1 = 15
    NOT  R2, R2 ; R2 =  8
    NOT  R3, R3 ; R3 =  1
    NOT  R4, R4 ; R4 = -6
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


