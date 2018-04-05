ORIGIN 0
SEGMENT CodeSegment1:

START:
    LEA R0, DataSegment

    ADD R1, R1, 12
    NOP
    NOP
    NOP

    ADD R1, R1, -5
    NOP
    NOP
    NOP

    ADD R1, R1, 0
    NOP
    NOP
    NOP

    STR R1, R0, aacus

    AND R2, R0, 4x0F
    NOP
    NOP
    NOP

    STR R2, R0, joiner
    NOP
    NOP
    NOP

    LDR R3, R0, DEEB
    NOP
    NOP
    NOP
    LDR R4, R0, LEAF
    NOP
    NOP
    NOP
    LDR R5, R0, D22D
    NOP
    NOP
    NOP
    LDR R6, R0, LIFE
    NOP
    NOP
    NOP

    ADD R3, R3, R4
    NOP
    NOP
    NOP

    ADD R3, R3, R3
    NOP
    NOP
    NOP

    STR R3, R0, calcx

    AND R4, R5, R3
    NOP
    NOP
    NOP

    STR R4, R0, joiner

    NOT R5, R5
    NOP
    NOP
    NOP

    STR R5, R0, duh

    LDR R6, R0, FOED
    NOP
    NOP
    NOP

    LDR R7, R0, FOED
    NOP
    NOP
    NOP

    LSHF R6, R6, 8
    NOP
    NOP
    NOP

    RSHFL R7, R7, 3
    NOP
    NOP
    NOP

    RSHFA R6, R6, 6
    NOP
    NOP
    NOP

    STR R6, R0, fivespd
    NOP
    NOP
    NOP

    STR R7, R0, fivespd
    NOP
    NOP
    NOP

    LDR R1, R0, ZERO
    LDR R2, R0, ZERO
    LDR R3, R0, D22D
    LDR R4, R0, LIFE
    LDR R5, R0, FOED
    LDR R6, R0, DEEB
    LDR R7, R0, LEAF

SEGMENT CodeSegment2:

    LDR R1, R0, BOMB
    NOP
    NOP
    NOP

    LEA R2, HOWHIGH
    NOP
    NOP
    NOP
    JMP R2

    NOP
    NOP
    NOP

    LDR R1, R0, GOOF
    NOP
    NOP
    NOP

HOWHIGH:
    STR R1, R0, dunk
    NOP
    NOP
    NOP

    LDR R2, R0, DEEB
    NOP
    NOP
    NOP

    STR R2, R0, SPOT1
    LDR R3, R0, FOED
    LDR R4, R0, LEAF
    NOP
    NOP
    NOP
    STR R3, R0, SPOT2
    STR R4, R0, SPOT3
    LDR R5, R0, GOOD
    NOP
    NOP
    NOP
    STR R5, R0, SPOT4
    NOP
    NOP
    NOP

    LDR R5, R0, SPOT1
    LDR R4, R0, SPOT2
    LDR R3, R0, SPOT3
    LDR R2, R0, SPOT4
    STR R5, R0, SPOT4
    STR R4, R0, SPOT4
    STR R3, R0, SPOT4
    STR R2, R0, SPOT4
    NOP
    NOP
    NOP
    ADD R2, R2, R3
    NOP
    NOP
    NOP
    ADD R3, R4, R5
    NOP
    NOP
    NOP
    ADD R2, R2, R3
    NOP
    NOP
    NOP

    ADD R3, R0,1
    NOP
    NOP
    NOP

    STB R6, R3, ZOOP
    LDR R4, R0, ZOOP

    STB R7, R0, BEAD
    LDR R3, R0, BEAD
    NOP
    NOP
    NOP
    STR R3, R0, chew
    STR R4, R0, chew
    ADD R3, R3, R4

    LDR R4, R0, ZERO

    JSR MUDDLE

    STR R4, R0, MUDPIE

    LEA R5, MUDDLER
    NOP
    NOP
    NOP
    JSRR R5

    STR R5, R0, MUDPIE

    ADD R6, R0, 1
    NOP
    NOP
    NOP
    LDB R6, R6, COOKIE
    NOP

    LDB R7, R0, COOKIE
    NOP
    STR R6, R0, crumb
    NOP
    STR R7, R0, crumb
    NOP
    NOP
    NOP
    ADD R6, R6, R7

    TRAP FUN

    STR R6, R0, FUN

    LDR R1,R0, ZERO
    LDR R2,R0, ZERO
    LDR R3,R0, ZERO
    LDR R4,R0, GOOD
    LDR R5,R0, GOOD
    LDR R6,R0, GOOD

    LDI R1, R0, TEST
    NOP
    NOP
    NOP

    STI R4, R0, DONE
    NOP
    NOP
    NOP
    LDR R2, R0, RESULT

    STR R1, R0, GOOF
    STR R2, R0, GOOF
    NOP

    AND R3, R3, 0
    BRp DOH
    BRn DOH
    BRnp DOH
    BRz WOOHOO
    BRnz DOH
    BRnzp DOH

DOH:
    ADD R3, R3, 4

WOOHOO:
    ADD R3, R3, 6
    AND R4,R4,0
    BRz SOFAR
    ADD R3, R3, 1

SOFAR:
    ADD R3, R3, 6
    AND R4,R4,0

    BRnp DOH2

    NOP
    NOP
    NOP
    ADD R4, R4, 10
    NOP
    BRp SOGOOD
DOH2:
    ADD R3, R3, 6
    BRnzp GetOverHere
SOGOOD:
    ADD R3, R3, 3
    NOP
    NOP
    NOP
GetOverHere:
    ADD R3, R3, R4
    NOP
    NOP
    NOP
    STR R3, R0, GOOF


    STR R1, R0, SPOT1
    STR R2, R0, SPOT2
    STR R3, R0, SPOT3

    LEA R1, bouncer
END_m:
    JMP R1

SEGMENT DataSegment:

