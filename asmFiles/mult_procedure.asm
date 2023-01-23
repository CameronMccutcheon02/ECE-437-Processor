org 0x0000

MAIN:
ORI $29, $0, 0xFFFC

ORI $5, $0, 10
PUSH $5 #push first op to stack

ORI $5, $0, 10
PUSH $5 #push op to stack

ORI $5, $0, 700
PUSH $5 #push op to stack

MULT:

STACK: 
ORI $2, $0, 0xFFF8
BEQ $29, $2, FINISH #if we only have one operand on the stack, we are done

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
J STACK


FINISH:
HALT
