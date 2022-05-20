# Homework 1
# Name: Tzu-Yu Lin
# Net ID: tzuyul7
.globl main

.data
newline: .asciiz "\n"
err_string: .asciiz "INPUT ERROR"

prompt_type: .asciiz "Number (n/N) or ASCII String (a/A)? "
prompt_ascii: .asciiz "Enter a ASCII string (max 100 characters): "
prompt_find: .asciiz "Enter the find character: "
prompt_replace: .asciiz "Enter the replace character: "
prompt_number: .asciiz "Enter the number: "

number_even: .asciiz "The number is Even\n"
number_power: .asciiz "The number is a power of 2\n"
number_mult: .asciiz "The number is a multiple of 16\n"
number_binary1: .asciiz "There are "
number_binary2: .asciiz " 1's in the binary representation\n"
number_div4: .asciiz "The value/4 is "

ascii_length: .asciiz "Length of string: "
ascii_space: .asciiz "# of space characters: "
ascii_upper: .asciiz "# of uppercase letters: "
ascii_symbols: .asciiz "# of symbols: "

user_string: .space 100

.text

main:
	# Your code goes here
    
	# Display the propt
    	addi $v0, $0, 4
    	la $a0, prompt_type
    	syscall

	# read character
	li $v0, 12
	syscall
	move $t0, $v0
	
	la $a0,newline
	li $v0,4
	syscall
	
	# verify the single character
	li $s1, 'n'
	beq $t0,$s1,TRUE1
		li $s1, 'N'
		beq $t0,$s1,TRUE1
			li $s1, 'a'
			beq $t0,$s1,TRUE2
				li $s1, 'A'
				beq $t0,$s1,TRUE2
	
	# Display error message
    	addi $v0, $0, 4
    	la $a0, err_string
    	syscall
    	
    	li $v0, 10
	syscall
	

TRUE1:
	# Display prompt for entering an integer value
    	addi $v0, $0, 4
    	la $a0, prompt_number
    	syscall
    	
    	#read the integer
    	li $v0, 5
	syscall
	move $t1, $v0
	
	#check if number is even
	li $t7, 2
	div $t1,$t7
	mfhi $t6
	bne $t6, 0, not_even
		# Print number is even
    		addi $v0, $0, 4
    		la $a0, number_even
    		syscall
	
not_even:
	
	#check if number is power of 2
	li $t5, 1
	sub $t4, $t1 $t5
	and $t5, $t1, $t4
	bne $t5, 0, not_power
		# Print number is power of 2
    		addi $v0, $0, 4
    		la $a0, number_power
    		syscall
	
not_power:

	#check if number s multiple of 16
	li $t7, 16
	div $t1,$t7
	mfhi $t6
	bne $t6, 0, not_multiple
		# Print number is multiple of 16
    		addi $v0, $0, 4
    		la $a0, number_mult
    		syscall

not_multiple:

	#calculate numbers of 1's in the binary representation of the number
	#s2 as counter
	add $s2, $0, $0 
	#t7 as position
	li, $t7, 1
	#t6 as bit looping 
	li $t6, 0 
	
	li $t9, 32
	
loop:
	bge $t6, $t9, finish
	and $s3, $t1, $t7        #s3 = bit
	
	beqz $s3, end_if
		addi $s2, $s2, 1
end_if:
	sll $t7, $t7, 1
	addi $t6, $t6, 1
	j loop
	
finish:
	addi $v0, $0, 4
    	la $a0, number_binary1
    	syscall
    	
	li, $v0, 1
	move $a0, $s2
	syscall
	
	addi $v0, $0, 4
    	la $a0, number_binary2
    	syscall
    	
    	#calculate integer value result after dividing by 4
    	li $t7, 4
	div $t1,$t7
	mflo $t6
	
    	addi $v0, $0, 4
    	la $a0, number_div4
    	syscall
	
	li, $v0, 1
	move $a0, $t6
	syscall
	
    	j done
	
TRUE2:
	# Display prompt for entering string
    	addi $v0, $0, 4
    	la $a0, prompt_ascii
    	syscall
    	
    	
    	# read string from user
	li $v0, 8
	la $a0, user_string
	li $a1, 101
	syscall
	
	# Display prompt for 1st character
    	addi $v0, $0, 4
    	la $a0, prompt_find
    	syscall
    	
    	# read "find" character
	li $v0, 12
	syscall
	move $t2, $v0
	
	la $a0,newline
	li $v0,4
	syscall
	
	# Display prompt for second character
    	addi $v0, $0, 4
    	la $a0, prompt_replace
    	syscall
    	
    	# read "replace"character
	li $v0, 12
	syscall
	move $t3, $v0
	
	la $a0,newline
	li $v0,4
	syscall
	
	# using while loop to go through each chracter within the given string
	add $s2, $0, $0  #s2 = counter for length count
	add $s3, $0, $0  #s3 = counter for space count
	add $s4, $0, $0  #s4 = counter for Uppercase letter count
	add $s5, $0, $0  #s5 = counter for symbol count
	
	la $t5, user_string
loop_s:
	lb $t6, 0($t5)          # go to next bit/character
	beqz $t6, print_s       # leave when at the end of the string
	beq $t6,'\n', print_s
	# checking if the bit/character is same as space
	bne $t6, 0x20, not_space
		addi $s3, $s3, 1
not_space:
	#checking if the bit/chracter is same as uppercase letters
	blt $t6, 0x41, not_upper
		bgt $t6, 0x5A, not_upper
			addi $s4, $s4, 1
not_upper:
	#checking if the bit/character is same as symbol chracters
	# part 1
	blt $t6, 0x21, not_symbol
		bgt $t6, 0x2F, not_symbol
			addi $s5, $s5, 1
not_symbol:
	# part 2
	blt $t6, 0x3A, not_symbol2
		bgt $t6, 0x40, not_symbol2
			addi $s5, $s5, 1
not_symbol2:
	# part 3
	blt $t6, 0x5B, not_symbol3
		bgt $t6, 0x60, not_symbol3
			addi $s5, $s5, 1
not_symbol3:
	# Part 4
	blt $t6, 0x7B, next_chr
		bgt $t6, 0x7E, next_chr
			addi $s5, $s5, 1						
next_chr:
	bne $t6, $t2, no_change
		sb $t3, 0($t5)
no_change:
	addi $t5, $t5, 1	 # increment the string pointer
	addi $s2, $s2, 1 	# increment the count
	j loop_s 	
		 

print_s:
	# Print length of the string
    	addi $v0, $0, 4
    	la $a0, ascii_length
    	syscall
    	
    	li, $v0, 1
	move $a0, $s2
	syscall

	la $a0,newline
	li $v0,4
	syscall
	
	# Print space count within the string
    	addi $v0, $0, 4
    	la $a0, ascii_space
    	syscall
    	
    	li, $v0, 1
	move $a0, $s3
	syscall
	
	la $a0,newline
	li $v0,4
	syscall
	
	# Print uppercase letter count within the string
    	addi $v0, $0, 4
    	la $a0, ascii_upper
    	syscall
    	
    	li, $v0, 1
	move $a0, $s4
	syscall
	
	la $a0,newline
	li $v0,4
	syscall
	
	# Print symbol count within the string
    	addi $v0, $0, 4
    	la $a0, ascii_symbols
    	syscall
    	
    	li, $v0, 1
	move $a0, $s5
	syscall
	
	la $a0,newline
	li $v0,4
	syscall
	
	# Print string after replacement
	addi $v0, $0, 4
    	la $a0, user_string
    	syscall
done: 
	# Terminate the program
	li $v0, 10
	syscall
