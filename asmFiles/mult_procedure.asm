org 0x0000

Test:
    ori $29, $0, 0xFFFC
    ori $8, $0, 2
    push $8
    ori $8, $0, 3
    push $8
    ori $8, $0, 4
    push $8
    NotEmpty:
        ori $9, $0, 0xFFFC
        addi $8, $9, -4 # empty stack case
        beq $8, $29, Exit
        jal Mult
        j NotEmpty
    Exit:
        halt
Mult:
    ori $2, $0, 0 # result reg
    pop $3 # loops this many times
    pop $4 # adds this number to result each loop
    Loop:
        beq $3, $0, Return
        addi $3, $3, -1
        add $2, $4, $2
        j Loop
    Return:
        push $2
        jr $31 # return to NotEmpty
