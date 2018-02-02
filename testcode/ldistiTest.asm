ORIGIN 4x0000

SEGMENT CodeSegment:

    LDI R1, R0, L_DATA_PTR
    NOT R1, R1
    STI R1, R0, L_DATA_PTR

HALT:             ; Infinite loop to keep the processor
    BRnzp HALT    ; from trying to execute the data below.
                  ; Your own programs should also make use
                  ; of an infinite loop at the end.

L_DATA_PTR:
    DATA2 L_DATA

L_DATA:
    DATA2 4xAA55
