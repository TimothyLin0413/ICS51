# Tzu-Yu Lin
# tzuyul7


.data
str1: .asciiz "str:"
str_pattern: .asciiz "\tpattern:"
new_line: .asciiz "\n"
str_zero: .asciiz "return (0,0)\n"
str_one: .asciiz "return (1,"
str_newline: .asciiz ")\n"
str_one_zero: .asciiz "return (1,0)\n"
str_return: .asciiz "return ("
str_comma: .asciiz ", "

.text

##############################
# PART 1 FUNCTIONS
##############################

find_glob:
	#prologue 
	addi $sp, $sp, -32
   	sw $ra, 0($sp)	#ra 
   	sw $s0, 4($sp)	#str
   	sw $s1, 8($sp)	#pattern
   	sw $s2, 12($sp) #wildcard
   	sw $s3, 16($sp) #length(str)
   	sw $s4, 20($sp) #length(pattern)
   	sw $s5, 24($sp)	#match
   	sw $s6, 28($sp) #glob_len
   	
   	move $s0, $a0	#str
   	move $s1, $a1	#pattern
   	move $s2, $a2	#wildcard
   	
    	#Define your code here
    	la $a0, str1
    	li $v0, 4
    	syscall
    	
    	move $a0, $s0	#print str
    	li $v0, 4
    	syscall
    	
    	la $a0, str_pattern
    	li $v0, 4
    	syscall
    	
    	move $a0, $s1	#print pattern
    	li $v0, 4
    	syscall
    	
    	la $a0, new_line
    	li $v0, 4
    	syscall
    	
    	#get length of str
    	move $a0, $s0
    	jal length
    	move $s3, $v0
    	
    	#get length of pattern
    	move $a0, $s1
    	jal length
    	move $s4, $v0
    	
    	#xor 
    	#t0 = 1 = xor, 0 or 2 represent not xor
    	li $t0, 0
    	beqz $s3, c_pattern
    		addi $t0, $t0, 1
c_pattern:
	beqz $s4, check
		addi $t0, $t0, 1

check:
	bne $t0, 1, wildcard
		la $a0, str_zero
    		li $v0, 4
    		syscall
    		
    		li $v0, 0
    		li $v1, 0
    		j done2
		
wildcard:
	bne $s4, 1, identical
		lb $t1, 0($s1)
		bne $t1, $s2, identical
			la $a0, str_one
    			li $v0, 4
    			syscall
    			
    			move $a0, $s3
    			li $v0, 1
    			syscall
    			
    			la $a0, str_newline
    			li $v0, 4
    			syscall
    			
    			li $v0, 1
    			move $v1, $s3
    			j done2

identical:
	move $a0, $s0
	move $a1, $s1
	jal equals
	bne $v0, 1, recursive
		la $a0, str_one_zero
    		li $v0, 4
    		syscall
    		
    		li $v0, 1
    		li $v1, 0
    		j done2
recursive:
	lb $t2, 0($s0)	#str[0]
	lb $t3, 0($s1) 	#pattern[0]
	
	bne $t2, $t3, glob_match
		move $a0, $s0
		addi $a0, $a0, 1
		move $a1, $s1
		addi $a1, $a1, 1
		move $a2, $s2
		jal find_glob
		j done2
	
glob_match:
	lb $t3, 0($s1)
	bne $t3, $s2, return_zero
		move $a0, $s0
		move $a1, $s1
		addi $a1, $a1, 1
		move $a2, $s2
		jal find_glob
		move $s5, $v0
		move $s6, $v1
		
		bne $s5, 1, else	#match1
			la $a0, str_return
    			li $v0, 4
    			syscall
    		
    			move $a0, $s5
    			li $v0, 1
    			syscall
    			
    			la $a0, str_comma
    			li $v0, 4
    			syscall
    			
    			move $a0, $s6
    			li $v0, 1
    			syscall
    			
    			la $a0, str_newline
    			li $v0, 4
    			syscall
    			
    			move $v0, $s5
    			move $v1, $s6
    			j done2
	else:
		move $a0, $s0
		addi $a0, $a0, 1
		move $a1, $s1
		move $a2, $s2
		jal find_glob
		move $s5, $v0
		move $s6, $v1
		
		la $a0, str_return
    		li $v0, 4
    		syscall
    		
    		move $a0, $s5
    		li $v0, 1
    		syscall
    			
    		la $a0, str_comma
    		li $v0, 4
    		syscall
    			
    		move $a0, $s6
    		addi $a0, $a0, 1
    		li $v0, 1
    		syscall
    			
    		la $a0, str_newline
    		li $v0, 4
    		syscall
    			
    		move $v0, $s5
    		move $v1, $s6
    		addi $v1, $v1, 1
    		j done2
		
	
