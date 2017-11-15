.data
	mex1: .space 320
	mex2: .space 320
	out: .space 320
	enter: .asciiz "\n"
	space: .asciiz " "
	
.text
	li $v0, 5
	syscall
	move $t0, $v0
	
	multu $t0, $t0
	mflo $t1
	
	la $s0, mex1
	la $s1, mex2
	la $s2, out
	
	li $t2, 0
	
loop_input1:
	beq $t2, $t1, initial 
	addiu $t2, $t2, 1
	
	li $v0, 5
	syscall 
	move $t3, $v0
	sw $t3, 0($s0)
	addiu $s0, $s0, 4
	
	j loop_input1

initial:
	li $t2, 0
	#la $s0, mex1

loop_input2:
	beq $t2, $t1, initial2
	addiu $t2, $t2, 1
	
	li $v0, 5
	syscall
	move $t3, $v0
	sw $t3, 0($s1)
	addiu $s1, $s1, 4
	
	j loop_input2

initial2:
	li $t2, 0
	li $t3, 4
	li $t5, 0
	
	multu $t3, $t0
	mflo $t3        #t3 = n*4
	
	la $t9, mex1
	la $t4, mex2
	la $s0, mex1
	la $s1, mex2
	li $t7, 0
	li $s3, 0

loop_mul:
	beq $t5, $t0, add_t2  # i == n ? next j : continue
	addiu $t5, $t5, 1
	
	lw $t6, 0($t9)        # t6 is mex1[x0, y0]
	addiu $t9, $t9, 4     #offset = 4
	lw $t8, 0($t4)
	addu $t4, $t4, $t3    #offset = n * 4
	multu $t6, $t8       
	mflo $t6
	addu $t7, $t7, $t6
	
	j loop_mul

add_t2:
	#it means row * col is finished
	li $t5, 0
	sw $t7, 0($s2)         # i == n : out[i][j] = t7
	li $t7, 0
	addiu $s2, $s2, 4
	addiu $s1, $s1, 4
	addiu $t2, $t2, 1			# next j
	beq $t2, $t0, next_line
	la $t4, 0($s1)
	la $t9, 0($s0)
	j loop_mul

next_line:
	addiu $s3, $s3, 1
	beq $s3, $t0, initial3
	li $t2, 0
	addu $s0, $s0, $t3
	la $t9, 0($s0)
	la $t4, mex2
	la $s1, mex2
	j loop_mul

initial3:
	li $t2, 0
	li $t3, 0
	la $s2, out
	j loop_print

loop_print:
	beq $t3, $t1, end
	addiu $t3, $t3, 1
	addiu $t2, $t2, 1
	
	lw $a0, 0($s2)
	li $v0, 1
	syscall
	addiu $s2, $s2, 4
	
	beq $t2, $t0, print_enter
	la $a0, space
	li $v0, 4
	syscall
	j loop_print

print_enter:
	la $a0, enter
	li $v0, 4
	syscall
	li $t2, 0
	j loop_print

end: