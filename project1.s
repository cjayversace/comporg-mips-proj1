# PROGRAM: CSCI 201 MIPS Programming Project 1

.data
	message_in: .asciiz "Input: "		# Input message
	message_out: .asciiz "Output: "		# Output message
	userInput: .space 12			# Set input character limit

.text
	main:					# Start of code section
        	li $v0, 4			# 4 = code to print string
        	la $a0, message_in		# Load address of input message to print
        	syscall				# Register $v0 contains number code of the system call
        
		li $v0, 8			# 8 = code to read string
		la $a0, userInput		# Get text from input
		li $a1, 12			# Load 12 into $a1
		syscall 					

		la $a0, userInput		# Load userInput address into $a0
		li $s1, 0			# Load 0 into $s1

	loop_string:				# Examine validity of each character
		lb $t1, 0($a0)			# Load byte at userInput address into $t1
		bltu $t1, 0x30, wrong		# Wrong if less than 0
		bgt $t1, 0x78, wrong		# Wrong if greater than x
		bge $t1, 0x61, calculate	# Calculate if a:x
		bgt $t1, 0x58, wrong		# Wrong if greater than X
        	bge $t1, 0x41, calculate	# Calculate if A:X
		bgt $t1, 0x39, wrong		# Wrong if greater than 9
        	bge $t1, 0x30, calculate	# Calculate if 0:9		
		b calculate			# Unconditionally branch to calculate

	wrong:                          	# Branched to if character does not meet alphanumeric criteria
    		addi $s1, $s1, 1		# Add 1 to $s1
		addi $a0, $a0, 1		# Add 1 to $a0
		blt $s1, 10, loop_string	# Only branch back to loop_string if $s1 is still less than 10
    		b done				# Unconditionally branch to done

	calculate:				# Branched to if character does meet criteria / N = 26 + (13015593 % 11) = 34, x = 33
		beq $t1, 0x78, x_N		# Branch to x_N if $t1 equals lowercase x
		beq $t1, 0x58, x_N		# Branch to X_N if $t1 equals uppercase X
    		bge $t1, 0x61, a_x		# Branch to a_x if $t1 is greater than or equal to lowercase a
		bge $t1, 0x41, A_X		# Branch to A_X if $t1 is greater than or equal to uppercase A
        	addi $s2, $t1, -48		# Load sum of $t1 and -48 into $s2
        	b cal				# Unconditionally branch to cal
	x_N:
		li $s2, 33			# Load 35 into $s2
        	b cal
	X_N:
        	li $s2, 33			# Load 35 into $s2
        	b cal
	a_x:
        	addi $s2, $t1, -85		# Load sum of $t1 and -85 into $s2
        	b cal
	A_X:
        	addi $s2, $t1, -53		# Load sum of $t1 and -53 into $s2
        	b cal
	cal:	
		add $s0, $s2, $s0		# Add $s2 to $s0
		addi $s1, $s1, 1		# Add 1 to $s1
		addi $a0, $a0, 1		# Add 1 to $a0
		blt $s1, 10, loop_string	# Only branch back to loop_string if $s1 is still less than 10
        	b done

    	done:
        	li $v0, 4			# 4 = code to print string
        	la $a0, message_out		# Load address of output message to print
        	syscall

		li $v0, 1			# 1 = code to print integer
		move $a0, $s0 			# Move contents of $s0 to $a0
		syscall

	li $v0, 10				# 10 = code to exit
	syscall