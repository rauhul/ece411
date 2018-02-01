ORIGIN 4x0000

SEGMENT CodeSegment:

    LEA R0, L_DATA
    LDB R1, R0, 0
    LDB R2, R0, 1

HALT:             ; Infinite loop to keep the processor
    BRnzp HALT    ; from trying to execute the data below.
                  ; Your own programs should also make use
                  ; of an infinite loop at the end.

L_DATA:
    DATA2 4xAABB
