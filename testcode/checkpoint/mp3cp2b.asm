SEGMENT CodeSegment:    ; Version 0.11  1/13/2005
    LEA R0, DataSegment ; 0x001c
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BRnzp skip
    NOP ;addr=0x010
    NOP
    NOP
    NOP
    NOP
    NOP
SEGMENT DataSegment:
ZERO:       DATA2 0
ONETWELVE:  DATA2 112
ENT:        DATA2 10
NINER:      DATA2 9999
GECKO:      DATA2 42
NOT6:       DATA2 4xBAC8
THREE:      DATA2 7
TREE:       DATA2 3
BADBAD:     DATA2 4x0BAD
PAT1:       DATA2 4x0D0D
PAT2:       DATA2 4x9884
PAT3:       DATA2 4xAE85
GOOD:       DATA2 4x5460
five:       DATA2 5
TT:         DATA2 4x0646
RES1:       DATA2 0     ; 0x01e0 @101
RES2:       DATA2 0     ; 0x000a @136
RES3:       DATA2 0     ; 0x4537 @157
RES4:       DATA2 0     ; 0xa342 @234
RES5:       DATA2 0     ; 0x01a1 @241
RES6:       DATA2 0     ; 0xfe62 @248
RES7:       DATA2 0     ; 0xfe6f @276
RES8:       DATA2 0     ; 0x0046 @262, 0x001a @377
RES9:       DATA2 0     ; 0xfcff @398
RES10:      DATA2 0     ; 0x000d @434
RES11:      DATA2 0     ; 0x517a @455
RES12:      DATA2 0     ; 0x013F @504
RES13:      DATA2 0     ; 0x90b8 @613
RES14:      DATA2 0     ; 0x0646 @641
RES15:      DATA2 0     ; 0x0424 @627
RES16:      DATA2 0     ; 0x000c @697
Bear:       DATA2 CatchMe
Owl:        DATA2 paris

skip:
    LDR R1, R0, ZERO ; 0x0000
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R2, R0, ONETWELVE ; 0x0070
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R7, R0, ENT ; 0x000a
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R1, R2, R7 ; 0x007a
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R3, R1, -4 ; 0x0076
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R1, R1, R3 ; 0x00f0
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R1, R1, R1 ; 0x01e0
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R1, R0, RES1 ; store 0x01e0
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R1, R0, NINER ; 0x270f
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R2, R0, GECKO ; 0x002a
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    AND R6, R1, R2 ; 0x000a
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    AND R5, R6, 10 ; 0x000a
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R5, R0, RES2 ; store 0x000a
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R7, R0, NOT6 ; 0xbac8
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOT R7, R7 ; 0x4537
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R7, R0, RES3 ; store 0x4537
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R1, R0, PAT1 ; 0x0d0d
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LSHF R2, R1, 4 ; 0xd0d0
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    RSHFL R3, R1, 2 ; 0x0343
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LSHF R2, R2, 1 ; 0xa1a0
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    RSHFL R3, R3, 1 ; 0x01a1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R2, R2, R3 ; 0xa341
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R2, R2, 1 ; 0xa342
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    RSHFA R4, R1, 3 ; 0x01a1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R1, R0, PAT2 ; 0x9884 @1845ns
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    RSHFA R5, R1, 6 ; 0xfe62
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R2, R0, RES4 ; store 0xa342
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R4, R0, RES5 ; store 0x01a1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R5, R0, RES6 ; store 0xfe62
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LEA R1, RES7 ; 0x0046
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R1, R0, RES8 ; store 0x0046
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R5, R5, 13 ; 0xfe6f
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STI R5, R0, RES8 ; store 0xfe6f
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R1, R0, TREE ; 0x0003
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R2, R0, THREE ; 0x0007
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    AND R3, R3, 0 ; 0x0000 @2625ns
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
loop1:
    ADD R2, R2, 5 ; 0x000c, 0x0011, 0x0016
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R1, R1, -1; 0x0002, 0x0001, 0x0000
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BRp loop1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
loop2:
    ADD R1, R1, 7 ; 0x0007, 0x000e, 0x0015, 0x001c
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R2, R2, -6 ; 0x0010, 0x000a, 0x0004, 0xfffe
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BRp loop2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BRz loop1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BRn miami
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R2, R0, five ; skipped
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
miami:
    ADD R2, R2, R1 ; 0x001a
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R2, R0, RES8 ; store 0x001a
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R6, R0, ZERO ; 0x0000
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JSR dallas ; pc = 0x0804, r7 = 0x0300, r6 = 0xfcff
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R6, R0, RES9 ; store 0xfcff
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    AND R5, R5, 13 ; 0x000d @4695ns
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LEA R3, portland ; 0x0352
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JMP R3
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R5, R0, BADBAD
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
portland:
    STR R5, R0, RES10 ; store 0x000d
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R5, R0, BADBAD ; 0x0bad
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    TRAP Bear ; pc = 0x042c, r7 = 0x0370
              ; r5 = 0x517a
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R5, R0, RES11 ; store 0x517a
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    AND R1, R1, 0 ; 0x0000
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R1, R1, 8 ; 0x0008
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R1, R1, 9 ; 0x0011
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDB R2, R0, PAT3 ; 0x0085
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDB R3, R1, PAT3 ; 0x00ba NOT6_H
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R4, R3, R2 ; 0x013F
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R4, R0, RES12 ; store 0x013F
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R2, R2, 11 ; 0x0090
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R3, R3, -2; 0x00b8
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LEA R1, DataSegment2 ; 0x0424 @6025ns
    ;the following STB instructions store to mem[RES17]
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BRnzp skip2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP

