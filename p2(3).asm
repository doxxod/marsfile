.data
	str: .space 100

.text
	li $v0, 5
	syscall
	move $s0, $v0        # s0 = n
	li $t1, 4
	multu $t1, $s0   
	mflo $s1
	addiu $s1, $s1, -4   # s1 = n * 4 - 4
	
	li $t1, 0
	la $t3, str          #the first issue
	addu $t4, $t3, $s1	 #the last issue
	
loop_input:
	beq $t1, $s0, reset
	
	li $v0, 12
	syscall
	move $t2, $v0
	
	sw $t2, 0($t3)
	addiu $t3, $t3, 4

	addiu $t1, $t1, 1
	j loop_input

reset:
	la $t3, str

judge:
	beq $t3, $t4, print_1
	sltu $t5, $t4, $t3
	beq $t5, 1, print_1
	
	lw $t1, 0($t3)
	lw $t2, 0($t4)
	bne $t1, $t2, print_0
	
	addiu $t3, $t3, 4
	addiu $t4, $t4, -4
	
	j judge

print_1:
	li $a0, 1
	li $v0, 1
	syscall
	j end

print_0:
	li $a0, 0
	li $v0, 1
	syscall

end:



	
	