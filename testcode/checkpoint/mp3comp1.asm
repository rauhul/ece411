; ECE 411 Fall 2014
; Competition Benchmark
; (C) 2002 Ashley Wise

ORIGIN 0
SEGMENT CodeSegment:

    lea R7, DataSegment;
    ;//load DataVector from segment table
    ldr R5, R7,  DataVector;
    ;//load DataSize from segment table
    ldr R6, R7, DataSize;
    lshf R6, R6, 2;
    add R6, R5, R6;
    add R6, R6, nFloatSize;
    ;//Point R6 to last data
    ;//R0 = HoldRand
    ldr R3, R7, PrimeNum;

    ;//Initialize the DataVector with random numbers
RandLoop:
        ;//Generate a random number for the mantissa in the range 0-0x7FFF
        lshf R1, R0, 2;
        add R1, R1, R0;
        add R1, R1, R3;
        rshfl R1, R1, 1;
        str R1, R5, Float.Mantissa;
        add R0, R1, 0;

        ;//Generate a random number for the sign (0 or 1) and exponent (0-0xFF)
        add R1, R1, R5;
        add R1, R1, R0;
        add R1, R1, R3;
        rshfl R2, R1, 8;
        and R2, R2, 4x0001;
        stb R2, R5, Float.Sign;
        stb R1, R5, Float.Exponent;

        add R5, R5, FloatSize;
        ;//R4 = R6 - R5;
        not R4, R5;
        add R4, R4, 1;
        add R4, R4, R6;

            ;//DataVectorEnd >= R5
        ;//if((signed short)R4 >= 0)    goto RandLoop;
        BRzp RandLoop

    ldr R0, R7, DataVector; //p
    ldr R1, R7, DataSize;   //r
    lshf R1, R1, 2;
    add R1, R0, R1;
    add R1, R1, nFloatSize;
    add R6, R1, FloatSize;
    add R6, R6, nStackSize; //Stack pointer
    jsr QuickSort;

    ; //Check results
    lea R7, DataSegment
    ldr R7, R7, CS_PTR
    jmp R7

;//p in R0
;//r in R1
;//q in R2
;//StackPointer in R6
;//return address in R7
QuickSort:
    add R6, R6, StackSize;

    str R7, R6, QSStack.ReturnAddress;
    str R0, R6, QSStack.p;
    str R1, R6, QSStack.r;

    jsr Partition;  //R2 = q

    str R2, R6, QSStack.q;
    ldr R0, R6, QSStack.p;

    add R1, R2, 0;  //The first QS uses (p,q) for (p,r)
    ;//R3 = R2 - R0;
    not R3, R0;
    add R3, R3, R2;
    add R3, R3, 1;

        ;//q > p, do first quicksort
    ;//if((signed short)R3 <= 0)    goto DontFirstQS;
    brnz DontFirstQS;
        jsr QuickSort;

DontFirstQS:
    ldr R1, R6, QSStack.r;
    ldr R2, R6, QSStack.q;

    add R0, R2, FloatSize;  //The second QS uses (q+1,r) for (p,r)
    ;//R3 = R1 - R2;
    not R3, R0;
    add R3, R3, R1;
    add R3, R3, 1;

        ;//r > q+1, do the second quicksort
    ;//if((signed short)R3 <= 0)    goto DontSecondQS;
    brnz DontSecondQS
        jsr QuickSort;

DontSecondQS:
    ldr R7, R6, QSStack.ReturnAddress;
    add R6, R6, nStackSize;
    ret;

;//p/i in R0
;//r/j in R1
;//q is returned in R2
;//DataSegment in r5 -> X and Temp
;//R2, R3, R4 store values X.Sign, X.Exponent, and X.Mantissa
;//R5 stores values from Data
;//StackPointer in R6
;//return address in R7
Partition:

    lea R5, DataSegment
    ;//X = Data[R0 - DataVector];
    ldb R2, R0, Float.Sign;
    ldb R3, R0, Float.Exponent;
    ldr R4, R0, Float.Mantissa;
    stb R2, R5, X.Sign;
    stb R3, R5, X.Exponent;
    str R4, R5, X.Mantissa;

    add R0, R0, nFloatSize;
    add R1, R1, FloatSize;

PartitionLoop:
    ;//R5 already holds &DataSegment from either path
    ldb R2, R5, X.Sign;
    ldb R3, R5, X.Exponent;
    ldr R4, R5, X.Mantissa;
    ;//Not them for later subtraction
    not R2, R2;
    not R3, R3;
    not R4, R4;

