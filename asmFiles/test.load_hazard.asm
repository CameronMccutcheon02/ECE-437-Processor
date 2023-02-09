org 0x0000

ori $29, $0, 0xFFFC
ori $8, $0, 0xABCD
nop 
nop 
sw $8, 0x00F0($0) #store to address
nop 
nop 
nop
ori $8, 0x0BAD
nop
nop
nop
lw $8, 0x00F0($0) #attempt to load the BAD value
ori $7, $0, $8
nop 
nop 
nop
sw $7, 0x00F0($0)
