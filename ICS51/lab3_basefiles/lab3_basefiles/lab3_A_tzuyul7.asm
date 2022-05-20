# Tzu-Yu Lin
# tzuyul7	


.data
str_rings: .asciiz " RINGS!\n"
str_enemy: .asciiz "Hit Enemy "
str_gone: .asciiz " Rings gone.\n"
str_life: .asciiz " No Rings, lost life.\n"
str_ran: .asciiz "Ran through "
newlinee: .asciiz "\n"

.text
sonicRun:
	# prologue
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	
	addi $sp, $sp, -40
   	sw $ra, 0($sp)	#ra 
   	sw $s0, 4($sp)	#str
   	sw $s1, 8($sp)	#ringStr
   	sw $s2, 12($sp) #numRIngs
   	sw $s3, 16($sp)	#ringsPerLife
   	sw $s4, 20($sp)	#counter
   	sw $s5, 24($sp)	
   	sw $s6, 28($sp)
   	sw $s7, 32($sp)	#numlives
   	sw $a2, 36($sp)
   	
   	move $s2, $t1
   	move $s3, $t0
   	move $s0, $a0
   	move $s1, $a1
   	move $s7, $a3

   	li $s4, 0
   	li $s5, 0
   	li $s6, 0

   	
   	
   	lb $s4, 0($s0)	
loop:
	beq $s4, 0, value
		#print str_ran
    		la $a0, str_ran
    		li $v0, 4
    		syscall
    		
    		move $a0, $s4
    		li $v0, 11
    		syscall 
		
		la $a0, newlinee
    		li $v0, 4
    		syscall
    		
    		# new variable hitEnemy -> 1 if hit else 0
    		move $a0, $s4
    		lw $a1, 36($sp)
    		jal inString
    		move $s5, $v0 	#store the return value
    		
    		# new variable collectRing -> return index of matach in ringStr, else -1
    		move $a0, $s4
    		move $a1, $s1
    		jal indexString
    		move $s6, $v0	#store the return value
    		
    		bltz $s6, else_if
    			li $a0, 5
    			move $a1, $s6
    			addi $a1, $a1, 1
    			# power(5, collectRings+1)
    			jal power
    			move $t7, $v0 	#store the return value
    			
    			#print rings
    			move $a0, $t7
    			li $v0, 1
    			syscall 
    			
    			la $a0, str_rings
    			li $v0, 4
    			syscall
    			
    			#getLife(numRings + r, ringsPerLife)
    			move $a0, $s2
    			add $a0, $a0, $t7
    			move $a1, $s3
    			jal getLife
    			move $s2, $v1
    			add $s7, $s7, $v0
    			
    			j nothing
	else_if:
		bne $s5, 1, else_if2
			blez $s2, else_if2
				li $s2, 0
				#print hitEnemy
    				la $a0, str_enemy
    				li $v0, 4
    				syscall
    				
    				move $a0, $s4
    				li $v0, 11
    				syscall 
    				
    				la $a0, str_gone
    				li $v0, 4
    				syscall
    				
    				j nothing
	else_if2:
		bne $s5, 1,nothing
			addi $s7, $s7, -1
			bgtz $s7, print
				li $v0, -1
				li $v1, -1
				j return
		print:
			#print hitEnemy
    			la $a0, str_enemy
			li $v0, 4
    			syscall
    				
    			move $a0, $s4
    			li $v0, 11
    			syscall 
    				
    			la $a0, str_life
    			li $v0, 4
    			syscall
	nothing:
		addi $s0, $s0, 1	# go to the memory address of the string	
		lb $s4, 0($s0)		# get the character from the string
		j loop
value:	
	move $v0, $s7
	move $v1, $s2
return:
	lw $ra, 0($sp)	#ra 
   	lw $s0, 4($sp)	#str
   	lw $s1, 8($sp)	#ringStr
   	lw $s2, 12($sp) #numRIngs
   	lw $s3, 16($sp)	#ringsPerLife
   	lw $s4, 20($sp)	#counter
   	lw $s5, 24($sp) 
   	lw $s6, 28($sp)
   	lw $s7, 32($sp)
   	sw $a2, 36($sp)
   	addi $sp, $sp, 40
	jr $ra





