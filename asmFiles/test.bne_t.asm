org 0x0000

ori $29, $0, 0xFFFC
ori $8, $0, 0x1234
bne $0, $8, BRANCH
ori $8, $0, 0x0BAD
sw $8, 0x00F0($0)
halt

BRANCH:
    ori $8, $0, 0xABCD
    sw $8, 0x00F0($0)
    halt