# Tzu-Yu Lin
# tzuyul7

.text

reverseString:
	# your code goes here
	li $s6, 0	# s6 = length of the string
	add $t0, $s6, $a0        #  memory address of the string
	lb $t0, 0($t0)		# t0 = chracter 
	
find_length:
	beqz,$t0, reverse
	addi $s6, $s6, 1	# length +1
	add $t0, $s6, $a0        # next character memory address
	lb $t0, 0($t0)
	j find_length

reverse:
	li $t9, 0 	# t9 = counter use to increment reverse string
	li $t8, 1	# t8 = 1
	move $t7, $s6
	sub $t7, $t7, $t8
	
check_status:
	beq $t9, $s6, done
		add $t1, $t7, $a0	# go to the memory address of the string	
		lb $t1, 0($t1)		# get the character from the string
		
		add $t2, $t9, $a1	# go to the memory address of the reverse string
		sb $t1, 0($t2)		# store character in reverse string
		
		addi $t9, $t9, 1	# increment index +1 for reverese string
		sub $t7, $t7, $t8		# subtract index -1 for string
		j check_status
done:
    	jr $ra

shiftCipher:
    	# your code goes here
    	li $t1, 0	# number count of encrypted chracters
    	li $t2, 0 	# length of the string
    	li $s5, 26	#s5 = 26
    	add $t9, $t2, $a0        #  memory address of the string
	lb $t0, 0($t9)		# t0 = chracter 
	
find_length2:
	beqz,$t0, done2
	#checking if the bit/chracter is same as uppercase letters
	blt $t0, 0x41, not_upper
		bgt $t0, 0x5A, not_upper
			add $t3, $t0, $a1	# encrypted 
			li $t6, 65
			sub $t3, $t3, $t6
			div $t3, $s5
			mfhi $t3
			bgez $t3, positive
				li $t6, 91
				add $t3, $t6, $t3	
				j store
		positive:
			add $t3, $t3, $t6
		store:
			sb $t3, 0($t9)
			addi $t1, $t1, 1
			j not_letter
not_upper:
	#checking if the bit/chracter is same as letters
	blt $t0, 0x61, not_letter
		bgt $t0, 0x7A, not_letter
			add $t3, $t0, $a1	# encrypted 
			li $t6, 97
			sub $t3, $t3, $t6
			div $t3, $s5
			mfhi $t3
			bgez $t3, positive2
				li $t6, 123
				add $t3, $t6, $t3
				j store2
		positive2:
			add $t3, $t3, $t6
		store2:
			sb $t3, 0($t9)
			addi $t1, $t1, 1
not_letter:
	addi $t2, $t2, 1	# length +1
	add $t9, $t2, $a0        # next character memory address
	lb $t0, 0($t9)
	j find_length2
    	
    	
done2:
	move $v0, $t2
	move $v1, $t1
    	jr $ra

countMultipleOf:
	# your code goes here
	blez $a1, error
	blez $a2, error
	
	li $t1, 0	# t1 = # of multiple
	li $t2, 0 	# t2 = largest multiple
	li $t3, 0 	# t3 = counter 
	
for_loop:
	bge $t3, $a1, done3
		sll $t0, $t3, 2  # bytes for index i
		add $t0, $t0, $a0
		lw $t4, 0($t0)
		beqz $t4, increment
		div $t4, $a2
		mfhi $t5
		bnez $t5, increment
			addi $t1, $t1, 1
			ble $t4, $t2, increment
				move $t2, $t4
increment:
	addi $t3, $t3, 1
	j for_loop
done3:
	move $v0, $t1
	move $v1, $t2
	jr $ra
error:
	li $v0, -1
	li $v1, -1
   	jr $ra

sumOfSubArray:
   	# your code goes here
   	blez $a1, error2
   	blt $a3, $a2, error2
   	
   	li $t9, 1
   	sub $t9, $a1, $t9
	bltz $a2, error2
	bgt $a2, $t9, error2
	
	bltz $a3, error2
	bgt $a3, $t9, error2
	
	li $t2, 0 	# t2 = total sum
	move $t3, $a2 	# t3 = counter 
	
for_loop2:
	bgt $t3, $a3, done4
		sll $t0, $t3, 2  # bytes for index i
		add $t0, $t0, $a0
		lw $t4, 0($t0)	
		add $t2, $t2,$t4 
		addi $t3, $t3, 1
		j for_loop2
done4:
	move $v0, $t2
	li $v1, 0
	jr $ra
error2:	
	li $v0, -1
	li $v1, -1
   	jr $ra

statsOnStrings:
   	# your code goes here
   	blez $a1, error3
   	bgt $a2, 0x7F, error3
   	
   	li $t1, 0	# t1 = counter for characters
   	li $t2, 0 	# t2 = index count on how many string
	li $t3, 0     # t3 = 1-> yes chr had appear before, 0 -> no chr hasnt appear
	li $t4, 0 	# t4 = # of string containing the chr
	lw $t5, 0($a0)
	lb $t0, 0($t5)

for_loop3:
	bge $t2, $a1, done5
	beq $t0,'\0', next
	bne $t0, $a2, increment2		#check if its the character
		bnez $t3, increment2	#check if its in the same index string
			addi $t4, $t4, 1
			addi $t3, $t3, 1
			j increment2
		
next:
	li $t3, 0
	addi $t2, $t2, 1
	
increment2:
	addi $t1, $t1, 1
	add $t0, $t1, $t5        # index[i]
	lb $t0, 0($t0)
	j for_loop3
	
done5:
	sub $t1, $t1, $t2
	move $v0, $t1
	move $v1, $t4
	jr $ra

error3:
	li $v0, -1
	li $v1, -1
    	jr $ra

int2BCD:
	li $t1, 99999999
	bgt $a0, $t1, error4
	li $t1, -99999999
	ble $a0, $t1, error4
	li $t2, 0
	li $t8, 0
	

	li $t1, 0x00000000	# variable r
	
	# change negative to positive
	bgez $a0, for_loop4
		li $t2, 0	
		sub $a0, $t2, $a0
	
	li $t2, 0 	# variable k = looping counter
for_loop4:
	bge $t2, 32, return
	
	li $t3, 0	# variable msb 
	bgez $a0, shift
		li $t3, 1
shift:
	sll $a0,$a0, 1
	sll $t1, $t1, 1
	
	beqz $t3, nibble
		addi $t1, $t1, 1
		
nibble:
	bge $t2, 31, increment3
		beqz $t1, increment3
			li $t4, 0xf0000000	# variable mask
			li $t5, 0x40000000	# varibale cmp
			li $t6, 0x30000000	# variable add
			
			li $t7, 0		# variable i for inner loop
		inner_loop:
			bge $t7, 8, increment3	# variable mv
				and $t8, $t4, $t1
			
				# if  mask is greater than  compare  add 3  to nibble
				ble $t8, $t5, shift_right
					add $t1, $t1, $t6
				
			shift_right:
				srl $t4, $t4, 4
				srl $t5, $t5, 4
				srl $t6, $t6, 4
				
				addi $t7, $t7, 1
				j inner_loop
			
	
increment3:
	addi $t2, $t2, 1
	j for_loop4

return:
	move $v0, $t1
   	jr $ra

error4:
	li $v0, -1
	jr $ra
