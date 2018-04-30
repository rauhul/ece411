ORIGIN 4x0000

SEGMENT  CodeSegment:

    LDR  R1, R0, I_1
    LDR  R2, R0, I_2
    LDR  R3, R0, I_3
    LDR  R4, R0, I_4
    LDR  R5, R0, I_5
    LDR  R6, R0, I_6
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR  R1, R0, O_1
    STR  R2, R0, O_2
    STR  R3, R0, O_3
    STR  R4, R0, O_4
    STR  R5, R0, O_5
    STR  R6, R0, O_6
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

I_1:  DATA2 4xDEAD
I_2:  DATA2 4xBEEF
I_3:  DATA2 4xFEA5
I_4:  DATA2 4x1B1E
I_5:  DATA2 4x11FE
I_6:  DATA2 4xB10D

O_1:  DATA2 4x0000
O_2:  DATA2 4x0000
O_3:  DATA2 4x0000
O_4:  DATA2 4x0000
O_5:  DATA2 4x0000
O_6:  DATA2 4x0000