return_zero:
	la $a0, str_zero
    	li $v0, 4
    	syscall
    		
    	li $v0, 0
    	li $v1, 0

done2:
	# Epilogue
   	lw $ra, 0($sp)	#ra 
   	lw $s0, 4($sp)	#str
   	lw $s1, 8($sp)	#pattern
   	lw $s2, 12($sp) #wildcard
   	lw $s3, 16($sp)
   	lw $s4, 20($sp)
   	lw $s5, 24($sp)
   	lw $s6, 28($sp)
   	addi $sp, $sp, 32
    	jr $ra

##############################
# PART 2 FUNCTIONS
##############################

preorder:
    #Define your code here
    	#prologue
    	addi $sp, $sp,-20
    	sw $ra, 0($sp)
    	sw $s0, 4($sp) #nodes
    	sw $s1, 8($sp) #curNodeIndex
    	sw $s2, 12($sp) #nodes[curNodeIndex]
    	sw $s3, 16($sp) 
    	
    	move $s0, $a0
    	move $s1, $a1
    	
    	#print_statment
    	li $s3, 4
    	mul $s3, $s3, $s1
    	add $s2, $s3, $s0
    	
    	lhu $a0, 0($s2)
    	li $v0, 1
    	syscall
    	
    	la $a0, new_line
    	li $v0, 4
    	syscall
    	
    	#check left child node
    	lbu $a1, 3($s2)
    	beq $a1, 255, right_child
    		move $a0, $s0
    		jal preorder
    	
right_child:
	lbu $a1, 2($s2)
    	beq $a1, 255, return_preorder
    		move $a0, $s0
    		jal preorder
    	
    
return_preorder:
    	lw $ra, 0($sp)
    	lw $s0, 4($sp) #nodes
    	lw $s1, 8($sp) #curNodeIndex
    	lw $s2, 12($sp) #nodes[curNodeIndex]	
    	lw $s3, 16($sp) 
    	addi $sp, $sp,20
	jr $ra

position:
    #Define your code here
    ############################################
	addi $sp, $sp,-20
    	sw $ra, 0($sp)
    	sw $s0, 4($sp) #nodes
    	sw $s1, 8($sp) #curNodeIndex
    	sw $s2, 12($sp) #newvalue
    	sw $s3, 16($sp) 
    	
    	move $s0, $a0
    	move $s1, $a1
    	move $s2, $a2
    	
    	#check newValue < nodes[curNodeIndex].value
    	li $t0, 4
    	mul $t0, $t0, $s1
    	add $s3, $t0, $s0
    	lhu $t0, 0($s3)
    	
    	bge $s2, $t0, else_right
    	lbu $t1, 3($s3)	#leftIndex
    	bne $t1, 255, return_left
    		move $v0, $s1
    		li $v1, 0
    		j return_position
    	return_left:
    		move $a0, $s0
    		move $a1, $t1
    		move $a2, $s2
    		jal position
    		j return_position
    		
else_right:
	lbu $t1, 2($s3)	#rightIndex
    	bne $t1, 255, return_right
    		move $v0, $s1
    		li $v1, 1
    		j return_position
    	return_right:
    		move $a0, $s0
    		move $a1, $t1
    		move $a2, $s2
    		jal position
    		j return_position
    ###########################################
return_position:
    	lw $ra, 0($sp)
    	lw $s0, 4($sp) #nodes
    	lw $s1, 8($sp) #curNodeIndex
    	lw $s2, 12($sp) #newvalue
    	lw $s3, 16($sp)
    	addi $sp, $sp,20
    	jr $ra

insertNode:
    #Define your code here
	#prologue 
	addi $sp, $sp,-24
    	sw $ra, 0($sp)
    	sw $s0, 4($sp) #nodes
    	sw $s1, 8($sp) #rootIndex
    	sw $s2, 12($sp) #newvalue
    	sw $s3, 16($sp) 
    	sw $s4, 20($sp) #newIndex
    	
    	move $s0, $a0	#nodes
    	move $s1, $a1	#rootIndex
    	move $s2, $a2	#newvalue
    	
    	li $t0, 4
    	mul $t0, $t0, $s1
    	add $s3, $t0, $s0	#nodes[rootIndex]
    	
    	bne $s3, -1, not_empty
    		li $t8, 255
    		sb $t8, 3($s3)
    		sb $t8, 2($s3)
    		sh $s2, 0($s3)
    		li $v0, 1
    		
    		j return_insert_Node
not_empty:
	 move $a0, $s0
	 jal find_empty
	 move $s4, $v0	#newIndex
	 bgez $s4, find_valid_position
	 	li $v0, 0
	 	j return_insert_Node
	 
