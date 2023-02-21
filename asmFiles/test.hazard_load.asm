org 0x0000

ori $29, $0, 0xFFFC
ori $8, $0, 0xABCD

sw $8, 0x00F0($0) #store to address
ori $8, $0, 0x0BAD

lw $8, 0x00F0($0) #dependency only on the following instruction
or $7, $0, $8
sw $7, 0x0AF0($0)

lw $8, 0x0AF0($0) #dependency only on the second following instruction
nop
or $7, $0, $8
sw $7, 0x0BF0($0)

lw $8, 0x0BFB($0) #dependency on both of the following instructions
or $7, $0, $8
or $6, $0, $8
sw $7, 0x0CF0($0)
sw $6, 0x0DF0($0)

halt
