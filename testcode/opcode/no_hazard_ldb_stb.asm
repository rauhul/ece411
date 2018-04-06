ORIGIN 4x0000

SEGMENT CodeSegment:

    LEA R0, L_DATA_1
    LEA R2, L_DATA_2
    LEA R4, L_DATA_3
    LEA R6, L_DATA_4

    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDB R1, R0, 0
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOT R1, R1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STB R1, R0, 0

    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDB R1, R0, 1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOT R1, R1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STB R1, R0, 1

    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDB R3, R2, 0
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOT R3, R3
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STB R3, R2, 0

    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDB R3, R2, 1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOT R3, R3
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STB R3, R2, 1

    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDB R5, R4, 0
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
    STB R5, R4, 0

    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDB R5, R4, 1
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
    STB R5, R4, 1

    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDB R7, R6, 0
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
    STB R7, R6, 0

    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDB R7, R6, 1
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
    STB R7, R6, 1
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

L_DATA_1:
    DATA2 4x11EE
L_DATA_2:
    DATA2 4x33DD
L_DATA_3:
    DATA2 4x55BB
L_DATA_4:
    DATA2 4x7799
