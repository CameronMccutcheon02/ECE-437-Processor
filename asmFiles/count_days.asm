org 0x0000

Test:
    ori $29, $0, 0xFFFC
    ori $2, $0, 11   # day
    ori $3, $0, 1    # month
    ori $4, $0, 2023 # year

    # (30 * (CurrentMonth - 1))
    addi $8, $3, -1
    ori $9, $0, 30
    push $8
    push $9
    jal Mult

    # CurrentDay + (30 * (CurrentMonth - 1))
    pop $8
    add $8, $2, $8
    push $8

    # 365 * (CurrentYear - 2000)
    addi $9, $4, -2000
    ori $8, $0, 365
    push $8
    push $9
    jal Mult
    
    # CurrentDay + (30 * (CurrentMonth - 1)) + 365 * (CurrentYear - 2000)
    pop $8
    pop $9
    add $8, $8, $9
    halt

Mult:
    ori $8, $0, 0 # result reg
    pop $9 # loops this many times
    pop $10 # adds this number to result each loop
    Loop:
        beq $9, $0, Return
        addi $9, $9, -1
        add $8, $10, $8
        j Loop
    Return:
        push $8
        jr $31
