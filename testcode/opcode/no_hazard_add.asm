ORIGIN 4x0000

SEGMENT  CodeSegment:
    ADD  R1, R0, -16 ; R1 = -16
    ADD  R2, R0,  -9 ; R1 =  -9
    ADD  R3, R0,  -2 ; R1 =  -2
    ADD  R4, R0,   5 ; R1 =   5
    ADD  R5, R0,  12 ; R1 =  12
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
    ADD  R3, R3, R5  ; R1 =  -2 + 12 =  10
    ADD  R4, R4, R4  ; R1 =   5 +  5 =  10
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD  R5, R5, R3  ; R1 =  12 + 10 =  22
    ADD  R6, R6, R6  ; R1 =  15 + 15 =  30
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD  R7, R5, R6  ; R1 =  12 + 30 =  42
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
