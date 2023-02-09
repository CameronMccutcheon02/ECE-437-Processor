org 0x0000

ori $29, $0, 0xFFFC
ori $2, $0, 0x0002
nop
nop 
nop
addi $2, $2, 0x2
addi $2, $2, 0x2
nop
nop
nop
sw $2, 0x00F0($0)
halt
