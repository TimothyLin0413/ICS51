
# Tzu-Yu Lin
# tzuyul7

.text

##############################
# PART 1 FUNCTIONS
##############################


setCell:
    #Define your code here
    #Checking if input row is valid
    bltz $a0, return_invalid_cell
    bgt $a0, 9, return_invalid_cell	#row > 9
    
    #checking if input column is valid
    bltz $a1, return_invalid_cell
    bgt $a1, 9, return_invalid_cell	#column > 9
    
    #checking if fg is within 0x00, 0x0f
    
    #checing fg
    blt $a3, 0x00, return_invalid_cell
    bgt $a3, 0x0F , return_invalid_cell	
    
    #checking bg
    lw $t0, 0($sp)
    blt $t0, 0x00, return_invalid_cell
    bgt $t0, 0x0F , return_invalid_cell	
    
    #seting the cell since no error
    li $t9, 10
    mul $t1, $a0, $t9	# i *numcols
    add $t1, $t1, $a1	# + j
    sll $t1, $t1, 1	# * 2 (size of bytes)
    
    # 0xffff0000 = base address
    li $t8, 0xffff0000
    add $t2, $t1, $t8
    sb $a2,  0($t2)	#store the chr
    
    sll $t0, $t0, 4	#bg shift to the front 4 bits
    add $t7, $t0, $a3	#bg+fg 
    sb $t7, 1($t2)	#store color
    
    
    li $v0, 0
    jr $ra
return_invalid_cell:
	li $v0, -1
	jr $ra

initDisplay:
    # PROLOGUE
	addi $sp, $sp, -20
   	sw $ra, 0($sp)	
   	sw $s0, 4($sp)	#int fg
   	sw $s1, 8($sp)	#int bg
   	sw $s2, 12($sp) 
   	sw $s3, 16($sp) 
   	
   	move $s0, $a0
   	move $s1, $a1
   	
   	#loop through entire board
    	
    	# row count
    	li $s2, 0
    	# column count
    	li $s3, 0
    	
set_board_colors:
	bgt $s2, 9, return_initDisplay
		move $a0, $s2
		move $a1, $s3
		li $a2, '\0'
		move $a3, $s0
		addi $sp, $sp, -4
		sw $s1, 0($sp)
		jal setCell
		addi $sp, $sp, 4
		
		#increment row count if column at 9; otherwise increment column
		# jump back to the loop
		beq $s3, 9, increase_row_count
			addi $s3, $s3, 1
			j set_board_colors
			
	increase_row_count:
		# set column back to 0
		li $s3, 0
		addi $s2, $s2, 1
		j set_board_colors

return_initDisplay:
	#Epilogue
   	lw $ra, 0($sp)	
   	lw $s0, 4($sp)	#int fg
   	lw $s1, 8($sp)	#int bg
   	lw $s2, 12($sp) 
   	lw $s3, 16($sp) 	
   	addi $sp, $sp, 20
    	jr $ra

# void win(void)
win:
	# PROLOGUE
	addi $sp, $sp, -12
   	sw $ra, 0($sp)	
   	sw $s0, 4($sp)	
   	sw $s1, 8($sp)	

	#set initdisplay to default
   	li $a0, 0x0f
    	li $a1, 0x00
    	jal initDisplay
    	
    	#setCell(row, col, ch, FG, BG)
    	#printe "U"
    	# "col always 3, row 0-3"
    	li $s0, 0	#row count
 	li $s1, 3 
win_u_part1:
	bgt $s0, 3, win_u_part2
		move $a0, $s0
		move $a1, $s1
		li $a2, 'B'
		li $a3, 0x07
		li $t0, 0x0B
		addi $sp, $sp, -4
		sw $t0, 0($sp)
		jal setCell
		addi $sp, $sp, 4
		
		#increment if row = 3 jump next part
		beq $s0, 3, win_u_part2
		
		addi $s0, $s0, 1
		j win_u_part1
    	
    	# "row 3 col 4-5"
win_u_part2:
	li $s0, 3
 	li $s1, 4	#column
win_u_part2_loop:
	bgt $s1, 5, win_u_part3
		move $a0, $s0
		move $a1, $s1
		li $a2, 'B'
		li $a3, 0x07
		li $t0, 0x0B
		addi $sp, $sp, -4
		sw $t0, 0($sp)
		jal setCell
		addi $sp, $sp, 4
		
		#increment; if col > 5 jump next part
		beq $s1, 5, win_u_part3
		
		addi $s1, $s1, 1
		j win_u_part2_loop
	
    	# col always 6, row 0 - 3"
win_u_part3:
	li $s0, 0	#row count
 	li $s1, 6 
