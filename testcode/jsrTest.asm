ORIGIN 4x0000

SEGMENT  CodeSegment:

    LEA R3, JUMP1
    AND R0, R0,   0 ;(0_0000)
    AND R0, R0,   0 ;(0_0000)

    JSR JUMP0
    AND R0, R0,   0 ;(0_0000)
    AND R0, R0,   0 ;(0_0000)

HALT0:
    BRnzp HALT0

JUMP0:
    AND R0, R0,   0 ;(0_0000)
    AND R0, R0,   0 ;(0_0000)
    JSRR R3

HALT1:
    BRnzp HALT1

JUMP1:
    AND R0, R0,   0 ;(0_0000)
    AND R0, R0,   0 ;(0_0000)

HALT2:              ; Infinite loop to keep the processor
    BRnzp HALT2     ; from trying to execute the data below.
                    ; Your own programs should also make use
                    ; of an infinite loop at the end.
