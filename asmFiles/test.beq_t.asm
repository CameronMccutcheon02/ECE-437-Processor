org   0x0000
ORI $29, $0, 0xFFFC
ori   $1,$zero,0xF0
ori   $2,$zero,0xF0

#should take branch here
BEQ $1, $2, EQUAL

ori $2, $0, 0x0BAD
sw $2, 0($1)
HALT

EQUAL:
ori $2, $0, 0xF0F0
sw $2, 0($1)
HALT