Start_i_Loop:   ;//Loop until we find a Data[i] that is >= X
        add R0, R0, FloatSize;

        ;//*** Start by checking sign

        ldb R5, R0, Float.Sign;
        ;//R5 = R5 - R2;
        add R5, R5, R2;
        add R5, R5, 1;

            ;//Data[i].Sign > X.Sign
        ;//if((signed short)R5 > 0) goto Start_i_Loop;  //Data[i] is negative, X is positive, continue
        brp Start_i_Loop;

            ;//Data[i].Sign < X.Sign
        ;//if((signed short)R5 < 0) goto End_i_Loop;    //Data[i] is positive, X is negative, break
        brn End_m_i_Loop

        add R5, R2, 1;

            ;//Data[i].Sign == 0
        ;//if(R5 != 0)  goto i_Loop_Else;   //both are negative
        brnp i_Loop_Else

            ;//Both are positive

            ;//*** Then check exponent

            ldb R5, R0, Float.Exponent;
            ;//R5 = R5 - R3;
            add R5, R5, R3;
            add R5, R5, 1;

                ;//Data[i].Exponent > X.Exponent
            ;//if((signed short)R5 > 0) goto End_i_Loop;    //Data[i] is bigger,    break
            brp End_m_i_Loop

                ;//Data[i].Exponent < X.Exponent
            ;//if((signed short)R5 < 0) goto Start_i_Loop;  //Data[i] is smaller,   continue
            brn Start_i_Loop

                ;//*** Then Check Mantissa

                ldr R5, R0, Float.Mantissa;
                ;//R5 = R5 - R4;
                add R5, R5, R4;
                add R5, R5, 1;

                    ;//Data[i].Mantissa < X.Mantissa
                ;//if((signed short)R5 < 0) goto Start_i_Loop;  //Data[i] is smaller,   continue
                brn Start_i_Loop;

                ;//if((signed short)R5 >= 0)    goto End_i_Loop;    //Data[i] is bigger or same,    break;
                brnzp End_m_i_Loop;

i_Loop_Else:    ;//both are negative

            ;//*** Then check exponent

            ldb R5, R0, Float.Exponent;
            ;//R5 = R5 - R3;
            add R5, R5, R3;
            add R5, R5, 1;

                ;//Data[i].Exponent > X.Exponent
            ;//if((signed short)R5 > 0) goto Start_i_Loop;  //Data[i] is smaller,   continue
            brp Start_i_Loop;

                ;//Data[i].Exponent < X.Exponent
            ;//if((signed short)R5 < 0) goto End_i_Loop;    //Data[i] is bigger,    break
            brn End_m_i_Loop;

                ;//*** Then Check Mantissa

                ldr R5, R0, Float.Mantissa;
                ;//R5 = R5 - R4;
                add R5, R5, R4;
                add R5, R5, 1;

                    ;//Data[i].Mantissa > X.Mantissa
                ;//if((signed short)R5 > 0) goto Start_i_Loop;  //Data[i] is smaller,   continue
                brp Start_i_Loop;

                ;//if((signed short)R5 <= 0)    goto End_i_Loop;    //Data[i] is bigger or same,    break;

End_m_i_Loop:
Start_j_Loop:   ;//Loop until we find an Data[j] that is <= X
        add R1, R1, nFloatSize;

        ;//*** Start by checking sign

        ldb R5, R1, Float.Sign;
        ;//R5 = R5 - R2;
        add R5, R5, R2;
        add R5, R5, 1;

            ;//Data[j].Sign > X.Sign
        ;//if((signed short)R5 > 0) goto End_j_Loop;    //Data[j] is negative, X is positive, break
        brp End_m_j_Loop;

            ;//Data[j].Sign < X.Sign
        ;//if((signed short)R5 < 0) goto Start_j_Loop;  //Data[j] is positive, X is negative, continue
        brn Start_j_Loop;

        add R5, R2, 1;

            ;//Data[j].Sign == 0
        ;//if(R5 != 0)  goto j_Loop_Else;   //both are negative
        brnp j_Loop_Else

            ;//Both are positive

            ;//*** Then check exponent

            ldb R5, R1, Float.Exponent;
            ;//R5 = R5 - R3;
            add R5, R5, R3;
            add R5, R5, 1;

                ;//Data[j].Exponent > X.Exponent
            ;//if((signed short)R5 > 0) goto Start_j_Loop;  //Data[j] is bigger,    continue
            brp Start_j_Loop;

                ;//Data[j].Exponent < X.Exponent
            ;//if((signed short)R5 < 0) goto End_j_Loop;    //Data[j] is smaller,   break
            brn End_m_j_Loop;

                ;//*** Then Check Mantissa

                ldr R5, R1, Float.Mantissa;
                ;//R5 = R5 - R4;
                add R5, R5, R4;
                add R5, R5, 1;

                    ;//Data[j].Mantissa > X.Mantissa
                ;//if((signed short)R5 > 0) goto Start_j_Loop;  //Data[j] is bigger,    continue
                brp Start_j_Loop;

                ;//if((signed short)R5 <= 0)    goto End_j_Loop;    //Data[j] is smaller or same,   break;
                brnzp End_m_j_Loop;

