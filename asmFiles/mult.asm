org 0x0000

MAIN:
ORI $29, $0, 0xFFFC
ORI $5, $0, 10
ORI $4, $0, 5
PUSH $5 #push first op to stack
PUSH $4 #push second op to stack

MULT: 
POP $4 #pull 2nd op from stack
POP $5 #pull 1st of from stack
OR $3, $0, $0 #clear temp reg


LOOP:
BEQ $5, $0, LOOPEND
ADD $3, $3, $4
ADDI $5, $5, -1
J LOOP

LOOPEND: 
PUSH $3
ori $15, $0, 0x100
sw $3, 0($15)
HALT
