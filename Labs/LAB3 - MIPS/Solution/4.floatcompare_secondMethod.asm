# loading
lui $s0, 0x00001001
lw $t0, 0x00000000($s0)
lw $t1, 0x00000004($s0)
srl $t2, $t0, 31
srl $t3, $t1, 31
beq $t2, $t3, equalSign
	sltu $t4, $t2, $t3
	beq $t4, $0, first
		addu $s1, $0, $t0
		addu $s2, $0, $t1
		j end1
	first:
		addu $s1, $0, $t1
		addu $s2, $0, $t0
		j end1
equalSign:
	beq $t2, $0, second
		sll $t4, $t0, 1 # see readme :)
		sll $t5, $t1, 1
		sltu $t6, $t4, $t5
		beq $t6, $0, third
			addu $s1, $0, $t0
			addu $s2, $0, $t1
			j end1	
		third:
			addu $s1, $0, $t1
			addu $s2, $0, $t0
			j end1
	second:
		sll $t4, $t0, 1
		sll $t5, $t1, 1
		sltu $t6, $t4, $t5
		beq $t6, $0, fourth
			addu $s2, $0, $t0
			addu $s1, $0, $t1
			j end1	
		fourth:
			addu $s2, $0, $t1
			addu $s1, $0, $t0
			j end1
	
end1:
sw $s1,0x00000000($s0)
sw $s2,0x00000004($s0)
# readme: in floating point number when I remove their signs, if exponent1 > exponent2, I can say $t4 > $t5! because 
# exponent is in more valuable place than mantissa. and if exponent1 == exponent2, mantissa is important now but agian:
# (if mantissa1 > mantissa2) $t4 > $t5 because valuable bits are equal! it means I can compare floating point numbers 
# with removed sign instead numbers!



