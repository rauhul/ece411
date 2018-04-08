ORIGIN 4x0000

SEGMENT CodeSegment:

    LEA R0, DataSegment3        ;

    LDR R1, R0, NINE            ; R1 = 4x00
    LDR R2, R0, BIGNUMBER       ; R2 = 4x70CF
    ADD R5, R1, R2              ; R5 = 4x70DC


    STR R5, R0, BYP1            ; BYP1 = 4x70DC
    STR R2, R0, BYP2            ; BYP2 = 4x70CF

    ADD R5, R5, R5              ; R5 = 4xE1B8
    ADD R2, R2, R2              ; R2 = 4xE19E

    STR R5, R0, BYP1            ; BYP1 = 4xE1B8
    STR R2, R0, BYP2            ; BYP2 = 4xE19E

    LDR R6, R0, BYP2            ; R6 = 4xE19E
    LDR R3, R0, BYP1            ; R3 = 4xE1B8


    ADD R3, R6, R3              ;
    ADD R2, R3, R3              ;
    AND R1, R0, R2              ;
    AND R4, R3, R2              ;
    NOT R7, R4                  ;
    NOT R6, R4                  ;
    ADD R4, R7, R6              ;

Nowhere:
    BRnzp nowhere
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP

SEGMENT DataSegment3:
NINE:       DATA2 4x0009
BIGNUMBER:  DATA2 4x70CF
BYP1:       DATA2 4x0000
BYP2:       DATA2 4x0000
