org 0x0000

ori $29, $0, 0xFFFC
ori $8, $0, 0x1000
ori $9, $0, 0xBEEF
ori $10, $0, 0x0005

loop:
nop
nop
nop
sw $9, 0x00F0($8)
sub $10, $10, 1
beq $0, $10, end
nop
nop
nop
j loop


end:
halt
