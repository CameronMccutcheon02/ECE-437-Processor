org 0x0000

ori $29, $0, 0xFFFC
ori $8, $0, 0x1234
nop
nop
beq $0, $8, BRANCH
ori $8, $0, 0xABCD
nop
nop
sw $8, 0x00F0($0)
nop
nop
nop
halt

BRANCH:
    ori $8, $0, 0x0BAD
    sw $8, 0x00F0($0)
    halt
