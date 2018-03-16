ORIGIN 4x0000

SEGMENT  CodeSegment:

    ADD R0, R0, 2
    LEA R1, MINUS_2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP

LOOP:
    JSR MINUS_1
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
    JSRR R1
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

MINUS_1:
    ADD R0, R0, -1
    RET
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP

MINUS_2:
    ADD R0, R0, -2
    RET
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
