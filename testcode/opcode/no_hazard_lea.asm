ORIGIN 4x0000

SEGMENT  CodeSegment:

    LEA  R1, T_1 ; R1 = 0x0e
    LEA  R2, T_2 ; R2 = 0x10
    LEA  R3, T_3 ; R3 = 0x12
    LEA  R4, T_4 ; R4 = 0x14
    LEA  R5, T_5 ; R5 = 0x16
    LEA  R6, T_6 ; R6 = 0x18
    LEA  R7, T_7 ; R7 = 0x1a
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

T_1: NOP
T_2: NOP
T_3: NOP
T_4: NOP
T_5: NOP
T_6: NOP
T_7: NOP