win_u_part3_loop:
	bgt $s0, 3, win_u_part2
		move $a0, $s0
		move $a1, $s1
		li $a2, 'B'
		li $a3, 0x07
		li $t0, 0x0B
		addi $sp, $sp, -4
		sw $t0, 0($sp)
		jal setCell
		addi $sp, $sp, 4
		
		#increment if row = 3 jump next part
		beq $s0, 3, win_w_part1
		
		addi $s0, $s0, 1
		j win_u_part3_loop
		
#print w
win_w_part1:
	li $s0, 5
 	li $s1, 0
win_w_part1_loop:
	bgt $s0, 9, win_w_part2
		move $a0, $s0
		move $a1, $s1
		li $a2, 'E'
		li $a3, 0x0f
		li $t0, 0x01
		addi $sp, $sp, -4
		sw $t0, 0($sp)
		jal setCell
		addi $sp, $sp, 4
		
		#increment; if row = 9 jump next part
		beq $s0, 9, win_w_part2
		
		addi $s0, $s0, 1
		j win_w_part1_loop
		
win_w_part2:
	# (8,1) , (7,2), (8,3)
	li $a0, 8
	li $a1, 1
	li $a2, 'E'
	li $a3, 0x0f
	li $t0, 0x01
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal setCell
	addi $sp, $sp, 4
	
	li $a0, 7
	li $a1, 2
	li $a2, 'E'
	li $a3, 0x0f
	li $t0, 0x01
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal setCell
	addi $sp, $sp, 4
	
	li $a0, 8
	li $a1, 3
	li $a2, 'E'
	li $a3, 0x0f
	li $t0, 0x01
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal setCell
	addi $sp, $sp, 4
	
#w part 3
	li $s0, 5
 	li $s1, 4
win_w_part3_loop:
	bgt $s0, 9, win_w_part2
		move $a0, $s0
		move $a1, $s1
		li $a2, 'E'
		li $a3, 0x0f
		li $t0, 0x01
		addi $sp, $sp, -4
		sw $t0, 0($sp)
		jal setCell
		addi $sp, $sp, 4
		
		#increment; if row = 9 jump next part
		beq $s0, 9, win_i_part1
		
		addi $s0, $s0, 1
		j win_w_part3_loop
	
win_i_part1:
	li $s0, 5
 	li $s1, 5
win_i_part1_loop:
	bgt $s0, 9, win_w_part2
		move $a0, $s0
		move $a1, $s1
		li $a2, 'F'
		li $a3, 0x0D
		li $t0, 0x0C
		addi $sp, $sp, -4
		sw $t0, 0($sp)
		jal setCell
		addi $sp, $sp, 4
		
		#increment; if row = 9 jump next part
		beq $s0, 9, win_n_part1
		
		addi $s0, $s0, 1
		j win_i_part1_loop
	
win_n_part1:
	li $s0, 5
 	li $s1, 6
win_n_part1_loop:
	bgt $s0, 9, win_w_part2
		move $a0, $s0
		move $a1, $s1
		li $a2, '8'
		li $a3, 0x0f
		li $t0, 0x02
		addi $sp, $sp, -4
		sw $t0, 0($sp)
		jal setCell
		addi $sp, $sp, 4
		
		#increment; if row = 9 jump next part
		beq $s0, 9, win_n_part2
		
		addi $s0, $s0, 1
		j win_n_part1_loop
		
win_n_part2:
	#(6,7) (7,8)
	li $a0, 6
	li $a1, 7
	li $a2, '8'
	li $a3, 0x0f
	li $t0, 0x02
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal setCell
	addi $sp, $sp, 4
	
	li $a0, 7
	li $a1, 8
	li $a2, '8'
	li $a3, 0x0f
	li $t0, 0x02
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal setCell
	addi $sp, $sp, 4
	
#n part 3
	li $s0, 5
 	li $s1, 9
win_n_part3_loop:
	bgt $s0, 9, win_w_part2
		move $a0, $s0
		move $a1, $s1
		li $a2, '8'
		li $a3, 0x0f
		li $t0, 0x02
		addi $sp, $sp, -4
		sw $t0, 0($sp)
		jal setCell
		addi $sp, $sp, 4
		
		#increment; if row = 9 jump next part
		beq $s0, 9, return_win
		
		addi $s0, $s0, 1
		j win_n_part3_loop
    	
return_win:
	# Ppilogue
   	lw $ra, 0($sp)	
   	lw $s0, 4($sp)	
   	lw $s1, 8($sp)
   	addi $sp, $sp, 12
	jr $ra

##############################
# PART 2 FUNCTION
##############################

