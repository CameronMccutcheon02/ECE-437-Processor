org   0x0000
ORI $29, $0, 0xFFFC
ori   $1,$zero,0xF0
ori   $2,$zero,0xFF

#should take branch here
BNE $1, $2, NEQUAL

ori $2, $0, 0x0BAD
sw $2, 0($1)
HALT

NEQUAL:
ori $2, $0, 0xf0f0
sw $2, 0($1)
HALT
