# loading
lui $s0, 0x00001001
lw $t0, 0x00000000($s0)
lw $t1, 0x00000004($s0)
lw $t2, 0x00000008($s0)
lw $t3, 0x0000000C($s0)

multu $t0,$t2
mflo $s4
mfhi $s3
multu $t0,$t3
mfhi $s2
mflo $s5
addu $s3,$s3,$s5
sltu $s5,$s3,$s5
addu $s2,$s2,$s5
multu $t1,$t2
mflo $s5
mfhi $s6
addu $s3,$s3,$s5
sltu $s5,$s3,$s5
addu $s2,$s2,$s5
addu $s2,$s2,$s6
sltu $s6,$s2,$s6
addu $s1,$s1,$s6
multu $t1,$t3
mflo $s5
mfhi $s6
addu $s2,$s2,$s5
sltu $s5,$s2,$s5
addu $s1,$s1,$s5
addu $s1,$s1,$s6
sw $s1,0x00000010($s0)
sw $s2,0x00000014($s0)
sw $s3,0x00000018($s0)
sw $s4,0x0000001C($s0)

