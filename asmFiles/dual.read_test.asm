    org   0x0000
    ori   $1, $zero, 0x1FC0
    sw    $1, 0($1)


    halt      # that's all

    org   0x0200
    ori   $1, $zero, 0x1FC0
    lw  $2, 0($1)
    addi $2, $2, 4
    sw  $1, 0($1)
    halt