find_valid_position:
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	
	jal position
	
	li $t0, 4
    	mul $t0, $t0, $v0
    	add $t1, $t0, $s0	#nodes[parentIndex]
	
	bne $v1, 0, update_right
		sb $s4, 3($t1)
		j leaf_node
update_right:
	sb $s4, 2($t1)
    	
leaf_node:

	li $t0, 4
    	mul $t0, $t0, $s4
    	add $t1, $t0, $s0	#nodes[newIndex]
    	
	li $t8, 255
    	sb $t8, 3($t1)
    	sb $t8, 2($t1)
    	sh $s2, 0($t1)
    	
    	li $v0, 1
    	
return_insert_Node:
    	#epilogue
    	lw $ra, 0($sp)
    	lw $s0, 4($sp) #nodes
    	lw $s1, 8($sp) #rootIndex
    	lw $s2, 12($sp) #newvalue
    	lw $s3, 16($sp)
    	lw $s4, 20($sp) #newIndex
    	addi $sp, $sp,24
    	jr $ra


find_parent:
    #Define your code here
    	#Prologue
	addi $sp, $sp,-24
    	sw $ra, 0($sp)
    	sw $s0, 4($sp) #nodes
    	sw $s1, 8($sp) #curNodeIndex
    	sw $s2, 12($sp) #childIndex
    	sw $s3, 16($sp) 
    	sw $s4, 20($sp)
    	
    	move $s0, $a0
    	move $s1, $a1
    	move $s2, $a2
    	
    	#check childValue < nodes[curNodeIndex].value
    	li $t0, 4
    	
    	mul $t1, $t0, $s2
    	add $s4, $t1, $s0	#nodes[childIndex]
    	lhu $t9, 0($s4)		# childValue
    	
    	mul $t2, $t0, $s1
    	add $s3, $t2, $s0	#nodes[curNodeIndex]
    	lhu $t0, 0($s3)
    	
    	bge $t9, $t0, else_right2 
    	lbu $t1, 3($s3)	#leftIndex
    	
    	bne $t1, 255, else_if_equal
    		li $v0, -1
    		li $v1, -1
    		j return_find_parent
    	else_if_equal:
    	bne $t1, $s2, return_child_left
    		move $v0, $s1
    		li $v1, 0
    		j return_find_parent
    	return_child_left:
    		move $a0, $s0
    		move $a1, $t1
    		move $a2, $s2
    		jal find_parent
    		j return_find_parent
    		
else_right2:
	lbu $t1, 2($s3)	#rightIndex
    	bne $t1, 255, else_if_equal2
    		li $v0, -1
    		li $v1, -1
    		j return_find_parent
    	else_if_equal2:
    	bne $t1, $s2, return_child_right
    		move $v0, $s1
    		li $v1, 1
    		j return_find_parent
    	return_child_right:
    		move $a0, $s0
    		move $a1, $t1
    		move $a2, $s2
    		jal find_parent
    		j return_find_parent
    	
return_find_parent:
    	# Epilogue
    	lw $ra, 0($sp)
    	lw $s0, 4($sp) #nodes
    	lw $s1, 8($sp) #curNodeIndex
    	lw $s2, 12($sp) #childIndex
    	lw $s3, 16($sp)
    	lw $s4, 20($sp)
    	addi $sp, $sp,24
    	jr $ra


min:
    #Define your code here
	#Prologue
	addi $sp, $sp,-16
    	sw $ra, 0($sp)
    	sw $s0, 4($sp) #nodes
    	sw $s1, 8($sp) #curNodeIndex
    	sw $s2, 12($sp)
    	
    	move $s0, $a0
    	move $s1, $a1
    	
    	li $t0, 4
    	mul $t0, $t0, $s1
    	add $s2, $t0, $s0	#nodes[curNOdeIndex]
    	lbu $t0, 3($s2)
    	 
    	bne $t0, 255, else_min
    		move $v0, $s1	# curNodeINdex = vo
    		
    		lbu $t1, 2($s2)
    		bne $t1, 255, not_leaf
    			li $v1, 1
    			j return_min
    		not_leaf:
    			li $v1, 0
    			j return_min
    	
else_min:
	move $a0, $s0
	move $a1, $t0
	jal min
	
return_min:
	lw $ra, 0($sp)
    	lw $s0, 4($sp) #nodes
    	lw $s1, 8($sp) #curNodeIndex
    	lw $s2, 12($sp)
    	addi $sp, $sp, 16
   	jr $ra

