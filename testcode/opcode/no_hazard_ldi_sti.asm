ORIGIN 4x0000

SEGMENT CodeSegment:

    LEA R0, L_DATA_PTR_S
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDI R1, R0, 0
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDI R2, R0, 1
    LDI R3, R0, 2
    LDI R4, R0, 3
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOT R1, R1
    NOT R2, R2
    NOT R3, R3
    NOT R4, R4
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STI R1, R0, 0
    STI R2, R0, 1
    STI R3, R0, 2
    STI R4, R0, 3
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

L_DATA_PTR_S:
    DATA2 L_DATA_1
    DATA2 L_DATA_2
    DATA2 L_DATA_3
    DATA2 L_DATA_4

L_DATA_1: DATA2 4x11EE
L_DATA_2: DATA2 4x33DD
L_DATA_3: DATA2 4x55BB
L_DATA_4: DATA2 4x7799
