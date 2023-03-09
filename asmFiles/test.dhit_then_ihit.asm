org 0x0000

ori $29, $0, 0xFFFC
ori $8, $0, 0x1000
ori $9, $0, 0xBEEF
ori $10, $0, 0x1FF0

loop:
nop
nop
nop
sw $9, 0x00F0($8)
beq $8, $10, end
addi $8, $8, 0x0FF0
nop
nop
nop
j loop


end:
halt

