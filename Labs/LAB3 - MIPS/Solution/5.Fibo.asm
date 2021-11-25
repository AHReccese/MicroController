	.text

	.globl	main
main:
	# Print msg1
	addi	$v0,$zero,4		# print_string syscall code = 4
	lui $a0,0x1001
  	ori $a0,$a0,0x0000												
	syscall	

	# Get N from user and save
	addi	$v0,$zero,5		# read_int syscall code = 5
	syscall	
	add	$t0,$v0,$zero		# syscall results returned in $v0

	# Initialize registers
	addi 	$t1,$zero,1 #a_i-2
	addi 	$t2,$zero,1 #a_i-1	
	addi	$t3,$zero,0 #number ---> a_i
	addi	$t4,$zero,0 #counter
	addi	$t6,$zero,0x0003
	slt 	$t5,$t0,$t6
	beq 	$t5,$t1,exit	
	addi 	$t0,$t0,-1
	
	# Main loop body
	
loop:	addi    $t4,$t4,1
	add	$t3,$t2,$t1
	add 	$t1,$zero,$t2
	add 	$t2,$zero,$t3
	beq	$t0,$t4, exit
	j	loop

	# Exit routine - print msg2
exit:	addi	$v0,$zero, 4		# print_string syscall code = 4
	lui $a0,0x1001
  	ori $a0,$a0,0x0017
	syscall

	# Print sum
	addi	$v0,$zero,1	# print_string syscall code = 4
	
	bne $t5,$zero,B		
A:	add	$a0,$t3,$zero   
B:	add 	$a0,$t1,$zero
	syscall

	# Print newline
	addi	$v0,$zero,4		# print_string syscall code = 4
	lui $a0,0x1001
  	ori $a0,$a0,0x0024
	syscall
	addi	$v0,$zero,10		# exit
	syscall

	# Start .data segment (data!)
	.data
msg1:	.asciiz	"Enter the Number(N)?  "
msg2:	.asciiz	"Fibonacci = "
lf:     .asciiz	"\n"
