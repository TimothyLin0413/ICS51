# Class Demo
.data
a: .word 7
b: .asciiz "Hi I'm a string!"
c: .byte ' '
d: .asciiz " "
e: .word -100 # word is always 4 bits

.text
#instructions

la $t0,b
la $a0,($t0)
li $v0,4
syscall
lb $t2,3($t0)


addi $t7,$t0 3 # St7 = $t0 + 3
sub $t7,$t0,$t1 # $t7 = $t0 - $t1
lb $t2,0($t7)

mflo $t0
mfhi $t1

li $v0,10
syscall