ZERO:   DATA2 4x0000
ZOOP :  DATA2 4x700F
BEAD :  DATA2 4xBEAD
FUN :   DATA2 HOPE
DEEB:   DATA2 4xDEEB
LEAF:   DATA2 4x1EAF
D22D:   DATA2 4xD22D
LIFE:   DATA2 4x0042
FOED:   DATA2 4xF0ED
BOMB:   DATA2 4xB006
GOOF:   DATA2 4x600F
dunk:   DATA2 4xdddd
RESULT: DATA2 4x0000
GOOD:   DATA2 4x600D
COOKIE: DATA2 4xD0CA
FOOB:   DATA2 4xF00B
aacus:  DATA2 4xFFFF

joiner: DATA2 4x1010
calcx:  DATA2 4x1234
fivespd:DATA2 4x8921
duh:    DATA2 4x9999
chew:   DATA2 4xcccc
crumb:  DATA2 4x6969
GAME:   DATA2 4xba11

SPOT1:  DATA2 4x8888
SPOT2:  DATA2 4xABCD
SPOT3:  DATA2 4x0110
SPOT4:  DATA2 4xABBA

TEST:   DATA2 GAME
DONE:   DATA2 RESULT
MUDPIE: DATA2 4x0000
BLUNDER:    DATA2 bouncer

MUDDLE:
    NOP
    NOP
    NOP
    ADD R4, R4,14
    RET

MUDDLER:

    LDR R5, R0, LIFE
    RET

HOPE:
    LDR R1,R0, GOOD
    LDR R2,R0, GOOD
    LDR R3,R0, GOOD
    LDR R4,R0, GOOD
    LDR R5,R0, GOOD
    LDR R6,R0, GOOD
    RET







SEGMENT bouncer:





Beg1:
    LEA R0, ThisDataSeg
    AND R1, R1, 0
    AND R2, R2, 0
    AND R3, R3, 0
    ADD R3, R3, 13
    ADD R2, R2, 4xB





    ADD R1, R2, R3
    ADD R4, R1, 3

    LSHF R2, R2, 3
    NOT R5, R3
    AND R3, R2, 15

    NOP
    NOP
    ADD R5, R3, R3

    ADD R1, R4, 5
    ADD R1, R4, 10
    ADD R1, R4, 14
    AND R2, R1, -1

    STR R2, R0, BlackHole
    STR R5, R0, BlackHole

    ADD R0, R0, 2
    STR R2, R0, BlackHole

    ADD R0, R0, -2
    LDR R3, R0, Photostat
    LDR R3, R0, LdThis
    STR R3, R0, Photostat

    LDR R3, R0, nosedive
    ADD R4, R3, 11

    LDR R3, R0, tailspin
    rshfl R4, R4, 1
    ADD R5, R3, 7

    LDI R1, R0, compass
    ADD R5, R5, 12
    ADD R1, R4, 12
    ADD R2, R3, 12

    STR R1, R0, beancounter
    STR R2, R0, beancounter
    STR R3, R0, beancounter
    STR R4, R0, beancounter
    STR R5, R0, beancounter

    ADD R5, R1, 0
    ADD R6, R3, 0
    ADD R7, R4, 0

    AND R1, R1, 0
    AND R3, R3, 0
    AND R4, R4, 0
    ADD R1, R1, 8
    ADD R3, R3, 2
    ADD R4, R4, 2

    BRp T1
    ADD R3, R3, 1
T1:
    ADD R1, R1, 9
    BRn T2
    ADD R4, R4, 1

    LDR R0, R0, beancounter

    LEA R0, DataSegment
    LDR R2, R0, SPOT1
    LDR R6, R0, SPOT2
    LDR R7, R0, SPOT3

    LEA R0, ThisDataSeg
    AND R3, R3, 0
    AND R4, R4, 0
    NOP
    ADD R3, R3, 2
    ADD R4, R4, 3

T2:
    LDR R1, R0, pessimist
    BRn T3
    ADD R3, R3, 1
T3:
    LDR R1, R0, optimist
    BRz T4
    ADD R4, R4, 1
T4:
    LDI R1, R0, gloomy
    BRnz T5
    ADD R3, R3, 1
T5:
    LDI R1, R0, compass
    BRnz T6
    ADD R4, R4, 1
T6:
    AND R1, R0, 0

    LEA R1, ThisDataSeg
    BRp T7
    ADD R3, R3, 1

T7:
    STR R3, R0, cc1
    STR R4, R0, cc2

    AND R1, R1, 0
    AND R5, R5, 0

    ADD R1, R1, -1
    BRn T10
    ADD R5, R5, 1
    ADD R1, R1, -7
T10:
    ADD R5, R1, R5
    NOP
    NOP
    NOP
    STR R5, R0, acorn
    ADD R0, R5, 0

SEGMENT GoofyCode:
    AND R5, R5, 0

    LEA R1, GetHere
    JMP R1
    ADD R5, R5, 1

GetHere:
    ADD R5, R0, R5
    LEA R0, DataSegment
    nop
    nop
    nop
    LDR R1, R0, FUN
    LEA R0, ThisDataSeg
    STR R5, R0, BlackHole

    brnzp MoneyMoney

SEGMENT ThisDataSeg:
BlackHole:  DATA2 0
WormHole:   DATA2 0
LdThis:     DATA2 4xabda
Photostat:  DATA2 0
nosedive:   DATA2 4x9A4D
tailspin:   DATA2 4x3DAC
compass:    DATA2 quark
beancounter:    DATA2 4xfadd
pessimist:  DATA2 4xFB03
optimist:   DATA2 4x0111
gloomy:     DATA2 pessimist
cc1:        DATA2 4xf00f
cc2:        DATA2 4xf00f
acorn:      DATA2 4x0FEE
quark:      DATA2 4x276C
payout:     DATA2 MoneyMoney

