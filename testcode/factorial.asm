ORIGIN 4x0000
    ; ******************************************
    ; MP0 factorial program
    ;   computes factorial of (FACTORIAL)
    ;   stores result in R2
    ;   change the value of FACTORIAL to compue
    ;   values other than 5!
    ; ******************************************

SEGMENT  CodeSegment:
    ; Setup register values
    LDR R1, R0, FACTORIAL
    LDR R2, R0, POS_ONE
    LDR R5, R0, NEG_ONE

FACTORIAL_ITER:
    ; Reset registers at begining of iteration
    AND R3, R3, R0
    AND R4, R4, R0
    ; Load R3 with the current iteration
    ADD R3, R3, R1

    ; Multiply values
MULTIPLY:
    ADD R4, R4, R2
    ADD R3, R3, R5
    BRp MULTIPLY

    ; Store result in R2
    AND R2, R2, R0
    ADD R2, R2, R4
    ADD R1, R1, R5
    ; loop back if more iterations are necessary
    BRp FACTORIAL_ITER

    ; halt if we are done
    BRnzp HALT

HALT:
    BRnzp HALT


; CHANGE THIS FOR NUMBER TO CALCULATE
FACTORIAL: DATA2 4x0005

POS_ONE:   DATA2 4x0001
NEG_ONE:   DATA2 4xFFFF
