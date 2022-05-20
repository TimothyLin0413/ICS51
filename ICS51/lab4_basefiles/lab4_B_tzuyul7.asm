# Tzu-Yu Lin
# tzuyul7

.data
new_line: .asciiz "\n"

.text
printHist:
	# PROLOGUE
	addi $sp, $sp, -28
   	sw $ra, 0($sp)	
   	sw $s0, 4($sp)	#histArray[][]
   	sw $s1, 8($sp)	#numrows
   	sw $s2, 12($sp) #row counter
   	sw $s3, 16($sp) 
   	sw $s4, 20($sp) 
   	sw $s5, 24($sp)	
   	
   	
   	move $s0, $a0
   	move $s1, $a1
   	
   	li $s2, 0	#row count
for_loop3:
	bge $s2, $s1, return2
	
	sll $s3, $s2, 1		#row(i) * 2
	addi $s4, $s3, 0	#i*numcols+0 [row][0]
	addi $s5, $s3, 1	#i*numcols+1 [row][1]
	sll $s4, $s4, 2		#*4 (int size of bytes)
	sll $s5, $s5, 2		#*4 (int size of bytes)
	
	add $s4, $s0, $s4	#baseAddress[row][0]
	add $s5, $s0, $s5	#baseAddress[row][1]
	
	lb $s4, 0($s4)
	lw $s5, 0($s5)
	
	move $a0, $s4
	move $a1, $s5
	jal printHistRow
	
	#print new line
	la $a0, new_line
    	li $v0, 4
    	syscall
	
	addi $s2, $s2, 1
	j for_loop3
return2:
	# epilogue
   	lw $ra, 0($sp)	
   	lw $s0, 4($sp)	#histArray[][]
   	lw $s1, 8($sp)	#numrows
   	lw $s2, 12($sp) #row counter
   	lw $s3, 16($sp) 
   	lw $s4, 20($sp) 
   	lw $s5, 24($sp)	
   	addi $sp, $sp, 28
	jr $ra


countHist:
   	# PROLOGUE
	addi $sp, $sp, -32
   	sw $ra, 0($sp)	
   	sw $s0, 4($sp)	#histArray[][]
   	sw $s1, 8($sp)	#numrows
   	sw $s2, 12($sp) #row counter
   	sw $s3, 16($sp) 
   	sw $s4, 20($sp) 
   	sw $s5, 24($sp)	
   	sw $s6, 28($sp)	#mystr[]
   	
   	
   	move $s0, $a0
   	move $s1, $a1
   	move $s6, $a2
   	
   	li $s2, 0	#row count
for_loop4:
	bge $s2, $s1, return3
	
	sll $s3, $s2, 1		#row(i) * 2
	addi $s4, $s3, 0	#i*numcols+0 [row][0]
	addi $s5, $s3, 1	#i*numcols+1 [row][1]
	sll $s4, $s4, 2		#*4 (int size of bytes)
	sll $s5, $s5, 2		#*4 (int size of bytes)
	
	add $s4, $s0, $s4	#baseAddress[row][0]
	add $s5, $s0, $s5	#baseAddress[row][1]
	
	lb $s4, 0($s4)
	
	move $a0, $s6
	move $a1, $s4
	jal countChars
	
	lw $t0, 0($s5)
	add $v0, $t0, $v0
	sw $v0, 0($s5)
	
	addi $s2, $s2, 1
	j for_loop4
return3:
	# epilogue
   	lw $ra, 0($sp)	
   	lw $s0, 4($sp)	#histArray[][]
   	lw $s1, 8($sp)	#numrows
   	lw $s2, 12($sp) #row counter
   	lw $s3, 16($sp) 
   	lw $s4, 20($sp) 
   	lw $s5, 24($sp)	
   	lw $s6, 28($sp)
   	addi $sp, $sp, 32
	jr $ra