SEGMENT MoneyMoney:

    AND R7, R7, 0
    AND R6, R6, 0
    AND R5, R5, 0
    AND R4, R4, 0
    AND R3, R3, 0
    AND R2, R2, 0
    AND R1, R1, 0
    AND R0, R0, 0

    LEA R0, DataSegmentMtest

    LEA R1, Matrix1
    LDR R2, R0, Counter2
    LDR R3, R0, TWOFIVESIX
FillM1:
    STR R2, R1, 0
    ADD R2, R2, -7
    ADD R1, R1, 2
    ADD R3, R3, -1
    BRp FillM1

    LEA R4, Matrix1
    LDR R2, R0, TWOFIVESIX
    ADD R4, R2, R4
    LDR R3, R0, Counter2
    AND R1, R1, 0
    AND R2, R2, 0

FILLM2:
    JSR CalAddress
    ADD R6, R5, R4
    STR  R3, R6, 0
    ADD R3, R3, -2
    JSR CalNext2
    ADD R5, R1, 0
    BRzp FillM2

    LEA R4,  Matrix1
    LDR R2, R0, TWOFIVESIX
    ADD R4, R2, R4
    ADD R4, R2, R4
    LDR R3, R0, Counter2
    AND R1, R1, 0
    AND R2, R2, 0
FILLM3:
    JSR CalAddress
    ADD R6, R5, R4
    STR  R3, R6, 0
    ADD R3, R3, -5
    JSR CalNext3
    ADD R5, R1, 0
    BRzp FillM3

    LEA R3, Matrix1
    LDR R4, R0, TWOFIVESIX
    ADD R4, R3, R4
    AND R6, R6, 0

Continue1_2:

    LDR R1, R0, X2
    LDR R2, R0, Y2
    JSR CalAddress
    ADD R7, R5, R4
    LDR R6, R7, 0
    JSR CALNEXT3
    STR R1, R0, X2
    STR R2, R0, Y2
    
    LDR R1, R0, X1
    LDR R2, R0, Y1
    JSR CalAddress
    ADD R5, R5, R3
    LDR R7, R5, 0
    ADD R6, R6, R7
    STR R6, R5, 0
    
    JSR CALNEXT2
    ADD R7, R1, 0
    BRn Done3
    STR R1, R0, X1
    STR R2, R0, Y1
    
    BRnzp COntinue1_2
Done3:

    AND R1, R1, 0
    STR  R1, R0, X1
    STR R1, R0, X2
    STR  R1, R0, Y1
    STR  R1, R0, Y2
    
    LEA R3,  Matrix1
    LDR R4, R0, TWOFIVESIX
    ADD R4, R4, R4
    ADD R4, R3, R4
    AND R6, R6, 0

Continue1_3:

    LDR R1, R0, X2
    LDR R2, R0, Y2
    JSR CalAddress
    ADD R7, R5, R3
    LDR R6, R7, 0
    JSR CALNEXT1
    STR R1, R0, X2
    STR R2, R0, Y2
    
    LDR R1, R0, X1
    LDR R2, R0, Y1
    JSR CalAddress
    ADD R5, R5, R4
    LDR R7, R5, 0
    ADD R6, R6, R7
    STR R6, R5, 0
    
    JSR CALNEXT3
    ADD R7, R1, 0
    BRn Done4
    STR R1, R0, X1
    STR R2, R0, Y1
    
    BRnzp COntinue1_3
Done4:

    BRnzp CheckSUM

CalNEXT1:

    ADD R5, R1, -15
    BRz Ytest
    ADD R1, R1, 1
    BRnzp SKIP

YTEST:
    ADD R5, R2, -15
    BRz DoneFor
    ADD R2, R2, 1
    AND R1, R1, 0
    BRnzp SKIP

DoneFor:
    AND R1, R1, 0
    ADD R1, R1, -1

SKip:
    RET

CalNEXT2:

    ADD R5, R2, -15
    BRz Xtest
    ADD R2, R2, 1
    BRnzp SKIP1

XTEST:
    ADD R5, R1, -15
    BRz Done1
    ADD R1, R1, 1
    AND R2, R2, 0
    BRnzp SKIP1

Done1:
    AND R1, R1, 0
    ADD R1, R1, -1

SKip1:
    RET

CalNEXT3:

    STR R3, R0, TEMP3
    
    ADD R3, R1, -15
    BRz DRow
    ADD R3, R2, 0
    BRz DRow1
    LDR R3, R0, NEGONEFIVE
    ADD R3, R1, -15
    BRz DRow
    
    ADD R1, R1, 1
    ADD R2, R2, -1
    BRnzp SKIP2

DRow1:
    ADD R2, R1, 1
    AND R1, R1, 0
    BRnzp SKIP2

DRow:
    ADD R3, R2, -15
    BRz Done2

    ADD R1, R2, 1
    AND R2, R2, 0
    ADD R2, R2, 15
    BRnzp SKIP2

Done2:
    AND R1, R1, 0
    ADD R1, R1, -1

SKIP2:
    LDR R3, R0, TEMP3
    RET

CalAddress:
    LSHF R5, R2, 4
    ADD R5, R1, R5
    LSHF R5, R5, 1
    RET

CHECKSUM:

    LEA  R1, Matrix1
    LDR R4, R0, TWOFIVESIX
    ADD R4, R4, R4
    ADD R1, R4, R1
    AND R7, R7, 0
    AND R6, R6, 0
    AND R5, R5, 0
    AND R4, R4, 0

    LDR  R2, R0, ONEFOURTHREE
LoopRowsA:
    LDR  R3, R1, 0
    ADD R4, R3, R4
    ADD R1, R1, 2
    ADD R2, R2, -1
    BRzp LoopRowsA
    
    LSHF R4,R4,2
    
    LDR  R2, R0, ONEFOURTHREE
LoopRowsB:
    LDR  R3, R1, 0
    ADD R5, R3, R5
    ADD R1, R1, 2
    ADD R2, R2, -1
    BRzp LoopRowsB

    LSHF R5,R5,2
    
    LDR  R2, R0, ONEFOURTHREE