loadMap:
	#Prologue
	addi $sp, $sp, -32
	sw $ra, 0($sp)	
   	sw $s0, 4($sp) #char[] filename
  	sw $s1, 8($sp)	#byte[] array
   	sw $s2, 12($sp) 
   	sw $s3, 16($sp) 
   	sw $s4, 20($sp)
   	sw $s5, 24($sp)
   	
    
    	move $s0, $a0
    	move $s1, $a1
    	
    	#clear byte[] array
    	# row, col count to 0
    	li $s2, 0
    	li $s3, 0
clear_byte_array:
	bgt $s2, 9, open_file
		li $t9, 10
    		mul $t1, $s2, $t9	# i *numcols
    		add $t1, $t1, $s3	# + j
    		sll $t1, $t1, 1	# * 2 (size of bytes)
    		
    		#base address = s1
   	 	add $t2, $t1, $s1
   	 	li $t8, 0x80
    	 	sb $t8,  0($t2)		#bit 0-7 = 0b10000000
   	 	
		#increment row count if column at 9; otherwise increment column
		# jump back to the loop
		beq $s3, 9, increase_byte_row_count
			addi $s3, $s3, 1
			j  clear_byte_array
			
	increase_byte_row_count:
		# set column back to 0
		li $s3, 0
		addi $s2, $s2, 1
		j clear_byte_array
    	
open_file:
    	#open file
    	li $v0, 13
    	move $a0, $s0
    	li $a1, 0
    	li $a2, 0
    	syscall
    	
    	bltz $v0, loadMap_error
    	move $s2, $v0
    	
read_file:
    	#read from file
    	li $v0, 14
    	move $a0, $s2
    	move $a1, $sp
    	li $a2, 4
    	syscall
    	
    	#$sp contains 4 bytes from the line
    	bltz $v0, loadMap_error
    	beqz $v0, end_of_file
    	
    	lb $s4, 0($sp)
    	#checking if row is valid
    	bgt $s4, 9, loadMap_error
    	bltz $s4, loadMap_error
    	
    	lb $t7, 1($sp)
    	li $t2, ' '
    	bne $t7, $t2, loadMap_error
    	
    	lb $s5, 2($sp)
    	#checking if column is valid
    	bltz $s5, loadMap_error
    	bgt $s5, 9,loadMap_error
    	
    	lb $t7, 3($sp)
    	li $t2, '\n'
    	bne $t7, $t2, loadMap_error
    	
    	
    	#if everthing good; set the bomb
    	#t0 = valid row; t1 = valid column
   	li $t9, 10
   	mul $t1, $s4, $t9	# i *numcols
   	add $t2, $t2, $s5	# + j
   	sll $t2, $t2, 1	# * 2 (size of bytes)
    
   	# s0 = base address
   	add $t3, $t2, $s0
   	lb $t6, 0($t3)
   	
   	# if repeated ignore calcadjacent
   	beq $t6, 0xA0, read_file
   	
   	li $t8, 0xA0
    	sb $t8,  0($t3)		#bit 0-7 = 0b10100000
    	
    	#calcAdjacent (row, col, bye[])
    	move $a0, $s4
    	move $a1, $s5
    	move $a2, $s1
    	jal calcAdjacent
    	
    	j read_file
    	
end_of_file:
    	#close file
    	li $v0, 16
    	move $a0, $s2
    	syscall
    	
    	li $v0, 0
    	j return_loadMap
    	
loadMap_error:
	#close file
    	li $v0, 16
    	move $a0, $s2
    	syscall
    	
	li $v0, -1

return_loadMap:
	#Epilogue
	lw $ra, 0($sp)	
   	lw $s0, 4($sp) #char[] filename
  	lw $s1, 8($sp)	#byte[] array
   	lw $s2, 12($sp) 
   	lw $s3, 16($sp) 
   	lw $s4, 20($sp)
   	lw $s5, 24($sp)
   	addi $sp, $sp, 32
    	jr $ra

##############################
# PART 3 FUNCTION
##############################

mapReveal:
    #Define your code here
    jr $ra


##############################
# PART 4 FUNCTIONS
##############################

playerMove:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $v0, -200
    ##########################################
    jr $ra

gameStatus:
    #Define your code here
    ############################################
    # DELETE THIS CODE. Only here to allow main program to run without fully implementing the function
    li $v0, -200
    ##########################################
    jr $ra

##############################
# PART EC FUNCTIONS
##############################

revealCells:
    #Define your code here
    jr $ra

calcAdjacent:
	li $t9, 10
	
	#check if (up 1, left 1) is ava space
	addi $t0, $a0, -1
	bltz $t0, check_up
	addi $t1, $a1, -1
	bltz $t1, check_up
	
    	mul $t5, $t0, $t9	# i *numcols
    	add $t5, $t5, $t1	# + j
    	sll $t5, $t5, 1	# * 2 (size of bytes)
    		
    	#base address = s2
    	#t7 = space adjacent to bomb
   	add $t6, $t5, $a2
   	lb $t7, 0($t6)
   	#increment by 1 in bit 0-3
   	addi $t7, $t7, 1
   	sb $t7, 0($t6)
   	
