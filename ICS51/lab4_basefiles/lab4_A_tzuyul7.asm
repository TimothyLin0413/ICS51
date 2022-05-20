# Tzu-Yu Lin
# tzuyul7

.text
sumArray:
	li $t0, 0	#sum
	
	li $t1, 0	#row count
for_loop:
	bge $t1, $a1, return_sum
	
	addi $t2, $a2, -1	#numCol-1
	mul $t3, $t1, $a2 	#row(i)*numcol
	add $t3, $t3, $t2	#i*numcols+j
	sll $t3, $t3, 2		#*4 (int size of bytes)
	add $t3, $a0, $t3	#baseAddress + above
	lw $t3, 0($t3)
	
	add $t0, $t0, $t3	#sum+= above
	addi $t1, $t1, 1
	j for_loop

return_sum:
	move $v0, $t0
	jr $ra

initArray:

	li $t1, 0	#row count
for_loop2:
	bge $t1, $a1, return
	
	addi $t2, $a2, -1	#numCol-1
	mul $t3, $t1, $a2 	#row(i)*numcol
	add $t3, $t3, $t2	#i*numcols+j
	sll $t3, $t3, 2		#*4 (int size of bytes)
	add $t3, $a0, $t3	#baseAddress + above
	
	li $t4, 0
	sw $t4, 0($t3)
	
	addi $t1, $t1, 1
	j for_loop2

return:
	jr $ra