LoopRowsC:
    LDR  R3, R1, 0
    ADD R6, R3, R6
    ADD R1, R1, 2
    ADD R2, R2, -1
    BRzp LoopRowsC
    
    LSHF R6,R6,2
    
    LDR  R2, R0, ONEFOURTHREE
LoopRowsD:
    LDR  R3, R1, 0
    ADD R7, R3, R7
    ADD R1, R1, 2
    ADD R2, R2, -1
    BRzp LoopRowsD
    
    AND R3, R3,R7
    NOT R7,R7
    
    
    
    HALT:
    BRnzp HALT




SEGMENT DataSegmentMtest:

X1:             DATA2    4x0000
Y1:             DATA2    4x0000
X2:             DATA2    4x0000
Y2:             DATA2    4x0000
TEMP1:          DATA2    4x0000
TEMP2:          DATA2    4x0000
TEMP3:          DATA2    4x0000
TEMP4:          DATA2    4x0000
TWOFIVESIX:     DATA2       256
UpperMemStart:  DATA2    4xF000
Counter1:       DATA2    4x0FFF
Counter2:       DATA2    4x4A3F
ONEFOURTHREE:   DATA2        63
NEGONEFIVE:     DATA2       -15
Mask:           Data2    4x00FF

SEGMENT Matrix1:

M00:    DATA2           4x0000
M01:    DATA2           4x0000
M02:    DATA2           4x0000
M03:    DATA2           4x0000
M04:    DATA2           4x0000
M05:    DATA2           4x0000
M06:    DATA2           4x0000
M07:    DATA2           4x0000
M08:    DATA2           4x0000
M09:    DATA2           4x0000
M0A:    DATA2           4x0000
M0B:    DATA2           4x0000
M0C:    DATA2           4x0000
M0D:    DATA2           4x0000
M0E:    DATA2           4x0000
M0F:    DATA2           4x0000

M10:    DATA2           4x0000
M11:    DATA2           4x0000
M12:    DATA2           4x0000
M13:    DATA2           4x0000
M14:    DATA2           4x0000
M15:    DATA2           4x0000
M16:    DATA2           4x0000
M17:    DATA2           4x0000
M18:    DATA2           4x0000
M19:    DATA2           4x0000
M1A:    DATA2           4x0000
M1B:    DATA2           4x0000
M1C:    DATA2           4x0000
M1D:    DATA2           4x0000
M1E:    DATA2           4x0000
M1F:    DATA2           4x0000

M20:    DATA2           4x0000
M21:    DATA2           4x0000
M22:    DATA2           4x0000
M23:    DATA2           4x0000
M24:    DATA2           4x0000
M25:    DATA2           4x0000
M26:    DATA2           4x0000
M27:    DATA2           4x0000
M28:    DATA2           4x0000
M29:    DATA2           4x0000
M2A:    DATA2           4x0000
M2B:    DATA2           4x0000
M2C:    DATA2           4x0000
M2D:    DATA2           4x0000
M2E:    DATA2           4x0000
M2F:    DATA2           4x0000

M30:    DATA2           4x0000
M31:    DATA2           4x0000
M32:    DATA2           4x0000
M33:    DATA2           4x0000
M34:    DATA2           4x0000
M35:    DATA2           4x0000
M36:    DATA2           4x0000
M37:    DATA2           4x0000
M38:    DATA2           4x0000
M39:    DATA2           4x0000
M3A:    DATA2           4x0000
M3B:    DATA2           4x0000
M3C:    DATA2           4x0000
M3D:    DATA2           4x0000
M3E:    DATA2           4x0000
M3F:    DATA2           4x0000

M40:    DATA2           4x0000
M41:    DATA2           4x0000
M42:    DATA2           4x0000
M43:    DATA2           4x0000
M44:    DATA2           4x0000
M45:    DATA2           4x0000
M46:    DATA2           4x0000
M47:    DATA2           4x0000
M48:    DATA2           4x0000
M49:    DATA2           4x0000
M4A:    DATA2           4x0000
M4B:    DATA2           4x0000
M4C:    DATA2           4x0000
M4D:    DATA2           4x0000
M4E:    DATA2           4x0000
M4F:    DATA2           4x0000

M50:    DATA2           4x0000
M51:    DATA2           4x0000
M52:    DATA2           4x0000
M53:    DATA2           4x0000
M54:    DATA2           4x0000
M55:    DATA2           4x0000
M56:    DATA2           4x0000
M57:    DATA2           4x0000
M58:    DATA2           4x0000
M59:    DATA2           4x0000
M5A:    DATA2           4x0000
M5B:    DATA2           4x0000
M5C:    DATA2           4x0000
M5D:    DATA2           4x0000
M5E:    DATA2           4x0000
M5F:    DATA2           4x0000

M60:    DATA2           4x0000
M61:    DATA2           4x0000
M62:    DATA2           4x0000
M63:    DATA2           4x0000
M64:    DATA2           4x0000
M65:    DATA2           4x0000
M66:    DATA2           4x0000
M67:    DATA2           4x0000
M68:    DATA2           4x0000
M69:    DATA2           4x0000
M6A:    DATA2           4x0000
M6B:    DATA2           4x0000
M6C:    DATA2           4x0000
M6D:    DATA2           4x0000
M6E:    DATA2           4x0000
M6F:    DATA2           4x0000

M70:    DATA2           4x0000
M71:    DATA2           4x0000
M72:    DATA2           4x0000
M73:    DATA2           4x0000
M74:    DATA2           4x0000
M75:    DATA2           4x0000
M76:    DATA2           4x0000
M77:    DATA2           4x0000
M78:    DATA2           4x0000
M79:    DATA2           4x0000
M7A:    DATA2           4x0000
M7B:    DATA2           4x0000
M7C:    DATA2           4x0000
M7D:    DATA2           4x0000
M7E:    DATA2           4x0000
M7F:    DATA2           4x0000

