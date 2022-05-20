# hw4_self_testing.asm
.include "hw4_tzuyul7.asm"


.globl main

.data
chr: .ascii "f"

.text
main:
	# test setCell
	li $a0, 5
	li $a1, 4
	li $a2, '1'
	li $a3, 0x00
	
	addi $sp, $sp, -4
	li $t0, 0x0f
	sw $t0, 0($sp)	#setCell()
	jal setCell
	addi $sp, $sp, 4
	
	move $a0, $v0	#print result of setCell()
    	li $v0, 1
    	syscall
    	
    	# test initDisplay
    	li $a0, 0x0f
    	li $a1, 0x07
    	jal initDisplay
    	
    	#test win
    	jal win
    	
    	
	
	
	
