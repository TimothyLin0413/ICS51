# Tzu-Yu Lin
# tzuyul7

.globl main
.text
main:

# Your code goes here
	# Part 1
	li $v0,4
	la $t5,num
	move $a0, $t5
	syscall
	
	la $a0,endl
	li $v0,4
	syscall
	
	# Part 2
	addi $v0,$0,4
	la $a0,prompt
	syscall
	
	# Part 3
	li $v0,12
	syscall
	
	sb $v0,($t5)
	move $t0,$v0

	
	# Part 4
	la $a0,endl
	li $v0,4
	syscall
	
	li $v0,4
	la $a0,num
	syscall 
	
	la $a0,endl
	li $v0,4
	syscall
	
	lb $t1,2($t5)
	addi $t1,$t1,32
	sb $t1,2($t5)
	
	li $v0,4
	la $a0,num
	syscall 
	
	la $a0,endl
	li $v0,4
	syscall
	
	# Part 5
	lw $t2,($t5)
	srl $t2,$t2,8
	
	
	# Part 6
	sll $t1,$t1,24
	add $t3,$t1,$t2
	sw $t3,($t5)
	
	# Part 7
	la $a0,num
	li $v0,4
	syscall
	
	la $a0,endl
	li $v0,4
	syscall
	
	# Part 8
	sb $0,4($t5)
	
	# Part 9
	la $a0,num
	li $v0,4
	syscall
	
	la $a0,endl
	li $v0,4
	syscall
	
	# Part 10
	lw $t1,($t5)
	
	# Part 11
	ror $t1, $t1, 4
	la $a0, num
	li $v0, 4
	syscall
	
	la $a0, endl
	li $v0, 4
	syscall
	
	# Part 12
	sw $t1,($t5)
	la $a0, num
	li $v0, 4
	syscall
	
	la $a0, endl
	li $v0, 4
	syscall
	
	# Part 13
	ror $t1, $t1, 4

	sw $t1, ($t5)
	la $a0, num
	li $v0, 4
	syscall
	
	la $a0, endl
	li $v0, 4
	syscall
	
	# Part 14
	la $a0, myspace
	li $v0, 4
	syscall
	
	la $a0, endl
	li $v0, 4
	syscall
	
	# Part 15
	la $t6, myspace
	lw $t1,($t6)
	add $t1, $t1, $t0
	sw $t1,($t6)
	
	la $a0, myspace
	li $v0, 4
	syscall
	
	la $a0, endl
	li $v0, 4
	syscall
	
	# Part 16
	addi $t1, $t1, 1
	sb $t1,1($t6)
	
	la $a0, myspace
	li $v0, 4
	syscall
	
	la $a0, endl
	li $v0, 4
	syscall
	
	# Terminate the program
	li $v0, 10
	syscall
	
	
.data
prompt: .asciiz "Enter a lowercase letter: "
endl: .asciiz "\n"
.align 2
num: .word 0x44434241
myspace: .byte '#', 0x00, '@', '%' 
stop: .byte 0x00