M80:    DATA2           4x0000
M81:    DATA2           4x0000
M82:    DATA2           4x0000
M83:    DATA2           4x0000
M84:    DATA2           4x0000
M85:    DATA2           4x0000
M86:    DATA2           4x0000
M87:    DATA2           4x0000
M88:    DATA2           4x0000
M89:    DATA2           4x0000
M8A:    DATA2           4x0000
M8B:    DATA2           4x0000
M8C:    DATA2           4x0000
M8D:    DATA2           4x0000
M8E:    DATA2           4x0000
M8F:    DATA2           4x0000

M90:    DATA2           4x0000
M91:    DATA2           4x0000
M92:    DATA2           4x0000
M93:    DATA2           4x0000
M94:    DATA2           4x0000
M95:    DATA2           4x0000
M96:    DATA2           4x0000
M97:    DATA2           4x0000
M98:    DATA2           4x0000
M99:    DATA2           4x0000
M9A:    DATA2           4x0000
M9B:    DATA2           4x0000
M9C:    DATA2           4x0000
M9D:    DATA2           4x0000
M9E:    DATA2           4x0000
M9F:    DATA2           4x0000

MA0:    DATA2           4x0000
MA1:    DATA2           4x0000
MA2:    DATA2           4x0000
MA3:    DATA2           4x0000
MA4:    DATA2           4x0000
MA5:    DATA2           4x0000
MA6:    DATA2           4x0000
MA7:    DATA2           4x0000
MA8:    DATA2           4x0000
MA9:    DATA2           4x0000
MAA:    DATA2           4x0000
MAB:    DATA2           4x0000
MAC:    DATA2           4x0000
MAD:    DATA2           4x0000
MAE:    DATA2           4x0000
MAF:    DATA2           4x0000

MB0:    DATA2           4x0000
MB1:    DATA2           4x0000
MB2:    DATA2           4x0000
MB3:    DATA2           4x0000
MB4:    DATA2           4x0000
MB5:    DATA2           4x0000
MB6:    DATA2           4x0000
MB7:    DATA2           4x0000
MB8:    DATA2           4x0000
MB9:    DATA2           4x0000
MBA:    DATA2           4x0000
MBB:    DATA2           4x0000
MBC:    DATA2           4x0000
MBD:    DATA2           4x0000
MBE:    DATA2           4x0000
MBF:    DATA2           4x0000

MC0:    DATA2           4x0000
MC1:    DATA2           4x0000
MC2:    DATA2           4x0000
MC3:    DATA2           4x0000
MC4:    DATA2           4x0000
MC5:    DATA2           4x0000
MC6:    DATA2           4x0000
MC7:    DATA2           4x0000
MC8:    DATA2           4x0000
MC9:    DATA2           4x0000
MCA:    DATA2           4x0000
MCB:    DATA2           4x0000
MCC:    DATA2           4x0000
MCD:    DATA2           4x0000
MCE:    DATA2           4x0000
MCF:    DATA2           4x0000

MD0:    DATA2           4x0000
MD1:    DATA2           4x0000
MD2:    DATA2           4x0000
MD3:    DATA2           4x0000
MD4:    DATA2           4x0000
MD5:    DATA2           4x0000
MD6:    DATA2           4x0000
MD7:    DATA2           4x0000
MD8:    DATA2           4x0000
MD9:    DATA2           4x0000
MDA:    DATA2           4x0000
MDB:    DATA2           4x0000
MDC:    DATA2           4x0000
MDD:    DATA2           4x0000
MDE:    DATA2           4x0000
MDF:    DATA2           4x0000

ME0:    DATA2           4x0000
ME1:    DATA2           4x0000
ME2:    DATA2           4x0000
ME3:    DATA2           4x0000
ME4:    DATA2           4x0000
ME5:    DATA2           4x0000
ME6:    DATA2           4x0000
ME7:    DATA2           4x0000
ME8:    DATA2           4x0000
ME9:    DATA2           4x0000
MEA:    DATA2           4x0000
MEB:    DATA2           4x0000
MEC:    DATA2           4x0000
MED:    DATA2           4x0000
MEE:    DATA2           4x0000
MEF:    DATA2           4x0000

MF0:    DATA2           4x0000
MF1:    DATA2           4x0000
MF2:    DATA2           4x0000
MF3:    DATA2           4x0000
MF4:    DATA2           4x0000
MF5:    DATA2           4x0000
MF6:    DATA2           4x0000
MF7:    DATA2           4x0000
MF8:    DATA2           4x0000
MF9:    DATA2           4x0000
MFA:    DATA2           4x0000
MFB:    DATA2           4x0000
MFC:    DATA2           4x0000
MFD:    DATA2           4x0000
MFE:    DATA2           4x0000
MFF:    DATA2           4x0000





SEGMENT Matrix2:

N00:    DATA2           4x0000
N01:    DATA2           4x0000
N02:    DATA2           4x0000
N03:    DATA2           4x0000
N04:    DATA2           4x0000
N05:    DATA2           4x0000
N06:    DATA2           4x0000
N07:    DATA2           4x0000
N08:    DATA2           4x0000
N09:    DATA2           4x0000
N0A:    DATA2           4x0000
N0B:    DATA2           4x0000
N0C:    DATA2           4x0000
N0D:    DATA2           4x0000
N0E:    DATA2           4x0000
N0F:    DATA2           4x0000

N10:    DATA2           4x0000
N11:    DATA2           4x0000
N12:    DATA2           4x0000
N13:    DATA2           4x0000
N14:    DATA2           4x0000
N15:    DATA2           4x0000
N16:    DATA2           4x0000
N17:    DATA2           4x0000
N18:    DATA2           4x0000
N19:    DATA2           4x0000
N1A:    DATA2           4x0000
N1B:    DATA2           4x0000
N1C:    DATA2           4x0000
N1D:    DATA2           4x0000
N1E:    DATA2           4x0000
N1F:    DATA2           4x0000

