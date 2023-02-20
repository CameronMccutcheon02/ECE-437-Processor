org 0x0000

ori $29, $0, 0xFFFC
nop
nop
nop
ori $8, $0, 0xABCD
nop
nop
nop
nop

sw $8, 0x00F0($0) #store to address
nop
nop
nop
nop

ori $8, $0, 0x0BAD
nop
nop
nop

lw $8, 0x00F0($0) #dependency only on the following instruction
nop
nop
nop
or $7, $0, $8
nop
nop
nop
sw $7, 0x00FF($0)
nop
nop
nop

#lw $8, 0x00FA($0) #dependency only on the second following instruction
#nop
#or $7, $0, $8
#sw $7, 0x00FB($0)

#lw $8, 0x00FB($0) #dependency on both of the following instructions
#or $7, $0, $8
#or $6, $0, $8
#sw $7, 0x00F0($0)
#sw $6, 0x00FC($0)

halt