SEGMENT DataSegment2:
TS:     DATA2 4x0646
RES17:  DATA2 0     ; 0xae85 @725
RES18:  DATA2 0     ; 0x600d @776
RES19:  DATA2 0     ; 0x001e @819
CatchMe: ; r7 = 0x0370
    LDR R5, R0, PAT3 ; 0xae85
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOT R5, R5 ; 0x517a
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    RET
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
OverHere:
    LDR R3, R0, GOOD ; 0x5460
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R1, R1, R3 ; 0x600d
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    RET ; pc = 0x05c4
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP

skip2:
    STB R2, R1, 3 ; store 0x0090 RES17_H
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STB R3, R1, 2 ; store 0x00b8 RES17_L
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R4, R1, RES17 ; 0x90b8
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R4, R0, RES13 ; store 0x90b8
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LEA R3, TS ; 0x0424
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R3, R0, RES15 ; store 0x0424
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDI R3, R0, RES15 ; 0x0646
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R3, R0, RES14 ; store 0x0646 @6575ns
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
SEGMENT CodeSegment2:
    LEA R4, DataSegment4 ; 0x0528
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R2, R4, Indy ; ADD R1, R1, 12, 0x126c
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R2, R2, 3 ; 0x126f
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    AND R1, R1, 0 ; 0x0000
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ; To test self-modifying code, uncomment
    ; the following lines and use the first 'Indy'
    ; STR R2, R4, Indy
    ; NOP
    ; NOP
    ; NOP
    ; NOP
    ; NOP
    ; NOP
SEGMENT DataSegment4:
; Indy:
;     ADD R1, R1, 9
Indy:
    ADD R1, R1, 12 ; 0x000c
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R1, R0, RES16 ; store 0x000c
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R1, R0, 1 ; 0x001d
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R3, R1, PAT3 ; 0xae85
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LEA R6, DataSegment2 ; 0x0424
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R3, R6, RES17 ; store 0xae85
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R1, R0, PAT3 ; 0xae85
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BRn Nati
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    TRAP Owl ; skipped
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
Nati:
    LDR R1, R0, BADBAD ; 0x0bad
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LEA R2, OverHere ; 0x0456
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JSRR R2 ; pc = 0x0456, r7 = 0x05c4
            ; r3 = 0x5460, r1 = 0x600d
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R1, R6, RES18 ; store 0x600d
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R1, R0, 2 ; 0x001e
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    AND R6, R6, 0 ; 0x0000
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    BRz dulles
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    ADD R1, R1, R1 ; skipped
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
dulles:
    LEA R6, DataSegment2 ; 0x0424
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R1, R6, RES19 ; store 0x001e
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP

