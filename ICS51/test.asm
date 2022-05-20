addi $sp, $sp, -8
sw $s0, 0($sp)
sw $s1, 4($sp)

li $t0, 1
sw $t0, 8($sp)
li $t2, 100
sw $t2, 8($sp)

lw $a0, 8($sp)
li $v0, 1
syscall 