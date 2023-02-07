org 0x0000

ori $29, $0, 0xFFFC
jal JUMP
ori $8, $0, 0xABCD
sw $8, 0x00F0($0)
halt

JUMP:
    jr $31
    ori $8, $0, 0x0BAD
    sw $8, 0x00F0($0)
    halt
