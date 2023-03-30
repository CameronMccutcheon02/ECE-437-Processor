
# core 1
org 0x0000
  ori $t0, $0, 0x00F0
  lw $t1, 0($t0)          # move to S state
  ori $t2, $0, 0xABC0
  sw $t2 0($t0)           # move to M state

  halt
  
# core 2
org 0x0200
  ori $t0, $0, 0xF000
  lw $t1, 0($t0)          # move to S state
  ori $t2, $0, 0xABC0
  sw $t2, 0($t0)          # move to M state
    
  halt

org 0x00F0
cfw 1227

org 0xF000
cfw 1111
