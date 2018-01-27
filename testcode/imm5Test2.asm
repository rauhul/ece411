ORIGIN 4x0000

SEGMENT  CodeSegment:

    LDR R1, R0, FFFF

    AND R2, R1, #0  ;(0_0000)
    ADD R3, R1, #16 ;(1_0000)
    ADD R4, R1, #21 ;(1_0101)

HALT:                   ; Infinite loop to keep the processor
    BRnzp HALT          ; from trying to execute the data below.
                        ; Your own programs should also make use
                        ; of an infinite loop at the end.

FFFF:   DATA2 4xFFFF