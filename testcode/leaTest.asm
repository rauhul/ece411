ORIGIN 4x0000

SEGMENT  CodeSegment:

    AND R0, R0,   0 ;(0_0000)
    AND R0, R0,   0 ;(0_0000)
    AND R0, R0,   0 ;(0_0000)
    AND R0, R0,   0 ;(0_0000)
    AND R0, R0,   0 ;(0_0000)
    LEA R0, HALT
    AND R0, R0,   0 ;(0_0000)
    AND R0, R0,   0 ;(0_0000)
    AND R0, R0,   0 ;(0_0000)
    AND R0, R0,   0 ;(0_0000)
    AND R0, R0,   0 ;(0_0000)

HALT:                   ; Infinite loop to keep the processor
    BRnzp HALT          ; from trying to execute the data below.
                        ; Your own programs should also make use
                        ; of an infinite loop at the end.
