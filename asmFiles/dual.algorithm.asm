#----------------------------------------------------------
# First Processor
#----------------------------------------------------------
  org   0x0000              # first processor p0
  ori   $sp, $zero, 0x3ffc  # stack
  jal   mainp0              # go to program
  halt

# main function does something ugly but demonstrates beautifully
mainp0:
  push  $ra                 # save return address

  # initialization inputs
  ori   $t7, $zero, 0       # current N random numbers
  ori   $t6, $zero, 256     # set limit of random numbers
  ori   $t9, $zero, 0x10    # set the seed

rand:
  or    $a0, $zero, $t9     # move randomN-1 to arguement register (seed for N = 0)   
  jal   crc32               # generate random number
  or    $t8, $zero, $v0     # move returned random number to $t8

  ori   $a0, $zero, lck     # move lock to arguement register
  jal   lock                # try to aquire the lock

  # critical code segment
  or    $a0, $zero, $t8     # move random number to arguement register
  jal   gpush               # push the random number to the stack
  # critial code segment

  ori   $a0, $zero, lck     # move lock to arguement register
  jal   unlock              # release the lock

  or    $t9, $zero, $t8     # set next randomN to previous randomN

  addi  $t7, $t7, 1         # increment N random number count
  bne   $t7, $t6, rand      # generate more random numbers until 256

  pop   $ra                 # get return address
  jr    $ra                 # return to caller


#----------------------------------------------------------
# Second Processor
#----------------------------------------------------------
  org   0x1000              # second processor p1
  ori   $sp, $zero, 0x7ffc  # stack
  jal   mainp1              # go to program
  halt

# main function does something ugly but demonstrates beautifully
mainp1:
  push  $ra                 # save return address
  
  # initialize result registers
  ori   $s0, $zero, 0xffff  # min
  ori   $s1, $zero, 0       # max
  ori   $s2, $zero, 0       # sum

  # initialize looping registers
  ori $t5, $zero, 0         # sets current iteration number
  ori $t6, $zero, 256       # sets max iterations

# loop for all 256 values added to the stack
readStack:
  jal waitForPush           # wait until processor1 pushes to the stack

  ori   $a0, $zero, lck     # move lock to arguement register
  jal   lock                # try to aquire the lock

  # critical code segment                
  jal   gpop                # get random number off the stack    
  or    $s3, $zero, $v0     # move the random number to $s3
  # critical code segment

  ori   $a0, $zero, lck     # move lock to arguement register
  jal   unlock              # release the lock             

  andi  $a1, $s3, 0xFFFF    # set arguement 1 for all calculations (current random number)

  # min calculation
  andi  $a0, $s0, 0xFFFF    # set arguement 0 for min(a,b) (current min)
  jal   min                 # caluclate the min(a,b)
  or    $s0, $zero, $v0     # move the returned min to $s0

  # max calculation
  andi  $a0, $s1, 0xFFFF    # set arguement 0 for max(a,b) (current max)
  jal   max                 # calculate the max(a,b)
  or    $s1, $zero, $v0     # move the returned max to $s1
  
  add   $s2, $s2, $a1

  addi  $t5, $t5, 1         # increment current loop count
  bne   $t5, $t6, readStack # loop if havent read all 256 random numbers

  or    $a0, $zero, $s2
  or    $a1, $zero, $t6
  jal divide
  or    $s2, $zero, $v0
  or    $s3, $zero, $v1

  pop   $ra                 # get return address
  jr    $ra                 # return to caller

waitForPush:
  ori   $t0, $zero, gsp
  lw    $t1, 0($t0)
  beq   $t1, $zero, waitForPush
  jr    $ra  

#----------------------------------------------------------
# Lock/Unlock
#----------------------------------------------------------

# pass in an address to lock function in argument register 0
# returns when lock is available
lock:
aquire:
  ll    $t0, 0($a0)         # load lock location
  bne   $t0, $0, aquire     # wait on lock to be open
  addiu $t0, $t0, 1
  sc    $t0, 0($a0)
  beq   $t0, $0, lock       # if sc failed retry
  jr    $ra                 # return to caller


# pass in an address to unlock function in argument register 0
# returns when lock is free
unlock:
  sw    $0, 0($a0)
  jr    $ra                 # return to caller

lck:
  cfw 0x0

#----------------------------------------------------------
# Global Push/Pop
#----------------------------------------------------------

#gpush:
#  ori   $t0, $zero, gsp     # move the stack pointer to $t0
#  lw    $t2, 0($t0)         # load the address at the top of the stack
#  addi  $t2, $t2, 4         # increment the stack pointer
#  sw    $a0, 0($t2)         # store the word to the top of the stack
#  sw    $t2, 0($t0)         # update the stack pointer
#  jr    $ra                 # return to caller

