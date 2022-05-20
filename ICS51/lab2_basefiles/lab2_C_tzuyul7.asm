# Tzu-Yu Lin
# tzuyul7

.include "lab2_A_tzuyul7.asm"  # Change this to your file
.include "lab2_B_tzuyul7.asm"  # Change this to your file

.data
# Define  data items here
user_string: .space 8
values: .word 0,0,0,0,0
prompt: .asciiz "Enter hex character string, without 0x (8 digit max): "
value_string: .asciiz "The hex value is "
value_string2: .asciiz " in decimal\n"
min_string: .asciiz "\nThe minimum value is "
max_string: .asciiz "The maximum value is "
new_line: .asciiz "\n"

.globl main
.text
main:

# Implementation goes here
li $s1, 0	# t1 = i
li $s2, 5	# t2 = 5
start:
bge $s1, $s2, run_function
	addi $v0, $0, 4
    	la $a0, prompt
    	syscall
    	
    	li $v0, 8
    	la $a0, user_string
    	li $a1, 9
	syscall
	
	
	la $t3, user_string      # $t3 = user_string
	add $t4, $0, $0		 # $t4 = j
	li $t5, 8		# $t5 = 8
loop3:
	bgt $t4, $t5, find_values
		add $t6, $t4, $t3       # curvalue[j] = $t6
		lb $t7, 0($t6)		
	
		bne $t7, '\n', increment3
			li $t9, '\0'
			sb $t9, 0($t6)
			j find_values
	
	increment3:
		addi $t4, $t4, 1
		j loop3
	
find_values:
	jal hex2bin
	
	sll $t0, $s1, 2  # bytes for index i
	la $s3, values
	add $t0, $t0, $s3
	sw $v0, 0($t0)
	move $t9, $v0
	
	addi $v0, $0, 4
    	la $a0, new_line
    	syscall
    	
	addi $v0, $0, 4
    	la $a0, value_string
    	syscall
    	
    	li, $v0, 1
	move $a0, $t9
	syscall
    	
    	addi $v0, $0, 4
    	la $a0, value_string2
    	syscall
    	
    	addi $s1, $s1, 1
    	j start
	
run_function:
	move $a0, $s3
	move $a1, $s2
	jal findStats
	
	move $t8, $v0
	move $t9, $v1
	
	addi $v0, $0, 4
    	la $a0, min_string
    	syscall
    	
    	li, $v0, 1
	move $a0, $t8
	syscall
    	
    	addi $v0, $0, 4
    	la $a0, new_line
    	syscall
    	
    	addi $v0, $0, 4
    	la $a0, max_string
    	syscall
	
	li, $v0, 1
	move $a0, $t9
	syscall
	
	addi $v0, $0, 4
    	la $a0, new_line
    	syscall
	
	# Terminate the program
	li $v0, 10
	syscall