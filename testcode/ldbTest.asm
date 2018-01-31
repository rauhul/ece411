ORIGIN 4x0000

SEGMENT CodeSegment:
    DATA2 4x00FF
    DATA2 4x00FF
    DATA2 4x00FF
    DATA2 4x00FF

HALT:             ; Infinite loop to keep the processor
    BRnzp HALT    ; from trying to execute the data below.
                  ; Your own programs should also make use
                  ; of an infinite loop at the end.
