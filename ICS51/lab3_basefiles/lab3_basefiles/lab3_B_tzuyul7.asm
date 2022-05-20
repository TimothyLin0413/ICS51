# Tzu-Yu Lin
# tzuyul7

.data
# Declare your global variables here
str_passed: .asciiz "Passed Level: "
str_levelup: .asciiz "\nLevelUp! Life at "
str_gameover: .asciiz "Game Over! Sonic died on Level:"
str_win: .asciiz "You Win!\n"
str_newline: .asciiz "\n"

.text
playSonic:
	#prologue
	addi $sp, $sp, -36
   	sw $ra, 0($sp)	#ra 
   	sw $s0, 4($sp)
   	sw $s1, 8($sp)	#numLives
   	sw $s3, 12($sp)
   	sw $s6, 16($sp)	#ringstr
   	sw $s7, 20($sp)	#strArray
   	sw $s2, 24($sp)	#numRings
   	sw $s4, 28($sp)	#numstr -1
   	sw $s5, 32($sp)	#enemyStr
   	
   	move $s7, $a0
   	move $s5, $a2
   	move $s6, $a3
		
	#body
	li $s0, 100	#ringsPerLife
	li $s1, 1	#numlives
	li $s2, 0	#numRings
	
	li $s3, 0	#counter i
	addi $s4, $a1, -1
	
for_loop:
	bgt $s3, $s4, done
		#strArray[i]
		lw $a0, 0($s7)
		# run sonicRun
		move $a1, $s6
		move $a2, $s5
		move $a3, $s1
		addi $sp, $sp, -8
    		sw $s2,  4($sp) 
    		sw $s0, 0($sp) 
		jal sonicRun
		addi $sp, $sp, 8
		#store back value
		move $s1, $v0
		move $s2, $v1
		
		bne $s1, -1, else
			#print game over
			la $a0, str_gameover
    			li $v0, 4
    			syscall
    			
    			lw $a0, 0($s7)
    			li $v0, 4
    			syscall
    			
			jal return2
		else:
			addi $s0, $s0, 50
			# print passed level
			la $a0, str_passed
    			li $v0, 4
    			syscall
			
			lw $a0, 0($s7)
    			li $v0, 4
    			syscall
    			
    			la $a0, str_levelup
    			li $v0, 4
    			syscall
    			
    			move $a0, $s0
    			li $v0, 1
    			syscall
    			
    			la $a0, str_newline
    			li $v0, 4
    			syscall
    			
    		increment:
    			#printStats
    			addi $a0, $s3, 1
    			move $a1, $s1
    			move $a2, $s2
    			jal printStats
    			
    			addi $s3, $s3, 1
    			addi $s7, $s7, 4
			jal for_loop
	
done:
#print you win		
    	la $a0, str_win
    	li $v0, 4
    	syscall
return2:	
   	lw $ra, 0($sp)	#ra 
   	lw $s0, 4($sp)
   	lw $s1, 8($sp)	#numLives
   	lw $s3, 12($sp)
   	lw $s6, 16($sp)	#ringstr
   	lw $s7, 20($sp)	#strArray
   	lw $s2, 24($sp)	#numRings
   	lw $s4, 28($sp)	#numstr -1
   	lw $s5, 32($sp)	#enemyStr
   	addi $sp, $sp, 36
	jr $ra


