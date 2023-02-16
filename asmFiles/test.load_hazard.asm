org 0x0000

ori $29, $0, 0xFFFC
ori $8, $0, 0xABCD
nop
nop
nop

sw $8, 0x00F0($0) #store to address

ori $8, $0, 0x0BAD
lw $8, 0x00F0($0)
or $7, $0, $8
nop
nop
nop


sw $7, 0x00F0($0)
halt
