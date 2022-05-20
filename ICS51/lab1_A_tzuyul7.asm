# Tzu-Yu Lin
# tzuyul7

.data
endl: .asciiz "\n"   # a string
space: .asciiz " " # a space
myNum: .word 0xAABBCCDD


.globl main
.text
main:

# Your code goes here

# Load address for label myNum
	la $t0,myNum
# Print value in Reg A as a hexadeciaml value
	li $v0,34
	#la $a0,($t0)
	move $a0,$t0
	syscall

# on its own line
	la $a0,endl
	li $v0,4
	syscall


# Load the value stored in memory at muNum
	lw $t1,($t0)
	li $v0,1
	move $a0,$t1
	syscall

	la $a0,endl
	li $v0,4
	syscall

# Load the byte stored in memory at myNum
	lb $t2,($t0)
	li $v0,34
	move $a0,$t2
	syscall

	la $a0,endl
	li $v0,4
	syscall

# Load the byte stored in memory at myNum+2
	lb $t1,2($t0)
	li $v0,34
	move $a0,$t1
	syscall

	la $a0,endl
	li $v0,4
	syscall

# Load the byte unassigned  stored ini memory at myNum+2
	lbu $t1,2($t0)
	li $v0,34
	move $a0,$t1
	syscall

	la $a0,endl
	li $v0,4
	syscall

# Load half-word in memory at label myNum
	lh $t2,($t0)
	li $v0,1
	move $a0,$t2
	syscall

	la $a0,space
	li $v0,4
	syscall

	li $v0,34
	move $a0,$t2
	syscall

	la $a0,endl
	li $v0,4
	syscall
	
# Stored byte value 0xFF with myNum+3
	li $s0,0xFF
	sb $s0,3($t0)

# Load the integer value stored in memory at the label myNum as hexadeciaml
	lw $t1,($t0)
	li $v0,34
	move $a0,$t1
	syscall 

	la $a0,endl
	li $v0,4
	syscall

# Terminate the program
	li $v0,10
	syscall