bloomington:
    LEA R5, DataSegment3 ; 0x0738
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R6, R5, DSP ; 0x001c
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R0, R6, RES1 ; 0x01e0
    LDR R1, R6, RES2 ; 0x000a
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JSR atlanta ; pc = 0x0820, r7 = 0x0660
                ; r0 = 0x1ea, r1 = 0xfff5, r2 = 0xffff
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R1, R6, RES3 ; 0x4537
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JSR atlanta ; pc = 0x0820, r7 = 0x067c
                ; r0 = 0x44dd, r1 = 0xbac8, r2 = 0xfedd
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R0, R5, CS1 ;e store 0x44dd
    LDR R0, R6, RES4 ; 0xa342
    LDR R1, R6, RES5 ; 0x01a1
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JSR atlanta ; pc = 0x0820, r7 = 0x069c
                ; r0 = 0xa2e3, r1 = 0xfe5e, r2 = 0xfeff
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R1, R6, RES6 ; 0xfe62
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JSR atlanta ; pc = 0x0820, r7 = 0x06b8
                ; r0 = 0x5c81, r1 = 0x019d, r2 = 0x5d9d
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R0, R5, CS2 ; store 0x5c81
    LDR R0, R6, RES7 ; 0xfe6f
    LDR R1, R6, RES8 ; 0x001a
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JSR atlanta ; pc = 0x0820, r7 = 0x06d8
                ; r0 = 0xfe75, r1 = 0xffe5, r2 = 0xfff5
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R0, R5, CS3 ; store 0xfe75
    LDR R0, R6, RES9 ; 0xfcff
    LDR R1, R6, RES10 ; 0x000d
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JSR atlanta ; pc = 0x0820, r7 = 0x06f8
                ; r0 = 0xfcf2, r1 = 0xfff2, r2 = 0xfff2
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R0, R5, CS4 ; store 0xfcf2
    LDR R0, R6, RES11 ; 0x517a
    LDR R1, R6, RES12 ; 0x013f
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JSR atlanta ; pc = 0x0820, r7 = 0x0718
                ; r0 = 0x5045, r1 = 0xfec0, r2 = 0xfec5
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R0, R5, CS5 ; store 0x5045
    LDR R0, R6, RES13 ; 0x90b8
    LDR R1, R6, RES14 ; 0x0646
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JSR atlanta ; pc = 0x0820, r7 = 0x0738
                ; r0 = 0x96fe, r1 = 0xf9b9, r2 = 0xffff
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R0, R5, CS6 ; store 0x96fe
    LDR R0, R6, RES15 ; 0x0424
    LDR R1, R6, RES16 ; 0x000c
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JSR atlanta ; pc = 0x0820, r7 = 0x0758
                ; r0 = 0x0428, r1 = 0xfff3, r2 = 0xfffb
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R0, R5, CS7 ; store 0x0428
    LDR R6, R5, DS2P ; 0x0424
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R0, R6, RES17 ; 0xae85
    LDR R1, R6, RES18 ; 0x600d
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JSR atlanta ; pc = 0x0820, r7 = 0x786
                ; r0 = 0xce88, r1 = 0x9ff2, r2 = 0xdffa
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R1, R6, RES19 ; 0x001e
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    JSR atlanta ; pc = 0x0820, r7 = 0x07a2
                ; r0 = 0xce96, r1 = 0xffe1, r2 = 0xfff7
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    STR R0, R5, CS8 ; store 0xce96
    LEA R7, DataSegment3 ; 0x07e8
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R0, R7, CS1 ; 0x44dd
    LDR R1, R7, CS2 ; 0x5c81
    LDR R2, R7, CS3 ; 0xfe75
    LDR R3, R7, CS4 ; 0xfcf2
    LDR R4, R7, CS5 ; 0x5045
    LDR R5, R7, CS6 ; 0x96fe
    LDR R6, R7, CS7 ; 0x0428
    LDR R7, R7, CS8 ; 0xce96
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
Nowhere:
    BRnzp nowhere ; pc = 0x07da
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
CS1:        DATA2 4x0000 ; 0x44dd @874
CS2:        DATA2 4x0000 ; 0x5c81 @906
CS3:        DATA2 4x0000 ; 0xfe75 @923
CS4:        DATA2 4x0000 ; 0xfcf2 @940
CS5:        DATA2 4x0000 ; 0x5045 @957
CS6:        DATA2 4x0000 ; 0x96fe @974
CS7:        DATA2 4x0000 ; 0x0428 @991
CS8:        DATA2 4x0000 ; 0xce96 @1030
DSP:        DATA2 DataSegment
DS2P:       DATA2 DataSegment2

dallas: ; r7 = 0x0300
    NOT R6, R7 ; 0xfcff
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    RET ; pc = 0x0300
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
atlanta: ; r7 = 0x0660
    AND R2, R0, R1 ; 0x0000
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOT R2, R2 ; 0xffff
    NOT R0, R0 ; 0xfe1f
    NOT R1, R1 ; 0xfff5
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    AND R0, R0, R1 ; 0xfe1f
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOT R0, R0 ; 0x01ea
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    AND R0, R0, R2 ; 0x01ea
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    RET
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
paris:
    LDR R1, R0, BADBAD
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDB R1, R0, NINER
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDB R2, R0, GECKO
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R3, R0, THREE
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDR R4, R0, ZERO
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