N20:    DATA2           4x0000
N21:    DATA2           4x0000
N22:    DATA2           4x0000
N23:    DATA2           4x0000
N24:    DATA2           4x0000
N25:    DATA2           4x0000
N26:    DATA2           4x0000
N27:    DATA2           4x0000
N28:    DATA2           4x0000
N29:    DATA2           4x0000
N2A:    DATA2           4x0000
N2B:    DATA2           4x0000
N2C:    DATA2           4x0000
N2D:    DATA2           4x0000
N2E:    DATA2           4x0000
N2F:    DATA2           4x0000

N30:    DATA2           4x0000
N31:    DATA2           4x0000
N32:    DATA2           4x0000
N33:    DATA2           4x0000
N34:    DATA2           4x0000
N35:    DATA2           4x0000
N36:    DATA2           4x0000
N37:    DATA2           4x0000
N38:    DATA2           4x0000
N39:    DATA2           4x0000
N3A:    DATA2           4x0000
N3B:    DATA2           4x0000
N3C:    DATA2           4x0000
N3D:    DATA2           4x0000
N3E:    DATA2           4x0000
N3F:    DATA2           4x0000

N40:    DATA2           4x0000
N41:    DATA2           4x0000
N42:    DATA2           4x0000
N43:    DATA2           4x0000
N44:    DATA2           4x0000
N45:    DATA2           4x0000
N46:    DATA2           4x0000
N47:    DATA2           4x0000
N48:    DATA2           4x0000
N49:    DATA2           4x0000
N4A:    DATA2           4x0000
N4B:    DATA2           4x0000
N4C:    DATA2           4x0000
N4D:    DATA2           4x0000
N4E:    DATA2           4x0000
N4F:    DATA2           4x0000

N50:    DATA2           4x0000
N51:    DATA2           4x0000
N52:    DATA2           4x0000
N53:    DATA2           4x0000
N54:    DATA2           4x0000
N55:    DATA2           4x0000
N56:    DATA2           4x0000
N57:    DATA2           4x0000
N58:    DATA2           4x0000
N59:    DATA2           4x0000
N5A:    DATA2           4x0000
N5B:    DATA2           4x0000
N5C:    DATA2           4x0000
N5D:    DATA2           4x0000
N5E:    DATA2           4x0000
N5F:    DATA2           4x0000

N60:    DATA2           4x0000
N61:    DATA2           4x0000
N62:    DATA2           4x0000
N63:    DATA2           4x0000
N64:    DATA2           4x0000
N65:    DATA2           4x0000
N66:    DATA2           4x0000
N67:    DATA2           4x0000
N68:    DATA2           4x0000
N69:    DATA2           4x0000
N6A:    DATA2           4x0000
N6B:    DATA2           4x0000
N6C:    DATA2           4x0000
N6D:    DATA2           4x0000
N6E:    DATA2           4x0000
N6F:    DATA2           4x0000

N70:    DATA2           4x0000
N71:    DATA2           4x0000
N72:    DATA2           4x0000
N73:    DATA2           4x0000
N74:    DATA2           4x0000
N75:    DATA2           4x0000
N76:    DATA2           4x0000
N77:    DATA2           4x0000
N78:    DATA2           4x0000
N79:    DATA2           4x0000
N7A:    DATA2           4x0000
N7B:    DATA2           4x0000
N7C:    DATA2           4x0000
N7D:    DATA2           4x0000
N7E:    DATA2           4x0000
N7F:    DATA2           4x0000

N80:    DATA2           4x0000
N81:    DATA2           4x0000
N82:    DATA2           4x0000
N83:    DATA2           4x0000
N84:    DATA2           4x0000
N85:    DATA2           4x0000
N86:    DATA2           4x0000
N87:    DATA2           4x0000
N88:    DATA2           4x0000
N89:    DATA2           4x0000
N8A:    DATA2           4x0000
N8B:    DATA2           4x0000
N8C:    DATA2           4x0000
N8D:    DATA2           4x0000
N8E:    DATA2           4x0000
N8F:    DATA2           4x0000

N90:    DATA2           4x0000
N91:    DATA2           4x0000
N92:    DATA2           4x0000
N93:    DATA2           4x0000
N94:    DATA2           4x0000
N95:    DATA2           4x0000
N96:    DATA2           4x0000
N97:    DATA2           4x0000
N98:    DATA2           4x0000
N99:    DATA2           4x0000
N9A:    DATA2           4x0000
N9B:    DATA2           4x0000
N9C:    DATA2           4x0000
N9D:    DATA2           4x0000
N9E:    DATA2           4x0000
N9F:    DATA2           4x0000

NA0:    DATA2           4x0000
NA1:    DATA2           4x0000
NA2:    DATA2           4x0000
NA3:    DATA2           4x0000
NA4:    DATA2           4x0000
NA5:    DATA2           4x0000
NA6:    DATA2           4x0000
NA7:    DATA2           4x0000
NA8:    DATA2           4x0000
NA9:    DATA2           4x0000
NAA:    DATA2           4x0000
NAB:    DATA2           4x0000
NAC:    DATA2           4x0000
NAD:    DATA2           4x0000
NAE:    DATA2           4x0000
NAF:    DATA2           4x0000

NB0:    DATA2           4x0000
NB1:    DATA2           4x0000
NB2:    DATA2           4x0000
NB3:    DATA2           4x0000
NB4:    DATA2           4x0000
NB5:    DATA2           4x0000
NB6:    DATA2           4x0000
NB7:    DATA2           4x0000
NB8:    DATA2           4x0000
NB9:    DATA2           4x0000
NBA:    DATA2           4x0000
NBB:    DATA2           4x0000
NBC:    DATA2           4x0000
NBD:    DATA2           4x0000
NBE:    DATA2           4x0000
NBF:    DATA2           4x0000