deleteNode:
    #Define your code here
	#Prologue
	addi $sp, $sp,-32
    	sw $ra, 0($sp)
    	sw $s0, 4($sp) #nodes
    	sw $s1, 8($sp) #rootIndex
    	sw $s2, 12($sp) #deleteIndex
    	sw $s3, 16($sp) #nodes[deleteIndex]
    	sw $s4, 20($sp)
    	sw $s5, 24($sp)
    	sw $s6, 28($sp)

	move $s0, $a0
    	move $s1, $a1
    	move $s2, $a2	
	
	li $t0, 4
    	mul $t0, $t0, $s2
    	add $s3, $t0, $s0	#nodes[deleteIndex]
    	lbu $t0, 3($s3)
    	 
    	bne $t0, 255, else_not_leaf
    	lbu $t1, 2($s3)
    	bne $t1, 255, else_not_leaf
    	
    	bne $s2, $s1, get_parent
    	li $t4, -1
    	sw $t4, ($s3)
    	j return_deleteNode

get_parent:    	
    	move $a0, $s0
    	move $a1, $s1
    	move $a2, $s2
    	
    	jal find_parent	#v1, 0-> left, 1->right
    	
    	li $t0, 4
    	mul $t0, $t0, $v0
    	add $s4, $t0, $s0	#nodes[parentIndex]
    	li $t9, 255
    	
    	bnez $v1, delete_right
    		sb $t9, 3($s4)	# .left = 255
    		j delete_node
    	delete_right:
    		sb $t9, 2($s4)
delete_node:
    	li $t4, -1
    	sw $t4, ($s3)
    	j return_deleteNode
    	
#else_if    	
else_not_leaf:
	li $t9, 0	#t9 = 1 to have exactly one child
	lbu $t0, 3($s3)
    	bne $t0, 255, else_not_leaf
    	addi $t9, $t9,1
    	
    	lbu $t1, 2($s3)
    	bne $t1, 255, else_not_leaf
	addi $t9, $t9,1
	
	bne $t9, 1, two_child
		bne $t0, 255, right_only
		move $s5, $t0	#childIndex
		j delete_root
	right_only:
		move $s5, $t1	#childIndex

delete_root:
	bne $s2, $s1, not_root
		li $t0, 4
    		mul $t0, $t0, $s5
    		add $t8, $t0, $s0	#nodes[childIndex]
					#aka childNode
		move $s3, $t8
		li $t4, -1
    		sw $t4, ($t8)
		j return_deleteNode
		
not_root:
	move $a0, $s0
    	move $a1, $s1
    	move $a2, $s2
    	
    	jal find_parent	#v1, 0-> left, 1->right
    	
    	li $t0, 4
    	mul $t0, $t0, $v0
    	add $s4, $t0, $s0	#nodes[parentIndex]
    	
    	bnez $v1, child_right
    		sb $s5, 3($s4)	# .left = 255
    		j delete_node2
    	child_right:
    		sb $s5, 2($s4)
delete_node2:
    	li $t4, -1
    	sw $t4, ($s3)
    	j return_deleteNode	
	
	
two_child:
	move $a0, $s0
	lbu $a1, 2($s3)
	jal min
	
	move $s5, $v0	#minIndex
	move $s6, $v1	#minIsLeaf
	
	move $a0, $s0
	move $a1, $s2
	move $a2, $s5
	jal find_parent
	
	li $t0, 4
    	mul $t0, $t0, $v0
    	add $s4, $t0, $s0	#nodes[parentIndex]
    	li $t7, 255
    	
    	beqz $s6, is_not_leaf
    	
    	bnez $v1, leaf_right
    		sb $t7, 3($s4)	# .left = 255
    		j delete_node3
    	leaf_right:
    		sb $t7, 2($s4)	
    		j delete_node3
is_not_leaf:
	li $t0, 4
    	mul $t0, $t0, $s5
    	add $t4, $t0, $s0	#nodes[minIndex]
    	lbu $t3, 2($t4)	#.right
    	
	bnez $v1, sub_right
    		sb $t3, 3($s4)	# .left = nodes[minIndex].right
    		j delete_node3
    	sub_right:
    		sb $t3, 2($s4)	
    		j delete_node3
	
delete_node3:
	li $t0, 4
    	mul $t0, $t0, $s5
    	add $t4, $t0, $s0	#nodes[minIndex]
    	lhu $t3, 0($t4)
    	
    	sh $t3, 0($s3)
    	 
    	li $t5, -1
    	sw $t5, ($t4)
	
return_deleteNode:	
	# Epilogue
    	lw $ra, 0($sp)
    	lw $s0, 4($sp) #nodes
    	lw $s1, 8($sp) #rootIndex
    	lw $s2, 12($sp) #deleteIndex
    	lw $s3, 16($sp)
    	lw $s4, 20($sp)
    	lw $s5, 24($sp)
    	lw $s6, 28($sp)
    	addi $sp, $sp,32
    	jr $ra

.include "hw3_helpers.asm"
