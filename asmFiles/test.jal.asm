org   0x0000
ORI $29, $0, 0xFFFC
ori   $1,$zero,0xF0

JAL Jloc

Jloc:
sw $31, 0($1)
HALT