# Tzu-Yu Lin
# tzuyul7

.data
endl: .asciiz "\n"   # a string


.globl main
.text
main:

# Your code goes here
# Part 1
	li $t0,0x01234567
	li $v0,35
	move $a0,$t0
	syscall

	la $a0,endl
	li $v0,4
	syscall

# Part 2
	li $t1,0xFF
	and $t2,$t0,$t1
	li $v0,35
	move $a0,$t2
	syscall

	la $a0,endl
	li $v0,4
	syscall

# Part 3
	sll $t1,$t1,10
	and $t2,$t0,$t1
	li $v0,35
	move $a0,$t2
	syscall

	la $a0,endl
	li $v0,4
	syscall

# Part 4
	li $t3,+7
	sll $t3,$t3,1
	li $v0,1
	move $a0,$t3
	syscall

	la $a0,endl
	li $v0,4
	syscall

# Part 5
	ror $t3,$t3,4
	li $v0,1
	move $a0,$t3
	syscall

	la $a0,endl
	li $v0,4
	syscall

# Part 6
	sra $t3,$t3,1
	li $v0,1
	move $a0,$t3
	syscall

	la $a0,endl
	li $v0,4
	syscall

# Part 7
	srl $t3,$t3,1
	li $v0,1
	move $a0,$t3
	syscall

	la $a0,endl
	li $v0,4
	syscall

# Terminate the program
	li $v0,10
	syscall
	

