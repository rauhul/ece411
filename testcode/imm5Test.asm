ORIGIN 4x0000

SEGMENT  CodeSegment:

    ADD R1, R0, #1
    ADD R2, R1, #2
    ADD R3, R2, #3
    ADD R4, R3, #4
    ADD R5, R4, #5
    ADD R6, R5, #6

HALT:                   ; Infinite loop to keep the processor
    BRnzp HALT          ; from trying to execute the data below.
                        ; Your own programs should also make use
                        ; of an infinite loop at the end.