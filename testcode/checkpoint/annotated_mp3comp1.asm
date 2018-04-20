000 :       SEGMENT CodeSegment: lea R7, DataSegment
002 :       ldr R5, R7,  DataVector
004 :       ldr R6, R7, DataSize
006 :       lshf R6, R6, 2
008 :       add R6, R5, R6
010 :       add R6, R6, nFloatSize
012 :       ldr R3, R7, PrimeNum
014 :       RandLoop: lshf R1, R0, 2
016 :       add R1, R1, R0
018 :       add R1, R1, R3
020 :       rshfl R1, R1, 1
022 :       str R1, R5, Float.Mantissa
024 :       add R0, R1, 0
026 :       add R1, R1, R5
028 :       add R1, R1, R0
030 :       add R1, R1, R3
032 :       rshfl R2, R1, 8
034 :       and R2, R2, 4x0001
036 :       stb R2, R5, Float.Sign
038 :       stb R1, R5, Float.Exponent
040 :       add R5, R5, FloatSize
042 :       not R4, R5
044 :       add R4, R4, 1
046 :       add R4, R4, R6
048 :       BRzp RandLoop
050 :       ldr R0, R7, DataVector
052 :       ldr R1, R7, DataSize
054 :       lshf R1, R1, 2
056 :       add R1, R0, R1
058 :       add R1, R1, nFloatSize
060 :       add R6, R1, FloatSize
062 :       add R6, R6, nStackSize
064 :       jsr QuickSort
066 :       lea R7, DataSegment
068 :       ldr R7, R7, CS_PTR
070 :       jmp R7
072 :       QuickSort: add R6, R6, StackSize
074 :       str R7, R6, QSStack.ReturnAddress
076 :       str R0, R6, QSStack.p
078 :       str R1, R6, QSStack.r
080 :       jsr Partition
082 :       str R2, R6, QSStack.q
084 :       ldr R0, R6, QSStack.p
086 :       add R1, R2, 0
088 :       not R3, R0
090 :       add R3, R3, R2
092 :       add R3, R3, 1
094 :       brnz DontFirstQS
096 :       jsr QuickSort
098 :       DontFirstQS: ldr R1, R6, QSStack.r
100 :       ldr R2, R6, QSStack.q
102 :       add R0, R2, FloatSize
104 :       not R3, R0
106 :       add R3, R3, R1
108 :       add R3, R3, 1
110 :       brnz DontSecondQS
112 :       jsr QuickSort
114 :       DontSecondQS: ldr R7, R6, QSStack.ReturnAddress
116 :       add R6, R6, nStackSize
118 :       ret
120 :       Partition: lea R5, DataSegment
122 :       ldb R2, R0, Float.Sign
124 :       ldb R3, R0, Float.Exponent
126 :       ldr R4, R0, Float.Mantissa
128 :       stb R2, R5, X.Sign
130 :       stb R3, R5, X.Exponent
132 :       str R4, R5, X.Mantissa
134 :       add R0, R0, nFloatSize
136 :       add R1, R1, FloatSize
138 :       PartitionLoop: ldb R2, R5, X.Sign
140 :       ldb R3, R5, X.Exponent
142 :       ldr R4, R5, X.Mantissa
144 :       not R2, R2
146 :       not R3, R3
148 :       not R4, R4
150 :       Start_i_Loop: add R0, R0, FloatSize
152 :       ldb R5, R0, Float.Sign
154 :       add R5, R5, R2
156 :       add R5, R5, 1
158 :       brp Start_i_Loop
160 :       brn End_m_i_Loop
162 :       add R5, R2, 1
164 :       brnp i_Loop_Else
166 :       ldb R5, R0, Float.Exponent
168 :       add R5, R5, R3
170 :       add R5, R5, 1
172 :       brp End_m_i_Loop
174 :       brn Start_i_Loop
176 :       ldr R5, R0, Float.Mantissa
178 :       add R5, R5, R4
180 :       add R5, R5, 1
182 :       brn Start_i_Loop
184 :       brnzp End_m_i_Loop
186 :       i_Loop_Else:     ldb R5, R0, Float.Exponent
188 :       add R5, R5, R3
190 :       add R5, R5, 1
192 :       brp Start_i_Loop
194 :       brn End_m_i_Loop
196 :       ldr R5, R0, Float.Mantissa
198 :       add R5, R5, R4
200 :       add R5, R5, 1
202 :       brp Start_i_Loop
204 :       End_m_i_Loop: Start_j_Loop: add R1, R1, nFloatSize
206 :       ldb R5, R1, Float.Sign
208 :       add R5, R5, R2
210 :       add R5, R5, 1
212 :       brp End_m_j_Loop
214 :       brn Start_j_Loop
216 :       add R5, R2, 1
218 :       brnp j_Loop_Else
220 :       ldb R5, R1, Float.Exponent
222 :       add R5, R5, R3
224 :       add R5, R5, 1
226 :       brp Start_j_Loop
228 :       brn End_m_j_Loop
230 :       ldr R5, R1, Float.Mantissa
232 :       add R5, R5, R4
234 :       add R5, R5, 1
236 :       brp Start_j_Loop
238 :       brnzp End_m_j_Loop
240 :       j_Loop_Else:     ldb R5, R1, Float.Exponent
242 :       add R5, R5, R3
244 :       add R5, R5, 1
246 :       brp End_m_j_Loop
248 :       brn Start_j_Loop
250 :       ldr R5, R1, Float.Mantissa
252 :       add R5, R5, R4
254 :       add R5, R5, 1
256 :       brn Start_j_Loop
258 :       End_m_j_Loop: not R2, R0
260 :       add R2, R2, R1
262 :       add R2, R2, 1
264 :       brnz DonePartition
266 :       lea R5, DataSegment
268 :       ldb R2, R0, Float.Sign
270 :       ldb R3, R0, Float.Exponent
272 :       ldr R4, R0, Float.Mantissa
274 :       stb R2, R5, Temp.Sign
276 :       stb R3, R5, Temp.Exponent
278 :       str R4, R5, Temp.Mantissa
280 :       ldb R2, R1, Float.Sign
282 :       ldb R3, R1, Float.Exponent
284 :       ldr R4, R1, Float.Mantissa
286 :       stb R2, R0, Float.Sign
288 :       stb R3, R0, Float.Exponent
290 :       str R4, R0, Float.Mantissa
292 :       ldb R2, R5, Temp.Sign
294 :       ldb R3, R5, Temp.Exponent
296 :       ldr R4, R5, Temp.Mantissa
298 :       stb R2, R1, Float.Sign
300 :       stb R3, R1, Float.Exponent
302 :       str R4, R1, Float.Mantissa
304 :       brnzp PartitionLoop
306 :       DonePartition: add R2, R1, 0
308 :       ret
310 :       SEGMENT DataSegment: DataVector: DATA2 4xB000
312 :       DataSize: DATA2 256
314 :       PrimeNum: DATA2 4x9EF5
316 :       X: STRUCT Float ?
318 :       Temp: STRUCT Float ?
320 :       CS_PTR: DATA2 cs_start
322 :       STRUCTDEF Float
324 :           Sign:   DATA1 ?
326 :           Exponent:   DATA1 ?
328 :           Mantissa:   DATA2 ?
330 :       END
332 :       DEFINE  FloatSize 4
334 :       DEFINE  nFloatSize -4
336 :       STRUCTDEF QSStack
338 :       ReturnAddress:  DATA2 ?
340 :           p:  DATA2 ?
342 :           r:  DATA2 ?
344 :           q:  DATA2 ?
346 :       END
348 :       DEFINE  StackSize 8
350 :       DEFINE  nStackSize -8
352 :       segment
354 :       cs_start: lea r1, DataSegment
356 :       ldr r0, r1, DataSize
358 :       ldr r1, r1, DataVector
360 :       add r1, r1, r0
362 :       rshfl r0, r0, 1
364 :       halt: br halt