check_up:
	#check if (up 1) is ava space
	addi $t0, $a0, -1
	bltz $t0, check_up_right
	
    	mul $t5, $t0, $t9	# i *numcols
    	add $t5, $t5, $a1	# + j
    	sll $t5, $t5, 1	# * 2 (size of bytes)
    		
    	#base address = s2
    	#t7 = space adjacent to bomb
   	add $t6, $t5, $a2
   	lb $t7, 0($t6)
   	#increment by 1 in bit 0-3
   	addi $t7, $t7, 1
   	sb $t7, 0($t6)
   	
check_up_right:
	#check if (up 1, right 1) is ava space
	addi $t0, $a0, -1
	bltz, $t0, check_left
	addi $t1, $a1, 1
	bgt $t1, 9, check_left
	
    	mul $t5, $t0, $t9	# i *numcols
    	add $t5, $t5, $t1	# + j
    	sll $t5, $t5, 1	# * 2 (size of bytes)
    		
    	#base address = s2
    	#t7 = space adjacent to bomb
   	add $t6, $t5, $a2
   	lb $t7, 0($t6)
   	#increment by 1 in bit 0-3
   	addi $t7, $t7, 1
   	sb $t7, 0($t6)
   	
check_left:
	#check if (left, 1) is ava space
	addi $t1, $a1, -1
	bltz $t1, check_right
	
    	mul $t5, $a0, $t9	# i *numcols
    	add $t5, $t5, $t1	# + j
    	sll $t5, $t5, 1	# * 2 (size of bytes)
    		
    	#base address = s2
    	#t7 = space adjacent to bomb
   	add $t6, $t5, $a2
   	lb $t7, 0($t6)
   	#increment by 1 in bit 0-3
   	addi $t7, $t7, 1
   	sb $t7, 0($t6)
		
check_right:
	#check if (right 1) is ava space
	addi $t1, $a1, 1
	bgt $t1, 9, check_bottom_left
	
    	mul $t5, $a0, $t9	# i *numcols
    	add $t5, $t5, $t1	# + j
    	sll $t5, $t5, 1	# * 2 (size of bytes)
    		
    	#base address = s2
    	#t7 = space adjacent to bomb
   	add $t6, $t5, $a2
   	lb $t7, 0($t6)
   	#increment by 1 in bit 0-3
   	addi $t7, $t7, 1
   	sb $t7, 0($t6)		
   	
check_bottom_left:
#check if (down 1, left 1) is ava space
	addi $t0, $a0, 1
	bgt $t0, 9, check_bottom
	addi $t1, $a1, -1
	bltz $t1, check_bottom
	
    	mul $t5, $t0, $t9	# i *numcols
    	add $t5, $t5, $t1	# + j
    	sll $t5, $t5, 1	# * 2 (size of bytes)
    		
    	#base address = s2
    	#t7 = space adjacent to bomb
   	add $t6, $t5, $a2
   	lb $t7, 0($t6)
   	#increment by 1 in bit 0-3
   	addi $t7, $t7, 1
   	sb $t7, 0($t6)
   	
check_bottom:
	#check if (bottom 1) is ava space
	addi $t0, $a0, 1
	bgt $t0, 9, check_bottom_right
	
    	mul $t5, $t0, $t9	# i *numcols
    	add $t5, $t5, $a1	# + j
    	sll $t5, $t5, 1	# * 2 (size of bytes)
    		
    	#base address = s2
    	#t7 = space adjacent to bomb
   	add $t6, $t5, $a2
   	lb $t7, 0($t6)
   	#increment by 1 in bit 0-3
   	addi $t7, $t7, 1
   	sb $t7, 0($t6)
   	
check_bottom_right:
	#check if (down 1, right 1) is ava space
	addi $t0, $a0, 1
	bgt, $t0, 9, return_calcAdjacent
	addi $t1, $a1, 1
	bgt $t1, 9, return_calcAdjacent
	
    	mul $t5, $t0, $t9	# i *numcols
    	add $t5, $t5, $t1	# + j
    	sll $t5, $t5, 1	# * 2 (size of bytes)
    		
    	#base address = s2
    	#t7 = space adjacent to bomb
   	add $t6, $t5, $a2
   	lb $t7, 0($t6)
   	#increment by 1 in bit 0-3
   	addi $t7, $t7, 1
   	sb $t7, 0($t6)
		
return_calcAdjacent:
	jr $ra

#################################################################
# Student defined data section
#################################################################
.data
.align 2  # Align next items to word boundary
cells_array: .space 200


