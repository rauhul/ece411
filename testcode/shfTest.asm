ORIGIN 4x0000

SEGMENT CodeSegment:

    LDR   R1, R0, VAL1
    LSHF  R2, R1, 3
    RSHFL R3, R1, 3
    RSHFA R4, R1, 3
    LDR   R1, R0, VAL2
    LSHF  R2, R1, 3
    RSHFL R3, R1, 3
    RSHFA R4, R1, 3

HALT:                   ; Infinite loop to keep the processor
    BRnzp HALT          ; from trying to execute the data below.
                        ; Your own programs should also make use
                        ; of an infinite loop at the end.

VAL1:
    DATA2 4xAAAA
VAL2:
    DATA2 4x5555
