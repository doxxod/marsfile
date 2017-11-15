.data
	vis: .space 400
	arr: .space 400
	space: .asciiz " "
	enter: .asciiz "\n"
	
.text
	li $v0, 5
	syscall
	move $s0, $v0        #s0 is n
	li $t1, 0
	#li $t2, 0           #as a counter
	la $s1, arr
	la $s2, vis
	li $s4, 4
	addiu $s5, $s0, 1
	li $s6, 1
	
	jal dfs
	j end

dfs:
	beq $t1, $s0, to_print  #index == n ?
	li $t2, 1               #t2 is i
	addiu $t4, $s2, 0       #t4 = vis + 0
	j loop_search

loop_search:
	beq $t2, $s5, stop      # if t2 = =n + 1 break
	multu $s4, $t2
	mflo $t6                # i * 4
	addu $t6, $s2, $t6      #symbol[i]
	addiu $t6, $t6, -4
	lw $t7, 0($t6)         
	beq $t7, 0, to_dfs      #symbol[i] == 0?
	addiu $t2, $t2, 1
	j loop_search

stop:
	jr $ra

to_dfs:
	sw $s6, 0($t6)          #symbol[i] = 1;
	
	multu $t1, $s4         #index * 4
	mflo $t7
	addu $t7, $s1, $t7     #array[index] 
	sw $t2, 0($t7)         #array[index] = i;

	sw $t1, 0($sp)        #store index, i, ra(ra is jal dfs)
	addiu $sp, $sp, -4
	sw $t2, 0($sp)       
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	addiu $sp, $sp, -4
	
	addiu $t1, $t1, 1
	jal dfs
	
	addiu $sp, $sp, 4    
	lw $ra, 0($sp)         #the forth layer index
	addiu $sp, $sp, 4
	lw $t2, 0($sp)         #the forth layer i
	addiu $sp, $sp, 4
	lw $t1, 0($sp)
	
	multu $s4, $t2         #(i + 1) * 4
	mflo $t6
	addu $t6, $t6, $s2    #vis + (i) * 4
	addiu $t6, $t6, -4     #vis + (i) * 4 - 4
	sw $0, 0($t6)	 				#vis[i] = 0;
	addiu $t2, $t2, 1      #i = i + 1
	
	j loop_search

to_print:
	addiu $t3, $s1, 0    #t3 is the i
	li $t2, 0
	j loop_print

loop_print:
	beq $t2, $s0, print_enter
	addiu $t2, $t2, 1
	
	lw $a0, 0($t3)
	li $v0, 1
	syscall              #output number
	
	addiu $t3, $t3, 4
	
	la $a0, space
	li $v0, 4 
	syscall              #output " "
	
	j loop_print

print_enter:
	li $t2 1
	la $a0, enter
	li $v0, 4
	syscall
  jr $ra
 
end:
	
	
	

	
	
	