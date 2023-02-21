org   0x0000
ORI $29, $0, 0xFFFC
ori   $1,$zero,0xF0

J Jloc

ori $2, $0, 0x0BAD
sw $2, 0($1)
HALT

Jloc2:
ori $2, $0, 0xf0f0
sw $2, 0($1)
HALT

Jloc:
J Jloc2
HALT