j_Loop_Else:    ;//both are negative

            ;//*** Then check exponent

            ldb R5, R1, Float.Exponent;
            ;//R5 = R5 - R3;
            add R5, R5, R3;
            add R5, R5, 1;

                ;//Data[j].Exponent > X.Exponent
            ;//if((signed short)R5 > 0) goto End_j_Loop;    //Data[j] is smaller,   break
            brp End_m_j_Loop;

                ;//Data[j].Exponent < X.Exponent
            ;//if((signed short)R5 < 0) goto Start_j_Loop;  //Data[j] is bigger,    continue
            brn Start_j_Loop;

                ;//*** Then Check Mantissa

                ldr R5, R1, Float.Mantissa;
                ;//R5 = R5 - R4;
                add R5, R5, R4;
                add R5, R5, 1;

                    ;//Data[j].Mantissa < X.Mantissa
                ;//if((signed short)R5 < 0) goto Start_j_Loop;  //Data[j] is bigger,    continue
                brn Start_j_Loop;

                ;//if((signed short)R5 >= 0)    goto End_j_Loop;    //Data[j] is smaller or same,   break;

End_m_j_Loop:
    ;//R2 = R1 - R0;
    not R2, R0;
    add R2, R2, R1
    add R2, R2, 1;

        ;//j > i
    ;//if((signed short)R2 <= 0)    goto DonePartition;
    brnz DonePartition;

        ;//Swap Data[i] and Data[j]
        lea R5, DataSegment;

        ;//Temp = Data[R0 - DataVector];
        ldb R2, R0, Float.Sign;
        ldb R3, R0, Float.Exponent;
        ldr R4, R0, Float.Mantissa;
        stb R2, R5, Temp.Sign;
        stb R3, R5, Temp.Exponent;
        str R4, R5, Temp.Mantissa;

        ;//Data[R0 - DataVector] = Data[R1 - DataVector];
        ldb R2, R1, Float.Sign;
        ldb R3, R1, Float.Exponent;
        ldr R4, R1, Float.Mantissa;
        stb R2, R0, Float.Sign;
        stb R3, R0, Float.Exponent;
        str R4, R0, Float.Mantissa;

        ;//Data[R1 - DataVector] = Temp;
        ldb R2, R5, Temp.Sign;
        ldb R3, R5, Temp.Exponent;
        ldr R4, R5, Temp.Mantissa;
        stb R2, R1, Float.Sign;
        stb R3, R1, Float.Exponent;
        str R4, R1, Float.Mantissa;

        brnzp PartitionLoop;

DonePartition:
    add R2, R1, 0;  //return q
    ret;

SEGMENT DataSegment:
DataVector: DATA2 4xB000
DataSize: DATA2 256
PrimeNum: DATA2 4x9EF5
X: STRUCT Float ?
Temp: STRUCT Float ?
; Result in 4xB000-4xB400
CS_PTR: DATA2 cs_start

;//The structure of the float type
STRUCTDEF Float
    Sign:   DATA1 ?
    Exponent:   DATA1 ?
    Mantissa:   DATA2 ?
END
DEFINE  FloatSize 4
DEFINE  nFloatSize -4

;//The structure of the QS stack type
STRUCTDEF QSStack
    ReturnAddress:  DATA2 ?
    p:  DATA2 ?
    r:  DATA2 ?
    q:  DATA2 ?
END
DEFINE  StackSize 8
DEFINE  nStackSize -8

segment
cs_start:
    lea r1, DataSegment
    ldr r0, r1, DataSize
    ldr r1, r1, DataVector
    add r1, r1, r0
    rshfl r0, r0, 1

halt:
    br halt

