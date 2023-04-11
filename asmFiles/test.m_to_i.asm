
# core 1
org 0x0000
  ori $t0, $0, 0xF000
  ori $t1, $0, 0x00C0
  sw $t1, 0($t0)          # move to M state

  ori $t0, $0, 0x0001
  ori $t1, $0, 0x00FF
for1:
  addi $t0, $t0, 1
  bne $t0, $t1, for1

  # move to I state when core 2 hits M state

  halt
  
# core 2
org 0x0200
  ori $t0, $0, 0xF000
  ori $t1, $0, 0xAAA0

  nop
  nop
  nop

  sw $t0, 0($t0)          # move to M state
  
  halt
