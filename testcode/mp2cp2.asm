ORIGIN 0
SEGMENT 0 CODE:
	LDR R1, R0, l1p
	LDR R2, R0, l2p
	LDR R3, R0, l3p
	LDR R4, R1, 0 ; cache miss, loads line1
	LDR R5, R2, 0 ; cache miss, loads line2
	LDR R6, R1, 0 ; cache hit,  sets line2 as LRU
	LDR R7, R3, 0 ; cache miss, evicts line2, loads line3
	LDR R0, R1, 0 ; cache hit,  sets line3 as LRU
	LDR R1, R3, 0 ; cache hit,  sets line1 as LRU
	LDR R2, R2, 0 ; cache miss, evicts line1, loads line2
inf:
	BRnzp inf

l1p:	DATA2 line1
l2p:	DATA2 line2
l3p:	DATA2 line3

SEGMENT 32 line1:
X:	DATA2 4x1111
NOP
NOP
NOP
NOP
NOP
NOP
NOP


SEGMENT 128 line2:
Y:	DATA2 4x2222
NOP
NOP
NOP
NOP
NOP
NOP
NOP

SEGMENT 128 line3:
Z:	DATA2 4x3333
NOP
NOP
NOP
NOP
NOP
NOP
NOP