#gpop:
#  ori   $t0, $zero, gsp     # move the stack pointer to $t0
#  lw    $t1, 0($t0)         # load the address at the top of the stack
#  lw    $v0, 0($t1)         # return word popped off the stack
#  sw    $zero, 0($t1)       # store 0 to the old word
#  addi  $t1, $t1, -4        # decrement the stack pointer
#  sw    $t1, 0($t0)         # update the stack pointer
#  jr    $ra                 # return to caller

gpush:
  ori    $t0, $zero, gsp
  ori    $t1, $zero, gsb

  lw     $t2, 0($t0)   
  lw     $t3, 0($t1)

  sub    $t3, $t3, $t2
  sw     $a0, 0($t3)

  addi   $t2, $t2, 4
  sw     $t2, 0($t0)

  jr     $ra

gpop:
  ori    $t0, $zero, gsp
  ori    $t1, $zero, gsb

  lw     $t2, 0($t0)
  lw     $t3, 0($t1)

  addi   $t2, $t2, -4
  sw     $t2, 0($t0)

  sub    $t3, $t3, $t2
  lw     $v0, 0($t3)

  sw     $zero, 0($t3)

  jr     $ra

gsp:
  cfw 0x0
gsb:
  cfw 0x8000

#----------------------------------------------------------
# Subroutines
#----------------------------------------------------------

#REGISTERS
#at $1 at
#v $2-3 function returns
#a $4-7 function args
#t $8-15 temps
#s $16-23 saved temps (callee preserved)
#t $24-25 temps
#k $26-27 kernel
#gp $28 gp (callee preserved)
#sp $29 sp (callee preserved)
#fp $30 fp (callee preserved)
#ra $31 return address

# USAGE random0 = crc(seed), random1 = crc(random0)
#       randomN = crc(randomN-1)
#------------------------------------------------------
# $v0 = crc32($a0)
crc32:
  lui $t1, 0x04C1
  ori $t1, $t1, 0x1DB7
  or $t2, $0, $0
  ori $t3, $0, 32

l1:
  slt $t4, $t2, $t3
  beq $t4, $zero, l2

  ori $t5, $0, 31
  srlv $t4, $t5, $a0
  ori $t5, $0, 1
  sllv $a0, $t5, $a0
  beq $t4, $0, l3
  xor $a0, $a0, $t1
l3:
  addiu $t2, $t2, 1
  j l1
l2:
  or $v0, $a0, $0
  jr $ra
#------------------------------------------------------



# registers a0-1,v0-1,t0
# a0 = Numerator
# a1 = Denominator
# v0 = Quotient
# v1 = Remainder

#-divide(N=$a0,D=$a1) returns (Q=$v0,R=$v1)--------
divide:               # setup frame
  push  $ra           # saved return address
  push  $a0           # saved register
  push  $a1           # saved register
  or    $v0, $0, $0   # Quotient v0=0
  or    $v1, $0, $a0  # Remainder t2=N=a0
  beq   $0, $a1, divrtn # test zero D
  slt   $t0, $a1, $0  # test neg D
  bne   $t0, $0, divdneg
  slt   $t0, $a0, $0  # test neg N
  bne   $t0, $0, divnneg
divloop:
  slt   $t0, $v1, $a1 # while R >= D
  bne   $t0, $0, divrtn
  addiu $v0, $v0, 1   # Q = Q + 1
  subu  $v1, $v1, $a1 # R = R - D
  j     divloop
divnneg:
  subu  $a0, $0, $a0  # negate N
  jal   divide        # call divide
  subu  $v0, $0, $v0  # negate Q
  beq   $v1, $0, divrtn
  addiu $v0, $v0, -1  # return -Q-1
  j     divrtn
divdneg:
  subu  $a0, $0, $a1  # negate D
  jal   divide        # call divide
  subu  $v0, $0, $v0  # negate Q
divrtn:
  pop $a1
  pop $a0
  pop $ra
  jr  $ra
#-divide--------------------------------------------



# registers a0-1,v0,t0
# a0 = a
# a1 = b
# v0 = result

#-max (a0=a,a1=b) returns v0=max(a,b)--------------
max:
  push  $ra
  push  $a0
  push  $a1
  or    $v0, $0, $a0
  slt   $t0, $a0, $a1
  beq   $t0, $0, maxrtn
  or    $v0, $0, $a1
maxrtn:
  pop   $a1
  pop   $a0
  pop   $ra
  jr    $ra
#--------------------------------------------------

#-min (a0=a,a1=b) returns v0=min(a,b)--------------
min:
  push  $ra
  push  $a0
  push  $a1
  or    $v0, $0, $a0
  slt   $t0, $a1, $a0
  beq   $t0, $0, minrtn
  or    $v0, $0, $a1
minrtn:
  pop   $a1
  pop   $a0
  pop   $ra
  jr    $ra
#--------------------------------------------------
