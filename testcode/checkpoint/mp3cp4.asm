ORIGIN 4x0000

SEGMENT CodeSegment:

    ; GARBAGE CODE TO GET SOME DATA IN PERFORMANCE COUNTERS
    ADD  R1, R0, -16 ; R1 = -16
    ADD  R2, R0,  -9 ; R1 =  -9
    ADD  R3, R0,  -2 ; R1 =  -2
    ADD  R4, R0,   5 ; R1 =   5
    ADD  R5, R0,  12 ; R1 =  12
    ADD  R6, R0,  15 ; R1 =  15
    ADD  R7, R0,   0 ; R1 =   0
    NOP
    NOP
    NOP
    NOP
    ADD  R1, R1, R7  ; R1 = -16 +  0 = -16
    ADD  R2, R2, R6  ; R1 =  -9 + 15 =   6
    ADD  R3, R3, R5  ; R1 =  -2 + 12 =  10
    ADD  R4, R4, R4  ; R1 =   5 +  5 =  10
    NOP
    NOP
    NOP
    ADD  R5, R5, R3  ; R1 =  12 + 10 =  22
    ADD  R6, R6, R6  ; R1 =  15 + 15 =  30
    NOP
    NOP
    NOP
    ADD  R7, R5, R6  ; R1 =  12 + 30 =  42
    NOP
    NOP
    NOP

    ; LOAD BASE ADDRESS OF THE PERFORMANCE COUNTERS
    LEA R0, performance_counters_base_ptr
    LDR R0, R0, 0

    ; TEST LOAD VALUE FROM PERFORMANCE COUNTERS
    LDR R1, R0, 0
    LDR R2, R0, 1
    LDR R3, R0, 2
    LDR R4, R0, 3
    LDR R5, R0, 4
    LDR R6, R0, 5
    LDR R7, R0, 6

    ; TEST FAILED PREDICTION DOESN'T CORRUPT DATA (PREDICT NOT TAKEN)
    BRnzp skip
    AND R1, R1, 0
    AND R2, R2, 0
    AND R3, R3, 0
    AND R4, R4, 0

skip:
    ; TEST CORRECT PREDICTION DOESN'T TAKE BRANCH
    BR no_skip

    ; TEST RESET PERFORMANCE COUNTERS ON STORE
    STR R1, R0, 0
    STR R2, R0, 1
    STR R3, R0, 2
    STR R4, R0, 3
    STR R5, R0, 4
    STR R6, R0, 5
    STR R7, R0, 6

no_skip:
    ; DONE

done:
    BRnzp done
    ; TEST REGISTERS NEVER CLEARED
    AND R1, R0, R1
    AND R2, R0, R2
    AND R3, R0, R3
    AND R4, R0, R4

performance_counters_base_ptr:
DATA2 4xFFE6
