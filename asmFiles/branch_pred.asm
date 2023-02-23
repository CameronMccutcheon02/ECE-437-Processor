org 0x0000

Test:
    ori $29, $0, 0xFFFC
    ori $8, $0, 0x0080
    ori $1, $0, 0x0
    Loop:
        addi $2, $0, 4
        addi $3, $0, 4
        addi $4, $0, 4
        
        addi $1, $1, 4
        sw $1, 0x00F0($1)
        bne $8, $1, Loop


end:
nop
nop
nop
nop
halt
