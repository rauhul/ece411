SEGMENT BOOT:
    BRnzp ldr_str_test
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
DSP:    DATA2 DataSeg
    ; cache line boundary

ldr_str_test:
    LDR R0, R0, DSP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R1, R0, W
    LDR R3, R0, Y
    ; cache line boundary
    LDR R2, R0, X
    LDR R4, R0, Z
    NOP
    STR R1, R0, Z
    STR R2, R0, Y
    STR R3, R0, X
    STR R4, R0, W
    NOP
    ; cache line boundary
    LDR R1, R0, W
    LDR R2, R0, X
    LDR R3, R0, Y
    LDR R4, R0, Z
    BRnzp fetch_stall_test
    NOP
    NOP
    NOP
    ; cache line boundary
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ; cache line boundary
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
fetch_stall_test:
    ADD R5, R1, R2
    ; cache line boundary
    ADD R6, R3, R4
    NOP
    NOP
    NOP
    NOP
    STR R5, R0, VICTIM
    ADD R7, R5, R6
    NOP
    ; cache line boundary
    NOP
    NOP
    NOP
    STR R7, R0, TOTAL
    LDR R1, R0, TOTAL
inf:
    BRnzp inf
    NOP
    NOP

; cache line boundary
SEGMENT DataSeg:
NOP
NOP
NOP
NOP
NOP
NOP
W:  DATA2 4x0009
X:  DATA2 4x0002
; cache line boundary
Y:  DATA2 4x0001
Z:  DATA2 4x0003
NOP
NOP
NOP
NOP
NOP
NOP
; cache line boundary
TOTAL:  DATA2 4x0000
NOP
NOP
NOP
NOP
NOP
NOP
NOP
; cache line boundary
VICTIM: DATA2 4x0000
NOP
NOP
NOP
NOP
NOP
NOP
NOP
