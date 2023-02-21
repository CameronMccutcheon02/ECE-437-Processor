org 0x0000

ori $29, $0, 0xFFFC
ori $8, $0, 0xABC0
ori $7, $0, 0xAAAA

sw $8, 0x00F0($0)
beq $8, $8, B
lw $8, 0($8)
sw $8, 0x0AF0($0)
sw $8, 0x0BF0($0)
sw $8, 0x0CF0($0)

B:
j Ju
sw $7, 0x0DF0($0)
sw $7, 0x0EF0($0)
sw $7, 0x0FF0($0)

Ju:
halt
