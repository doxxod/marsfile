.data
	array: .space 440
	space: .asciiz " "

.text
	li $v0, 5
	syscall
	move $s0, $v0      #s0 is n
	
	li $t0, 0          # as a counter
	la $t1, array
	
loop_input:
	beq $t0, $s0, reset
	li $v0, 5
	syscall
	move $t2, $v0
	
	sw $t2, 0($t1)
	addiu $t1, $t1, 4
	addiu $t0, $t0, 1
	
	j loop_input

reset:
	la $t1, array
	la $t2, array
	la $t8, array
	li $t0, 0
	li $t3, 0xffffff       # min
	li $t5, 0
	li $t6, 4
	
loop_op:
	beq $t0, $s0, next_turn
	lw $t4, 0($t1)
	addiu $t1, $t1, 4      #next issue
	sltu $s1, $t4, $t3
	addiu $t0, $t0, 1 
	beq $s1, 1, change_min
	j loop_op
	
next_turn:
	lw $t7, 0($t8)        # tmp = a[i]
	sw $t7, 0($s2)				# a[j] = tmp;
	sw $t3, 0($t8)        # a[i] = a[j];

	addiu $t5, $t5, 1      #next begin
	beq $t5, $s0, initial
	addiu $t0, $t5, 0
	multu $t5, $t6				 #t5 * 4
	mflo $t1							 #t1 = t5 * 4
	addu $t1, $t1, $t2     #t1 = array + t5 * 4
	addu $t8, $t1, 0       #t8 = t1

	li $t3, 0xffffff
	j loop_op

change_min:
	addiu $t3, $t4, 0
	addiu $s2, $t1, -4
	j loop_op

initial:
	li $t1, 0
	la $t2, array

loop_print:
	beq $t1, $s0, end
	lw $a0, 0($t2)
	li $v0, 1
	syscall
	la $a0, space
	li $v0, 4
	syscall
	
	addiu $t2, $t2, 4
	addiu $t1, $t1, 1
	j loop_print
	
end:

	
	
	
