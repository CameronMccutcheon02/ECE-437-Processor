
# core 1
org 0x0000
  ori $t0, $0, 0x00F0
  lw $t1, 0($t0)          # move to S state
  ori $t0, $0, 0xA000
  sw $t0, 0($t0)
  halt

org 0x00F0
cfw 1227
  
# core 2
org 0x0200
  ori $t0, $0, 0x0F00
  lw $t1, 0($t0)          # move to S state
  ori $t0, $0, 0xB000
  sw $t0, 0($t0)
  halt

org 0x0F00
cfw 1111
