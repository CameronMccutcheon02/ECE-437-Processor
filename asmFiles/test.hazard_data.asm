org 0x0000

ori $29, $0, 0xFFFC
ori $2, $0, 0x0002

ori $8, $0, 0x0002
add $3, $8, $0

ori $8, $0, 0x0004
add $4, $0, $8

ori $8, $0, 0x0006
add $5, $8, $8

sw $3, 0x00A0($0)
sw $4, 0x00B0($0)
sw $5, 0x00C0($0)

ori $8, $0, 0x0002
nop
add $3, $8, $0

ori $8, $0, 0x0004
nop
add $4, $0, $8

ori $8, $0, 0x0006
nop
add $5, $8, $8

sw $3, 0x00A0($0)
sw $4, 0x00B0($0)
sw $5, 0x00C0($0)

ori $8, $0, 0x0002
nop
nop
add $3, $8, $0

ori $8, $0, 0x0004
nop
nop
add $4, $0, $8

ori $8, $0, 0x0006
nop
nop
add $5, $8, $8

sw $3, 0x00A0($0)
sw $4, 0x00B0($0)
sw $5, 0x00C0($0)

halt
