0000 :      SEGMENT CodeSegment: lea R7, DataSegment
0002 :      ldr R5, R7,  DataVector
0004 :      ldr R6, R7, DataSize
0006 :      lshf R6, R6, 2
0008 :      add R6, R5, R6
0010 :      add R6, R6, nFloatSize
0012 :      ldr R3, R7, PrimeNum
0014 :      RandLoop: lshf R1, R0, 2
0016 :      add R1, R1, R0
0018 :      add R1, R1, R3
0020 :      rshfl R1, R1, 1
0022 :      str R1, R5, Float.Mantissa
0024 :      add R0, R1, 0
0026 :      add R1, R1, R5
0028 :      add R1, R1, R0
0030 :      add R1, R1, R3
0032 :      rshfl R2, R1, 8
0034 :      and R2, R2, 4x0001
0036 :      stb R2, R5, Float.Sign
0038 :      stb R1, R5, Float.Exponent
0040 :      add R5, R5, FloatSize
0042 :      not R4, R5
0044 :      add R4, R4, 1
0046 :      add R4, R4, R6
0048 :      BRzp RandLoop
0050 :      ldr R0, R7, DataVector
0052 :      ldr R1, R7, DataSize
0054 :      lshf R1, R1, 2
0056 :      add R1, R0, R1
0058 :      add R1, R1, nFloatSize
0060 :      add R6, R1, FloatSize
0062 :      add R6, R6, nStackSize
0064 :      jsr QuickSort
0066 :      lea R7, DataSegment
0068 :      ldr R7, R7, CS_PTR
0070 :      jmp R7
0072 :      QuickSort: add R6, R6, StackSize
0074 :      str R7, R6, QSStack.ReturnAddress
0076 :      str R0, R6, QSStack.p
0078 :      str R1, R6, QSStack.r
0080 :      jsr Partition
0082 :      str R2, R6, QSStack.q
0084 :      ldr R0, R6, QSStack.p
0086 :      add R1, R2, 0
0088 :      not R3, R0
0090 :      add R3, R3, R2
0092 :      add R3, R3, 1
0094 :      brnz DontFirstQS
0096 :      jsr QuickSort
0098 :      DontFirstQS: ldr R1, R6, QSStack.r
0100 :      ldr R2, R6, QSStack.q
0102 :      add R0, R2, FloatSize
0104 :      not R3, R0
0106 :      add R3, R3, R1
0108 :      add R3, R3, 1
0110 :      brnz DontSecondQS
0112 :      jsr QuickSort
0114 :      DontSecondQS: ldr R7, R6, QSStack.ReturnAddress
0116 :      add R6, R6, nStackSize
0118 :      ret
0120 :      Partition: lea R5, DataSegment
0122 :      ldb R2, R0, Float.Sign
0124 :      ldb R3, R0, Float.Exponent
0126 :      ldr R4, R0, Float.Mantissa
0128 :      stb R2, R5, X.Sign
0130 :      stb R3, R5, X.Exponent
0132 :      str R4, R5, X.Mantissa
0134 :      add R0, R0, nFloatSize
0136 :      add R1, R1, FloatSize
0138 :      PartitionLoop: ldb R2, R5, X.Sign
0140 :      ldb R3, R5, X.Exponent
0142 :      ldr R4, R5, X.Mantissa
0144 :      not R2, R2
0146 :      not R3, R3
0148 :      not R4, R4
0150 :      Start_i_Loop: add R0, R0, FloatSize
0152 :      ldb R5, R0, Float.Sign
0154 :      add R5, R5, R2
0156 :      add R5, R5, 1
0158 :      brp Start_i_Loop
0160 :      brn End_m_i_Loop
0162 :      add R5, R2, 1
0164 :      brnp i_Loop_Else
0166 :      ldb R5, R0, Float.Exponent
0168 :      add R5, R5, R3
0170 :      add R5, R5, 1
0172 :      brp End_m_i_Loop
0174 :      brn Start_i_Loop
0176 :      ldr R5, R0, Float.Mantissa
0178 :      add R5, R5, R4
0180 :      add R5, R5, 1
0182 :      brn Start_i_Loop
0184 :      brnzp End_m_i_Loop
0186 :      i_Loop_Else:     ldb R5, R0, Float.Exponent
0188 :      add R5, R5, R3
0190 :      add R5, R5, 1
0192 :      brp Start_i_Loop
0194 :      brn End_m_i_Loop
0196 :      ldr R5, R0, Float.Mantissa
0198 :      add R5, R5, R4
0200 :      add R5, R5, 1
0202 :      brp Start_i_Loop
0204 :      End_m_i_Loop: Start_j_Loop: add R1, R1, nFloatSize
0206 :      ldb R5, R1, Float.Sign
0208 :      add R5, R5, R2
0210 :      add R5, R5, 1
0212 :      brp End_m_j_Loop
0214 :      brn Start_j_Loop
0216 :      add R5, R2, 1
0218 :      brnp j_Loop_Else
0220 :      ldb R5, R1, Float.Exponent
0222 :      add R5, R5, R3
0224 :      add R5, R5, 1
0226 :      brp Start_j_Loop
0228 :      brn End_m_j_Loop
0230 :      ldr R5, R1, Float.Mantissa
0232 :      add R5, R5, R4
0234 :      add R5, R5, 1
0236 :      brp Start_j_Loop
0238 :      brnzp End_m_j_Loop
0240 :      j_Loop_Else:     ldb R5, R1, Float.Exponent
0242 :      add R5, R5, R3
0244 :      add R5, R5, 1
0246 :      brp End_m_j_Loop
0248 :      brn Start_j_Loop
0250 :      ldr R5, R1, Float.Mantissa
0252 :      add R5, R5, R4
0254 :      add R5, R5, 1
0256 :      brn Start_j_Loop
0258 :      End_m_j_Loop: not R2, R0
0260 :      add R2, R2, R1
0262 :      add R2, R2, 1
0264 :      brnz DonePartition
0266 :      lea R5, DataSegment
0268 :      ldb R2, R0, Float.Sign
0270 :      ldb R3, R0, Float.Exponent
0272 :      ldr R4, R0, Float.Mantissa
0274 :      stb R2, R5, Temp.Sign
0276 :      stb R3, R5, Temp.Exponent
0278 :      str R4, R5, Temp.Mantissa
0280 :      ldb R2, R1, Float.Sign
0282 :      ldb R3, R1, Float.Exponent
0284 :      ldr R4, R1, Float.Mantissa
0286 :      stb R2, R0, Float.Sign
0288 :      stb R3, R0, Float.Exponent
0290 :      str R4, R0, Float.Mantissa
0292 :      ldb R2, R5, Temp.Sign
0294 :      ldb R3, R5, Temp.Exponent
0296 :      ldr R4, R5, Temp.Mantissa
0298 :      stb R2, R1, Float.Sign
0300 :      stb R3, R1, Float.Exponent
0302 :      str R4, R1, Float.Mantissa
0304 :      brnzp PartitionLoop
0306 :      DonePartition: add R2, R1, 0
0308 :      ret
0310 :      SEGMENT DataSegment: DataVector: DATA2 4xB000
0312 :      DataSize: DATA2 256
0314 :      PrimeNum: DATA2 4x9EF5
0316 :      X: STRUCT Float ?
0318 :      Temp: STRUCT Float ?
0320 :      CS_PTR: DATA2 cs_start
0322 :      STRUCTDEF Float
0324 :          Sign:   DATA1 ?
0326 :          Exponent:   DATA1 ?
0328 :          Mantissa:   DATA2 ?
0330 :      END
0332 :      DEFINE  FloatSize 4
0334 :      DEFINE  nFloatSize -4
0336 :      STRUCTDEF QSStack
0338 :      ReturnAddress:  DATA2 ?
0340 :          p:  DATA2 ?
0342 :          r:  DATA2 ?
0344 :          q:  DATA2 ?
0346 :      END
0348 :      DEFINE  StackSize 8
0350 :      DEFINE  nStackSize -8
0352 :      segment
0354 :      cs_start: lea r1, DataSegment
0356 :      ldr r0, r1, DataSize
0358 :      ldr r1, r1, DataVector
0360 :      add r1, r1, r0
0362 :      rshfl r0, r0, 1
0364 :      halt: br halt
