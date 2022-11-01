# PROGRAM: CSCI 201 MIPS Programming Project 1

.data
	userInput: .space 12			# Set input character limit

.text
	main:					# Start of code section   
		li $v0, 8			# 8 = code to read string
		la $a0, userInput		# Get text from input
		li $a1, 12			# Load 12 into $a1
		syscall 					

		la $a0, userInput		# Load userInput address into $a0
		li $s1, 0			# Load 0 into $s1

	loop_string:				# Examine validity of each character
		lb $t1, 0($a0)			# Load byte at userInput address into $t1
		bltu $t1, 0x30, wrong		# Wrong if less than 0
		bgt $t1, 0x7A, wrong		# Wrong if greater than z
		bge $t1, 0x61, calculate	# Calculate if a:z
		bgt $t1, 0x5A, wrong		# Wrong if greater than Z
        	bge $t1, 0x41, calculate	# Calculate if A:Z
		bgt $t1, 0x39, wrong		# Wrong if greater than 9
        	bge $t1, 0x30, calculate	# Calculate if 0:9		
		b calculate			# Unconditionally branch to calculate

	wrong:                          	# Branched to if character does not meet alphanumeric criteria
    		addi $s1, $s1, 1		# Add 1 to $s1
		addi $a0, $a0, 1		# Add 1 to $a0
		blt $s1, 10, loop_string	# Only branch back to loop_string if $s1 is still less than 10
    		b done				# Unconditionally branch to done

	calculate:				# Branched to if character does meet criteria / N = 26 + (03015593 % 11) = 36, z = 35
		beq $t1, 0x7A, z_N		# Branch to z_N if $t1 equals lowercase z
		beq $t1, 0x5A, Z_N		# Branch to Z_N if $t1 equals uppercase Z
    		bge $t1, 0x61, a_z		# Branch to a_z if $t1 is greater than or equal to lowercase a
		bge $t1, 0x41, A_Z		# Branch to A_Z if $t1 is greater than or equal to uppercase A
        	addi $s2, $t1, -48		# Load sum of $t1 and -48 into $s2
        	b cal				# Unconditionally branch to cal
	z_N:
		li $s2, 35			# Load 35 into $s2
        	b cal
	Z_N:
        	li $s2, 35			# Load 35 into $s2
        	b cal
	a_z:
        	addi $s2, $t1, -87		# Load sum of $t1 and -87 into $s2
        	b cal
	A_Z:
        	addi $s2, $t1, -55		# Load sum of $t1 and -55 into $s2
        	b cal
	cal:	
		add $s0, $s2, $s0		# Add $s2 to $s0
		addi $s1, $s1, 1		# Add 1 to $s1
		addi $a0, $a0, 1		# Add 1 to $a0
		blt $s1, 10, loop_string	# Only branch back to loop_string if $s1 is still less than 10
        	b done

    	done:
		li $v0, 1			# 1 = code to print integer
		move $a0, $s0 			# Move contents of $s0 to $a0
		syscall

	li $v0, 10				# 10 = code to exit
	syscall
