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
    LDR R0, R0, DSP ; 0x0080
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R1, R0, W ; 0x0009
    LDR R3, R0, Y ; 0x0001
    ; cache line boundary
    LDR R2, R0, X ; 0x0002
    LDR R4, R0, Z ; 0x0003
    NOP
    STR R1, R0, Z ; store 0x0009
    STR R2, R0, Y ; store 0x0002
    STR R3, R0, X ; store 0x0001
    STR R4, R0, W ; store 0x0003
    NOP
    ; cache line boundary
    LDR R1, R0, W ; 0x0003
    LDR R2, R0, X ; 0x0001
    LDR R3, R0, Y ; 0x0002
    LDR R4, R0, Z ; 0x0009
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
    ADD R5, R1, R2 ; 0x0004
    ; cache line boundary
    ADD R6, R3, R4 ; 0x000b
    NOP
    NOP
    NOP
    NOP
    STR R5, R0, VICTIM ; store 0x0004
    ADD R7, R5, R6 ; 0x000f
    NOP
    ; cache line boundary
    NOP
    NOP
    NOP
    STR R7, R0, TOTAL ; store 0x000f ; < wb
    LDR R1, R0, TOTAL ; 0x000f ; < mem
inf:
    BRnzp inf ; < ex
    NOP ; < id
    NOP ; < if

; cache line boundary
SEGMENT DataSeg:
NOP ; < if_n
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
