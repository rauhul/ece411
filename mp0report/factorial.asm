ORIGIN 4x0000
    ; ******************************************
    ; MP0 factorial program
    ;   computes factorial of (FACTORIAL)
    ;   stores result in R2
    ;   change the value of FACTORIAL to compute
    ;   values other than 5!
    ; ******************************************

SEGMENT  CodeSegment:
    ; Setup register values
    LDR R1, R0, FACTORIAL   ; R1  =  5 (FACTORIAL)
    LDR R2, R0, POS_ONE     ; R2  =  1 (POS_ONE)
    LDR R5, R0, NEG_ONE     ; R5  = -1 (NEG_ONE)

FACTORIAL_ITER:
    ; Reset registers at begining of iteration
    AND R3, R3, R0          ; R3  =  0
    AND R4, R4, R0          ; R4  =  0
    ; Load R3 with the current iteration
    ADD R3, R3, R1          ; R3  = R1

    ; Multiply values
MULTIPLY:
    ADD R4, R4, R2          ; R4 += R2
    ADD R3, R3, R5          ; R3 -=  1
    BRp MULTIPLY

    ; Store result in R2
    AND R2, R2, R0          ; R2  =  0
    ADD R2, R2, R4          ; R2  = R4
    ADD R1, R1, R5          ; R1 -=  1
    ; loop back if more iterations are necessary
    BRp FACTORIAL_ITER

    ; halt if we are done
    BRnzp HALT

HALT:
    BRnzp HALT

FACTORIAL: DATA2 4x0005
POS_ONE:   DATA2 4x0001
NEG_ONE:   DATA2 4xFFFF
