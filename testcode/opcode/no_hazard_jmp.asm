ORIGIN 4x0000

SEGMENT  CodeSegment:

    LEA R0, DONE
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JMP R0
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BRnzp FAIL
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP

FAIL:
    AND R0, R0, 0
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R0, R0, 2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BRnzp FAIL
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP

DONE:
    AND R0, R0, 0
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R0, R0, 1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BRnzp DONE
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
