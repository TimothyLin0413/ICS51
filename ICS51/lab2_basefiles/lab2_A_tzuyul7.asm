# Tzu-Yu Lin
# tzuyul7

.data
Invalid_Error: .asciiz " contains invalid characters\n"


.text
hex2bin:
	li $t1, 0     # i
	li $t2, 0     # value
	li $t3, 0     # binary 
	add $t0, $t1, $a0        # digit aka num[i]
	lb $t0, 0($t0)
loop:
	beq $t0, '\0',done
		sll $t3, $t3, 4
caseF:
	bne $t0, 'F', caseE
		li $t2, 15
		j increment
caseE:
	bne $t0, 'E', caseD
		li $t2, 14
		j increment
caseD:
	bne $t0, 'D', caseC
		li $t2, 13
		j increment
caseC:
	bne $t0, 'C', caseB
		li $t2, 12
		j increment
caseB:
	bne $t0, 'B', caseA
		li $t2, 11
		j increment
caseA:
	bne $t0, 'A', default
		li $t2, 10
		j increment
default:
	blt $t0, '0', else
		bgt $t0, '9',else
		        li $t9, 48
			sub $t4, $t0, $t9
			move $t2, $t4
			j increment
			
else:
	# print the error message
	addi $v0, $0, 4
    	la $a0, Invalid_Error
    	syscall
    	
    	# Terminate the program
	li $v0, 10
	syscall
	
increment:
	add $t3, $t3, $t2
	addi $t1, $t1, 1
	add $t0, $t1, $a0        # digit aka num[i]
	lb $t0, 0($t0)
	j loop
	
	
done:
	move $v0, $t3
	jr $ra
