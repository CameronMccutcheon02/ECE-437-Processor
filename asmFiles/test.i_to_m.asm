
# core 1
org 0x0000
  ori $t0, $0, 0x00F0
  ori $t1, $0, 0xABC0
  sw $t1, 0($t0)          # move to M state
  halt

org 0x00F0
  cfw 0x1110

# core 2
org 0x0200
  ori $t0, $0, 0x0F00
  ori $t1, $0, 0xABC0
  sw $t1, 0($t0)          # move to M state
  halt

org 0x0F00
  cfw 0x2222
