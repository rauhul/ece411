SEGMENT  CodeSegment:

    ADD R0, R0 2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BRp LOOP
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

LOOP:
    ADD R0, R0, -1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP

    BRp LOOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP

    BRz LOOP2
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

LOOP2:
    ADD R0, R0, -2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP

    BRn DONE
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
    ADD R0, R0, 2
    BRnzp FAIL
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP

DONE:
    AND R0, R0, 0
    ADD R0, R0, 1
    BRnzp DONE
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
