
# core 1
org 0x0000
  ori $t0, $0, 0xF000
  lw $t1, 0($t0)          # move to S state
  
  ori $t0, $0, 0x0001
  ori $t1, $0, 0x00FF
for1:
  addi $t0, $t0, 1
  bne $t0, $t1, for1

  # Move to I state
  
  halt
  
# core 2
org 0x0200
  nop
  nop
  nop
  
  ori $t1, $0, 0xABCD
  ori $t0, $0, 0x00F0
  sw $t1, 0($t0)        # Move to M state

  halt

org 0xF000
cfw 1227
