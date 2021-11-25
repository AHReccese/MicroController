# loading
lui $s1, 0x00001001
lw $t0, 0x00000000($s1)
lw $t1, 0x00000004($s1)
lw $t2, 0x00000008($s1)
lw $t3, 0x0000000C($s1)

# signed addition
add $t4,$t0,$t2
add $t5,$t1,$t3

# overflow
sltu $t6,$t4,$t0
add $t5,$t5,$t6

# storin
sw $t4,0x00000010($s1)
sw $t5,0x00000014($s1)


