ORIGIN 4x0000

SEGMENT  CodeSegment:

    TRAP ADDR_DONE
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

ADDR_DONE:
    DATA2 DONE