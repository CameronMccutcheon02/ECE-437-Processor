org   0x0000


ori $3, $0, 46
ori $4, $0, 87
ori   $1,$zero,0xF0

test_add:
    add $2, $3, $4
    sw $2, 0($1)  # store result of add in memory
    

test_addu:
    addu $2, $3, $4
    sw $2, 4($1)  # store result of addu in memory
    

test_and:
    and $2, $3, $4
    sw $2, 8($1)  # store result of and in memory
    

# test_jr:
#     jr $3
#     sw $0, 12($1)  # jr should not store result in memory
    

test_nor:
    nor $2, $3, $4
    sw $2, 16($1)  # store result of nor in memory
    

test_or:
    or $2, $3, $4
    sw $2, 20($1)  # store result of or in memory
    

test_slt:
    slt $2, $3, $4
    sw $2, 24($1)  # store result of slt in memory
    

test_sltu:
    sltu $2, $3, $4
    sw $2, 28($1)  # store result of sltu in memory
    

test_sllv:
    sllv $2, $3, $4
    sw $2, 32($1)  # store result of sllv in memory
    

test_srlv:
    srlv $2, $3, $4
    sw $2, 36($1)  # store result of srlv in memory
    

test_sub:
    sub $2, $3, $4
    sw $2, 40($1)  # store result of sub in memory
    

test_subu:
    subu $2, $3, $4
    sw $2, 44($1)  # store result of subu in memory
    

test_xor:
    xor $2, $3, $4
    sw $2, 48($1)  # store result of xor in memory
    

test_addi:
    addi $2, $3, 100
    sw $2, 52($1)  # store result of addi in memory
    

test_addiu:
    addiu $2, $3, 100
    sw $2, 56($1)  # store result of addiu in memory
    

test_andi:
    andi $2, $3, 100
    sw $2, 60($1)  # store result of andi in memory
    


end:
halt
