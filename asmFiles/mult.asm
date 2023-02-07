org 0x0000

Test:
    # Initialize Stack Pointer
    ori $29, $0, 0xFFFC

    # Test case 3 * 3
    ori $8, $0, 3 
    push $8
    ori $9, $0, 3
    push $9
    j Mult

Mult:
    ori $2, $0, 0 # result reg
    pop $3 # loops this many times
    pop $4 # adds this number to result each loop
    Loop:
        beq $3, $0, Exit
        addi $3, $3, -1
        add $2, $4, $2
        j Loop
    Exit:
        push $2
        halt