NC0:    DATA2           4x0000
NC1:    DATA2           4x0000
NC2:    DATA2           4x0000
NC3:    DATA2           4x0000
NC4:    DATA2           4x0000
NC5:    DATA2           4x0000
NC6:    DATA2           4x0000
NC7:    DATA2           4x0000
NC8:    DATA2           4x0000
NC9:    DATA2           4x0000
NCA:    DATA2           4x0000
NCB:    DATA2           4x0000
NCC:    DATA2           4x0000
NCD:    DATA2           4x0000
NCE:    DATA2           4x0000
NCF:    DATA2           4x0000

ND0:    DATA2           4x0000
ND1:    DATA2           4x0000
ND2:    DATA2           4x0000
ND3:    DATA2           4x0000
ND4:    DATA2           4x0000
ND5:    DATA2           4x0000
ND6:    DATA2           4x0000
ND7:    DATA2           4x0000
ND8:    DATA2           4x0000
ND9:    DATA2           4x0000
NDA:    DATA2           4x0000
NDB:    DATA2           4x0000
NDC:    DATA2           4x0000
NDD:    DATA2           4x0000
NDE:    DATA2           4x0000
NDF:    DATA2           4x0000

NE0:    DATA2           4x0000
NE1:    DATA2           4x0000
NE2:    DATA2           4x0000
NE3:    DATA2           4x0000
NE4:    DATA2           4x0000
NE5:    DATA2           4x0000
NE6:    DATA2           4x0000
NE7:    DATA2           4x0000
NE8:    DATA2           4x0000
NE9:    DATA2           4x0000
NEA:    DATA2           4x0000
NEB:    DATA2           4x0000
NEC:    DATA2           4x0000
NED:    DATA2           4x0000
NEE:    DATA2           4x0000
NEF:    DATA2           4x0000

NF0:    DATA2           4x0000
NF1:    DATA2           4x0000
NF2:    DATA2           4x0000
NF3:    DATA2           4x0000
NF4:    DATA2           4x0000
NF5:    DATA2           4x0000
NF6:    DATA2           4x0000
NF7:    DATA2           4x0000
NF8:    DATA2           4x0000
NF9:    DATA2           4x0000
NFA:    DATA2           4x0000
NFB:    DATA2           4x0000
NFC:    DATA2           4x0000
NFD:    DATA2           4x0000
NFE:    DATA2           4x0000
NFF:    DATA2           4x0000


SEGMENT Matrix3:

O00:    DATA2           4x0000
O01:    DATA2           4x0000
O02:    DATA2           4x0000
O03:    DATA2           4x0000
O04:    DATA2           4x0000
O05:    DATA2           4x0000
O06:    DATA2           4x0000
O07:    DATA2           4x0000
O08:    DATA2           4x0000
O09:    DATA2           4x0000
O0A:    DATA2           4x0000
O0B:    DATA2           4x0000
O0C:    DATA2           4x0000
O0D:    DATA2           4x0000
O0E:    DATA2           4x0000
O0F:    DATA2           4x0000

O10:    DATA2           4x0000
O11:    DATA2           4x0000
O12:    DATA2           4x0000
O13:    DATA2           4x0000
O14:    DATA2           4x0000
O15:    DATA2           4x0000
O16:    DATA2           4x0000
O17:    DATA2           4x0000
O18:    DATA2           4x0000
O19:    DATA2           4x0000
O1A:    DATA2           4x0000
O1B:    DATA2           4x0000
O1C:    DATA2           4x0000
O1D:    DATA2           4x0000
O1E:    DATA2           4x0000
O1F:    DATA2           4x0000

O20:    DATA2           4x0000
O21:    DATA2           4x0000
O22:    DATA2           4x0000
O23:    DATA2           4x0000
O24:    DATA2           4x0000
O25:    DATA2           4x0000
O26:    DATA2           4x0000
O27:    DATA2           4x0000
O28:    DATA2           4x0000
O29:    DATA2           4x0000
O2A:    DATA2           4x0000
O2B:    DATA2           4x0000
O2C:    DATA2           4x0000
O2D:    DATA2           4x0000
O2E:    DATA2           4x0000
O2F:    DATA2           4x0000

O30:    DATA2           4x0000
O31:    DATA2           4x0000
O32:    DATA2           4x0000
O33:    DATA2           4x0000
O34:    DATA2           4x0000
O35:    DATA2           4x0000
O36:    DATA2           4x0000
O37:    DATA2           4x0000
O38:    DATA2           4x0000
O39:    DATA2           4x0000
O3A:    DATA2           4x0000
O3B:    DATA2           4x0000
O3C:    DATA2           4x0000
O3D:    DATA2           4x0000
O3E:    DATA2           4x0000
O3F:    DATA2           4x0000

O40:    DATA2           4x0000
O41:    DATA2           4x0000
O42:    DATA2           4x0000
O43:    DATA2           4x0000
O44:    DATA2           4x0000
O45:    DATA2           4x0000
O46:    DATA2           4x0000
O47:    DATA2           4x0000
O48:    DATA2           4x0000
O49:    DATA2           4x0000
O4A:    DATA2           4x0000
O4B:    DATA2           4x0000
O4C:    DATA2           4x0000
O4D:    DATA2           4x0000
O4E:    DATA2           4x0000
O4F:    DATA2           4x0000

O50:    DATA2           4x0000
O51:    DATA2           4x0000
O52:    DATA2           4x0000
O53:    DATA2           4x0000
O54:    DATA2           4x0000
O55:    DATA2           4x0000
O56:    DATA2           4x0000
O57:    DATA2           4x0000
O58:    DATA2           4x0000
O59:    DATA2           4x0000
O5A:    DATA2           4x0000
O5B:    DATA2           4x0000
O5C:    DATA2           4x0000
O5D:    DATA2           4x0000
O5E:    DATA2           4x0000
O5F:    DATA2           4x0000

