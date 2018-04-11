# lecture 11 notes

#### what is instruction level parallelism

measure of inter-instruction depency in an application
- ILP assume a unit cycle operation, infinite resources, perfect front end
- ILP != IPC
  - ILP is the upper bound on the attainable instructions per cycle
- limited by data and control dependencies
  - no structural hazards as we assume infinite resources

#### example 1

true instruction dependency forces sequential execution, false dependencies can be removed:

``` assembly
/* original */
i1: load R2, 0(R12)
i2: add R1, R2, 9
i3: mul R2, R5, R6

/* parallelized */
i1: load R2, 0(R12)
i2: add R1, R2, 9 - i3: mul R2, R5, R6

/* ILP = 3/2 = 1.5 */
```

#### example 2

search for possibly parallelizable instruction in a window:

``` assembly
/* block a */
i1: load R5, 8(R6)
i2: sub R7, R5, R4
i3: mul R9, R7, R7
/* block b */
i4: load R15, 16(R6)
i5: add R17, R15, R14
i6: mul R19, R15, R15
```

block a requires sequentially executed code, ILP = 1

block b can parallelize i5 and i6, ILP = 1.5

combined the blocks can be further parallelized, ie:

``` assembly
/* parallelized block ab */
i1: load R5, 8(R6) - i4: load R15, 16(R6)
i2: sub R7, R5, R4 - i5: add R17, R15, R14 - i6: mul R19, R15, R15
i3: mul R9, R7, R7
/* ILP = 6/3 = 2 */
```

Larger window gives more opportunity for parallelism

#### memory dependency

- ambiguous dependency also forces squentiality
- to increase ILP we need dynamic memory disambiguation that are safe or recoverable

the ILP of the follow code could be 1 or 3 depending on the actual dependence

```assembly
i1: load R2, 0(R12)    ; not sure if these instructions 
i2: store R7, 24(R20)  ; access the same locations in memory
i3: store R1, (0xff00) ; ILP = 1 if they do, ILP = 3 if not
```

#### example 3

if only 4 registers are avalible, no possible speed up

with 8 we can significantly increase ILP

```assembly
/* original */
i1: load R1, 8(R0)
i2: sub R3, R1, 5
i3: mul R2, R1, R3
i4: store R2, 24(R0)
i5: load R1, 16(R0)
i6: sub R3, R1, 5
i7: mul R2, R1, R3
i8: store R2, 32(R0)

/* parallelized */
i1: load R1, 8(R0)   - i5: load R4, 16(R0)
i2: sub R3, R1, 5    - i6: sub R5, R4, 5
i3: mul R2, R1, R3   - i7: mul R6, R4, R5
i4: store R2, 24(R0) - i8: store R6, 32(R0)

/* ILP = 8/4 = 2 */
```

#### ILP with and without speculation

```assembly
i1: lw r1, (r11)   ; a = array[i];
i2: lw r2, (r12)   ; b = array[j];
i3: lw r3, (r13)   ; c = array[k];
i4: add r2, r2, r3 ; d = b + c;
i5: jge r2, r9, i9 ; while (d<t) {
i6: addi r1,r1,1   ;     a++;
i7: mul r3,r3,5    ;     c *= 5;
i8: j i4           ;     d = b + c;
i9: sw r1, (r11)   ; }
i10: sw r2, (r12)  ; array[i] = a;
i11: jr r31        ; array[j] = d;
```

converted into functional units

```assembly
; b1 -> b2
i1: lw r1, (r11)   ; a = array[i];
i2: lw r2, (r12)   ; b = array[j];
i3: lw r3, (r13)   ; c = array[k];
; b2 -> b3 or b4
i4: add r2, r2, r3 ; d = b + c;
i5: jge r2, r9, i9 ; while (d<t) {
; b3 -> b3
i6: addi r1,r1,1   ;     a++;
i7: mul r3,r3,5    ;     c *= 5;
i8: j i4           ;     d = b + c;
; b4 -> ret
i9: sw r1, (r11)   ; }
i10: sw r2, (r12)  ; array[i] = a;
i11: jr r31        ; array[j] = d;
```

##### ILP without speculation

```assembly
; b1, ILP = 3
i1: lw r1, (r11) - i2: lw r2, (r12) - i3: lw r3, (r13)
; b2, ILP = 1
i4: add r2, r2, r3
i5: jge r2, r9, i9
; b3, ILP = 3
i6: addi r1,r1,1 - i7: mul r3,r3,5 - i8: j i4
; b4, ILP = 1.5
i9: sw r1, (r11) - i11: jr r31
i10: sw r2, (r12)

; b1 -> b2 -> b3
; ILP = 8/4 = 2
; b1 -> b2 -> b4
; ILP = 8/5 = 1.6
```

##### ILP with speculation

```assembly
; b1->b2->b3, ILP = 8/3 = 2.67
i1: lw r1, (r11) - i2: lw r2, (r12) - i3: lw r3, (r13)
i4: add r2, r2, r3 - i6: addi r1,r1,1 - i7: mul r3,r3,5
i5: bge r2, r9, i9 - i8: j i4
; b1->b2->b4, ILP = 8/3 = 2.67
i1: lw r1, (r11) - i2: lw r2, (r12) - i3: lw r3, (r13)
i4: add r2, r2, r3 - i9: sw r1, (r11)
i5: bge r2, r9, i9 - i10: sw r2, (r12) - i11: jr r31
```

#### data flow execution model

- to exploit maximal ILP
  - graph of dependencies
- an instruction can be executed immediately after
  - all source operands are ready
  - execution unit available
  - destination is ready (to be written)


#### dynamic scheduling

exploit ILP at runtime, execute instructions OOO

- cpu maintains true dependency
- cpu finds ILP within an instruction window
  - requries good branch predictor

pros

- scalable performance
  - can be compiled for one platform but still run efficiently on others
  - handle cases with unknown compile time dependencies

cons

- hard to implement in hardware

#### tomasulo algorithm

issues

- CDB at high speed?
- precise exception issues
- speculative instructions
  - branch prediction enlarges instruction window
  - how to rollback when mispredicted?


summary

- prevents registers acting as bottlenecks 
- removes RAW, WAR, WAW hazards






