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
    AND  R1, R1,  15 ; R1 = 0
    AND  R2, R2,  15 ; R2 = 7
    AND  R3, R3,   6 ; R3 = 6
    AND  R4, R4,   7 ; R4 = 5
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    AND  R1, R1, R3  ; R1 = 0
    AND  R2, R2, R4  ; R2 = 5
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    AND  R1, R1, R2  ; R1 = 0
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
