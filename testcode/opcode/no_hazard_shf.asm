SEGMENT  CodeSegment:

   ADD   R1, R0, -16 ; R1 = -16
   ADD   R2, R0,  -9 ; R1 =  -9
   ADD   R3, R0,  -2 ; R1 =  -2
   ADD   R4, R0,   5 ; R1 =   5
   ADD   R5, R0,  12 ; R1 =  12
   ADD   R6, R0,  15 ; R1 =  15
   ADD   R7, R0,   0 ; R1 =   0
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   RSHFA R1, R1,   1
   RSHFL R2, R2,   3
   LSHF  R3, R3,   5
   RSHFA R4, R4,   7
   RSHFL R5, R5,   9
   LSHF  R6, R6,  11
