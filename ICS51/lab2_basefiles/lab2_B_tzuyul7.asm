# Tzu-Yu Lin
# tzuyul7

.data
err_string: .asciiz "Array does not contain any values\n"

.text
findStats:

	li $t1, 0x0FFFFFFF	# min
	li $t2, 0x80000000	# max
	
	blt $a1, 1, no_value
		li $t3, 0	# i within the loop
	for_loop:
		bge $t3, $a1, return
			sll $t0, $t3, 2  # bytes for index i
			add $t0, $t0, $a0
			lw $t4, 0($t0)
			bge $t4, $t1, max
				move $t1, $t4
		max:
			ble $t4, $t2, increment2
				move $t2, $t4
		increment2:
			addi $t3, $t3, 1
			j for_loop
			
return:
	move $v0, $t1
	move $v1, $t2
	jr $ra
		
no_value:
	# print the string
	addi $v0, $0, 4
    	la $a0, err_string
    	syscall
	
	move $v0, $t1
	move $v1, $t2
	jr $ra
