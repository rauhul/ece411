ORIGIN 4x0000

SEGMENT CodeSegment:

    ; GARBAGE CODE TO GET SOME DATA IN PERFORMANCE COUNTERS
    ADD  R1, R0, -16 ; R1 = -16                                     ; pc_10 = 000
    ADD  R2, R0,  -9 ; R1 =  -9                                     ; pc_10 = 002
    ADD  R3, R0,  -2 ; R1 =  -2                                     ; pc_10 = 004
    ADD  R4, R0,   5 ; R1 =   5                                     ; pc_10 = 006
    ADD  R5, R0,  12 ; R1 =  12                                     ; pc_10 = 008
    ADD  R6, R0,  15 ; R1 =  15                                     ; pc_10 = 010
    ADD  R7, R0,   0 ; R1 =   0                                     ; pc_10 = 012
    NOP                                                             ; pc_10 = 014
    NOP                                                             ; pc_10 = 016
    NOP                                                             ; pc_10 = 018
    NOP                                                             ; pc_10 = 020
    ADD  R1, R1, R7  ; R1 = -16 +  0 = -16                          ; pc_10 = 022
    ADD  R2, R2, R6  ; R1 =  -9 + 15 =   6                          ; pc_10 = 024
    ADD  R3, R3, R5  ; R1 =  -2 + 12 =  10                          ; pc_10 = 026
    ADD  R4, R4, R4  ; R1 =   5 +  5 =  10                          ; pc_10 = 028
    NOP                                                             ; pc_10 = 030
    NOP                                                             ; pc_10 = 032
    NOP                                                             ; pc_10 = 034
    ADD  R5, R5, R3  ; R1 =  12 + 10 =  22                          ; pc_10 = 036
    ADD  R6, R6, R6  ; R1 =  15 + 15 =  30                          ; pc_10 = 038
    NOP                                                             ; pc_10 = 040
    NOP                                                             ; pc_10 = 042
    NOP                                                             ; pc_10 = 044
    ADD  R7, R5, R6  ; R1 =  12 + 30 =  42                          ; pc_10 = 046
    NOP                                                             ; pc_10 = 048
    NOP                                                             ; pc_10 = 050
    NOP                                                             ; pc_10 = 052

    ; LOAD BASE ADDRESS OF THE PERFORMANCE COUNTERS
    LEA R0, performance_counters_base_ptr                           ; pc_10 = 054
    LDR R0, R0, 0                                                   ; pc_10 = 056

    ; TEST LOAD VALUE FROM PERFORMANCE COUNTERS
    LDR R1, R0, 0                                                   ; pc_10 = 058
    LDR R2, R0, 1                                                   ; pc_10 = 060
    LDR R3, R0, 2                                                   ; pc_10 = 062
    LDR R4, R0, 3                                                   ; pc_10 = 064
    LDR R5, R0, 4                                                   ; pc_10 = 066
    LDR R6, R0, 5                                                   ; pc_10 = 068
    LDR R7, R0, 6                                                   ; pc_10 = 070

    ; TEST FAILED PREDICTION DOESN'T CORRUPT DATA (PREDICT NOT TAKEN)
    BRnzp skip                                                      ; pc_10 = 072
    AND R1, R1, 0                                                   ; pc_10 = 074
    AND R2, R2, 0                                                   ; pc_10 = 076
    AND R3, R3, 0                                                   ; pc_10 = 078
    AND R4, R4, 0                                                   ; pc_10 = 080
    AND R5, R5, 0                                                   ; pc_10 = 082
    AND R6, R6, 0                                                   ; pc_10 = 084
    AND R7, R7, 0                                                   ; pc_10 = 086

skip:
    ; TEST CORRECT PREDICTION DOESN'T TAKE BRANCH
    BRz no_skip                                                     ; pc_10 = 088

    ; TEST RESET PERFORMANCE COUNTERS ON STORE
    STR R1, R0, 0                                                   ; pc_10 = 090
    STR R2, R0, 1                                                   ; pc_10 = 092
    STR R3, R0, 2                                                   ; pc_10 = 094
    STR R4, R0, 3                                                   ; pc_10 = 096
    STR R5, R0, 4                                                   ; pc_10 = 098
    STR R6, R0, 5                                                   ; pc_10 = 100
    STR R7, R0, 6                                                   ; pc_10 = 102

no_skip:
    ; DONE

done:
    BRnzp done                                                      ; pc_10 = 104
    ; TEST REGISTERS NEVER CLEARED
    AND R1, R1, 0                                                   ; pc_10 = 106
    AND R2, R2, 0                                                   ; pc_10 = 108
    AND R3, R3, 0                                                   ; pc_10 = 110
    AND R4, R4, 0                                                   ; pc_10 = 112
    AND R5, R5, 0                                                   ; pc_10 = 114
    AND R6, R6, 0                                                   ; pc_10 = 116
    AND R7, R7, 0                                                   ; pc_10 = 118

performance_counters_base_ptr:
DATA2 4xFFE6
