org 0x0000

MAIN:
ORI $29, $0, 0xFFFC #set stack pointer

ORI $6, $0, 11 #Current day to temp reg
ORI $7, $0, 1
ORI $8, $0, 2023

ADDI $8, $8, -2000
ORI $4, $0, 365
PUSH $4
PUSH $8

JAL MULT #Throw reslt on stack
POP $8

ADDI $7, $7, -1
ORI $4, $0, 30
PUSH $7
PUSH $4

JAL MULT
POP $7

ADD $6, $6, $7
ADD $6, $6, $8
PUSH $6
HALT



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
JR $31