O60:    DATA2           4x0000
O61:    DATA2           4x0000
O62:    DATA2           4x0000
O63:    DATA2           4x0000
O64:    DATA2           4x0000
O65:    DATA2           4x0000
O66:    DATA2           4x0000
O67:    DATA2           4x0000
O68:    DATA2           4x0000
O69:    DATA2           4x0000
O6A:    DATA2           4x0000
O6B:    DATA2           4x0000
O6C:    DATA2           4x0000
O6D:    DATA2           4x0000
O6E:    DATA2           4x0000
O6F:    DATA2           4x0000

O70:    DATA2           4x0000
O71:    DATA2           4x0000
O72:    DATA2           4x0000
O73:    DATA2           4x0000
O74:    DATA2           4x0000
O75:    DATA2           4x0000
O76:    DATA2           4x0000
O77:    DATA2           4x0000
O78:    DATA2           4x0000
O79:    DATA2           4x0000
O7A:    DATA2           4x0000
O7B:    DATA2           4x0000
O7C:    DATA2           4x0000
O7D:    DATA2           4x0000
O7E:    DATA2           4x0000
O7F:    DATA2           4x0000

O80:    DATA2           4x0000
O81:    DATA2           4x0000
O82:    DATA2           4x0000
O83:    DATA2           4x0000
O84:    DATA2           4x0000
O85:    DATA2           4x0000
O86:    DATA2           4x0000
O87:    DATA2           4x0000
O88:    DATA2           4x0000
O89:    DATA2           4x0000
O8A:    DATA2           4x0000
O8B:    DATA2           4x0000
O8C:    DATA2           4x0000
O8D:    DATA2           4x0000
O8E:    DATA2           4x0000
O8F:    DATA2           4x0000

O90:    DATA2           4x0000
O91:    DATA2           4x0000
O92:    DATA2           4x0000
O93:    DATA2           4x0000
O94:    DATA2           4x0000
O95:    DATA2           4x0000
O96:    DATA2           4x0000
O97:    DATA2           4x0000
O98:    DATA2           4x0000
O99:    DATA2           4x0000
O9A:    DATA2           4x0000
O9B:    DATA2           4x0000
O9C:    DATA2           4x0000
O9D:    DATA2           4x0000
O9E:    DATA2           4x0000
O9F:    DATA2           4x0000

OA0:    DATA2           4x0000
OA1:    DATA2           4x0000
OA2:    DATA2           4x0000
OA3:    DATA2           4x0000
OA4:    DATA2           4x0000
OA5:    DATA2           4x0000
OA6:    DATA2           4x0000
OA7:    DATA2           4x0000
OA8:    DATA2           4x0000
OA9:    DATA2           4x0000
OAA:    DATA2           4x0000
OAB:    DATA2           4x0000
OAC:    DATA2           4x0000
OAD:    DATA2           4x0000
OAE:    DATA2           4x0000
OAF:    DATA2           4x0000

OB0:    DATA2           4x0000
OB1:    DATA2           4x0000
OB2:    DATA2           4x0000
OB3:    DATA2           4x0000
OB4:    DATA2           4x0000
OB5:    DATA2           4x0000
OB6:    DATA2           4x0000
OB7:    DATA2           4x0000
OB8:    DATA2           4x0000
OB9:    DATA2           4x0000
OBA:    DATA2           4x0000
OBB:    DATA2           4x0000
OBC:    DATA2           4x0000
OBD:    DATA2           4x0000
OBE:    DATA2           4x0000
OBF:    DATA2           4x0000

OC0:    DATA2           4x0000
OC1:    DATA2           4x0000
OC2:    DATA2           4x0000
OC3:    DATA2           4x0000
OC4:    DATA2           4x0000
OC5:    DATA2           4x0000
OC6:    DATA2           4x0000
OC7:    DATA2           4x0000
OC8:    DATA2           4x0000
OC9:    DATA2           4x0000
OCA:    DATA2           4x0000
OCB:    DATA2           4x0000
OCC:    DATA2           4x0000
OCD:    DATA2           4x0000
OCE:    DATA2           4x0000
OCF:    DATA2           4x0000

OD0:    DATA2           4x0000
OD1:    DATA2           4x0000
OD2:    DATA2           4x0000
OD3:    DATA2           4x0000
OD4:    DATA2           4x0000
OD5:    DATA2           4x0000
OD6:    DATA2           4x0000
OD7:    DATA2           4x0000
OD8:    DATA2           4x0000
OD9:    DATA2           4x0000
ODA:    DATA2           4x0000
ODB:    DATA2           4x0000
ODC:    DATA2           4x0000
ODD:    DATA2           4x0000
ODE:    DATA2           4x0000
ODF:    DATA2           4x0000

OE0:    DATA2           4x0000
OE1:    DATA2           4x0000
OE2:    DATA2           4x0000
OE3:    DATA2           4x0000
OE4:    DATA2           4x0000
OE5:    DATA2           4x0000
OE6:    DATA2           4x0000
OE7:    DATA2           4x0000
OE8:    DATA2           4x0000
OE9:    DATA2           4x0000
OEA:    DATA2           4x0000
OEB:    DATA2           4x0000
OEC:    DATA2           4x0000
OED:    DATA2           4x0000
OEE:    DATA2           4x0000
OEF:    DATA2           4x0000

OF0:    DATA2           4x0000
OF1:    DATA2           4x0000
OF2:    DATA2           4x0000
OF3:    DATA2           4x0000
OF4:    DATA2           4x0000
OF5:    DATA2           4x0000
OF6:    DATA2           4x0000
OF7:    DATA2           4x0000
OF8:    DATA2           4x0000
OF9:    DATA2           4x0000
OFA:    DATA2           4x0000
OFB:    DATA2           4x0000
OFC:    DATA2           4x0000
OFD:    DATA2           4x0000
OFE:    DATA2           4x0000
OFF:    DATA2           4x0000

