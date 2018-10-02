#Julian Marin
#September 23, 2018
#MIPS CALCULATOR

.data
	#Variables
	buffer1:		.byte 0:80
	buffer2:		.byte 0:80
	input1:			.word 0
	input2:			.word 0
	result:			.word 0
	remainder:		.word 0
	
	#Strings
	inputString1:		.asciiz "Enter first value:\n"
	inputString2:		.asciiz "Enter second value:\n"
	inputOperatorStr:	.asciiz "Enter operator:\n"
	invalidOperatorStr:	.asciiz	"Invalid operator entered, please try again...\n"
	divisionByZeroStr:	.asciiz "Can't divide by 0, please try again...\n"
	divisionByNegStr:	.asciiz "Negaive #'s not supported, please try again...\n"
	remainderString:	.asciiz "Remainder: "
	resultString:		.asciiz "Result: "
.text
#MAIN
main:
	#GETINPUT1
	la		$a0, inputString1		#Load pointer inputString1 into $a0
	la		$a1, buffer1			#Load pointer input1 into $a1
	jal 		getInput			#Jump to procedure printInputStr1
	
	#PARSEINPUT1
	la		$a0, buffer1			#Load pointer inputString1 into $a0
	la		$a1, input1			#Load pointer input1 into $a1
	jal 		parseString			#Jump to procedure printInputStr1	
	
	#GET OPERATOR
	la		$a0, inputOperatorStr		#Load pointer inputOperatorStr into $a0
	move		$a1, $s0			#Load pointer operator into $a1
	jal		getOperator
	
	#PRINT NEWLINE
	li		$v0, 11				#Load print character syscall
	addi		$a0, $0, 0xA			#Load ascii character for newline into $a0
	syscall						#Execute
	
	#GETINPUT2
	la		$a0, inputString2		#Load pointer inputString2 into $a0
	la		$a1, buffer2			#Load pointer input2 into $a1
	jal 		getInput			#Jump to procedure printInputStr1
	
	#PARSEINPUT2
	la		$a0, buffer2			#Load pointer inputString1 into $a0
	la		$a1, input2			#Load pointer input1 into $a1
	jal 		parseString			#Jump to procedure printInputStr1
	
	#LOAD ARGUMENTS AND RETURN REGISTER
	la		$a0, input1			#Load address of input1 into $a0
	la		$a1, input2			#Load address of input2 into $a1
	la		$a2, result			#Load address of result into $a2
	la		$a3, remainder 			#Load address of result into $a3
	la		$ra, continue			#Make return register return to continue label

	#OPERATOR BRANCH
	beq		$v1, 43, addNumb		#Branch if $v1 is a '+' operator
	beq		$v1, 45, subNumb		#Branch if $v1 is a '-' operator
	beq		$v1, 42, multNumb		#Branch if $v1 is a '*' operator
	beq		$v1, 47, divNumb		#Branch if $v1 is a '/' operator

	#INVALID OPERATOR 
	li		$v0, 4				#Load print string syscall
	la		$a0, invalidOperatorStr		#Load address for invalid operator string
	syscall						#Execute
	j		main				#Loop to start of program
	
	#CONTINUE
	continue:
	
	#DISPLAY RESULT
	la		$a0, resultString		#Load address of resultString into $a0
	la		$a1, result			#Load address of result into $a1
	la		$a2, remainder			#Load address of remainder into $a2
	jal		displayNumb			#Jump and link to displayNumb
	
	#DISPLAY EQUATION
#	la		$a0, input1			#Load address of input1 into $a0
#	la		$a1, input2			#Load address of input2 into $a1
#	move		$a2, $s0			#Load address of operator into $a2
#	la		$a3, result			#Load address of result into $a3
#
#	jal		displayEquation			#Jump and link to displayNumb
	
	#DISPLAY REMAINDER IF NECESSARY
	move		$t0, $s0			#Load operator value into $t0
	bne   		$t0, 47, skipRemainder		#Branch if division operator was used
	
	#If not division, remainder is skipped
	skipRemainder:
	
	#PRINT NEWLINE
	li		$v0, 11				#Load print character syscall
	addi		$a0, $0, 0xA			#Load ascii character for newline into $a0
	syscall	
	
	#CLEAR LABELS
	sw		$0, input1			#Clear input1
	sw		$0, input2			#Clear input2
	sw		$0, result			#Clear result
	move		$0, $s0				#Clear operator
	sw		$0, remainder			#Clear remainder
	
	#LOOP
	j		main				#Loop to beginning of program
	
	#DIVISION BY ZERO
	divisionByZero:
	li		$v0, 4				#Load print string syscall
	la		$a0, divisionByZeroStr		#Load in divisionByZero string
	syscall						#Execute
	j		main				#Loop Program
	
	#DIVISION BY NEGATIVE
	divisionByNeg:
	li		$v0, 4				#Load print string syscall
	la		$a0, divisionByNegStr		#Load in divisionByNegStr string
	syscall						#Execute
	j		main				#Loop Program
	
#Procedure:  GetInput
#Displays a prompt to the user and then wait for a numerical input
#The users input will get stored to the (word) address pointed by $a1
#Input: $a0 points to the text string that will get displayed to the user
#Input: $a1 points to a word address in .data memory, where to store the input number
getInput:
	#PRINT STRING
	li		$v0, 4				#Load print string syscall
	syscall						#Execute
	
	#READ INPUT
	li		$v0, 8				#Load read string input
	la		$a0, ($a1)			#Load address of buffer
	li		$a1, 80				#80 bytes of space
	syscall						#Execute
	
	jr		$ra				#Return to main

#Procedure:  GetOperator
#Displays a prompt to the user and then wait for a single character input
#Input: $a0 points to the text string that will get displayed to the user
#Returns the operator in $v1 (as an ascii character)
getOperator:
	#PRINT STRING
	li		$v0, 4				#Load print string syscall
	syscall						#Execute
	
	#READ INPUT
	li		$v0, 12				#Load read character syscall
	syscall						#Execute
	move		$v1, $v0			#Return operator character in $v1
	move		$s0, $v1			#Store asciiz number into label
	
	jr		$ra				#Return to main
	
#Procedure:  AddNumb   0($a2) = 0($a0) + 0($a1)
#Add two data values and store the result back to memory
#Input: $a0 points to a word address in .data memory for the first data value
#Input: $a1 points to a word address in .data memory for the second data value
#Input: $a2 points to a word address in .data memory, where to store the result
addNumb:
	#LOAD WORDS
	lw		$t0, ($a0)			#Load word of address $a0 into $t0
	lw		$t1, ($a1)			#Load word of address $a1 into $t1
	lw		$t2, ($a2)			#Load word of address $a2 into $t2
		
	#ADD INPUTS
	add		$t2, $t0, $t1			#Add two inputs together
	sw		$t2, ($a2)			#Store in pointer of $a2
	
	jr		$ra				#Return to main
	
#Procedure:  SubNumb   0($a2) = 0($a0) - 0($a1)
#Subtract two data values and store the result back to memory
#Input: $a0 points to a word address in .data memory for the first data value
#Input: $a1 points to a word address in .data memory for the second data value
#Input: $a2 points to a word address in .data memory, where to store the result
subNumb:
	#LOAD WORDS
	lw		$t0, ($a0)			#Load word of address $a0 into $t0
	lw		$t1, ($a1)			#Load word of address $a1 into $t1
	lw		$t2, ($a2)			#Load word of address $a1 into $t1
		
	#SUBTRACT INPUTS
	sub		$t2, $t0, $t1			#Add two inputs together
	sw		$t2, ($a2)			#Store in pointer of $a2

	jr		$ra				#Return to main
	
#Procedure:  MultNumb   0($a2) = 0($a0) * 0($a1)
#Multiply two data values and store the result back to memory
#Input: $a0 points to a word address in .data memory for the first data value
#Input: $a1 points to a word address in .data memory for the second data value
#Input: $a2 points to a word address in .data memory, where to store the result
multNumb:
	#LOAD WORDS
	lw		$t0, ($a0)			#Load word of address $a0 into $t0
	lw		$t1, ($a1)			#Load word of address $a1 into $t1
	lw		$t3, ($a2)			#Load word of address $a2 into $t3
	
	#CHECK BIT
	loopMult:
		andi	$t2, $t1, 1			#Check if bit is set; #t2 bit_check
		beqz	$t2, clearBitMult		#Branch if bit is set
		addu	$t3, $t3, $t0			#Add dec2 to result if bit is clear; #t3 result

	#MULTIPLY AND SHIFT
	clearBitMult:
		sll	$t0, $t0, 1			#Shift dec1 left one bit to multiply by power of 2
		srl	$t1, $t1, 1			#Shift dec2 right one bit to check next bit
		bnez	$t1, loopMult			#If dec2 is not equal to zero, loop again, otherwise done
		sw 	$t3, ($a2)			#Store result into label
		jr	$ra				#Return to main
	
#Procedure:  DivNumb   0($a2) = 0($a0) / 0($a1)   0($a3) = 0($a0) % 0($a1)
#Divide two data values and store the result back to memory
#Input: $a0 points to a word address in .data memory for the first data value
#Input: $a1 points to a word address in .data memory for the second data value
#Input: $a2 points to a word address in .data memory, where to store the quotient
#Input: $a3 points to a word address in .data memory, where to store the remainder
divNumb:
	#LOAD WORDS
	lw		$t0, ($a0)			#Load word of address $a0 into $t0
	lw		$t1, ($a1)			#Load word of address $a1 into $t1
	move		$t5, $0				#Remainder boolean
	mul		$t0, $t0, 100			#Multiply input1 by 100 to keep decimal
	li		$t2, 0				#Running quotient
	
	#CHECK IF DIVISION BY 0
	beqz 		$t1, divisionByZero 		#Jump if 0
	
	#CHECK IF DIVISION BY NEGATIVE
	bltz   		$t0, divisionByNeg 		#Jump if negative
	bltz   		$t1, divisionByNeg 		#Jump if negative

	#CHECK IF DIVIDEND IS GREATER THAN DIVISOR
	loopDiv:
		bgt     $t0, $t1, beginDivision		#Branch if dividend is greater than divisor
		bne  	$t0, $t1, finish		#Branch if dividend is equal to divisor
		sub	$t0, $t0, $t1			#Subtract Dividend and Divisor = 0
		addi	$t2, $t2, 1			#Add 1 due to dividend and divisors being equal
		
	finish:			
		#STORE RESULT
		beq	$t5, 1, skipStore		#If result is already stored, skip
		sw	$t2, ($a2)			#Store result into label
		lw	$t0, ($a0)			#Reset input 1
		lw	$t1, ($a1)			#Reset input 2
		addi	$t5, $t5, 1			#Set boolean
		j	beginDivision			#Loop again to get correct remainder
		
		#TRUE FINISH
		skipStore:
		sw	$t0, ($a3)			#Store remainder into label	
		jr	$ra				#Return to main

	#SHIFT UNTIL DIVISOR IS BIGGER THAN DIVIDEND
	beginDivision:
		li	$t4, 1				#Set temp quotient to 1
		move	$t3, $t1			#Copy divisor into temp divisor
		sll	$t3, $t3, 1			#Shift temp divisor left 1 before going into loop
		bgt 	$t0, $t3, divisionLoop		#Branch if dividend is greater than temp divisor
		j	contDiv				#Else jump to contDiv
		
	divisionLoop:
		sll	$t4, $t4, 1			#Shift left temp quotient by 1
		sll	$t3, $t3, 1			#Shift left temp divisor by 1
		bgt 	$t0, $t3, divisionLoop		#Shift until temp divisor is greater than dividend
	
	contDiv:
		add	$t2, $t2, $t4			#Set running quotient = running quotient + temp quotient
		srl	$t3, $t3, 1			#Undo temp divisors last shift
		sub	$t0, $t0, $t3 			#Set dividend = dividend - temp divisor
		j	loopDiv
		
#Procedure: DisplayNumb
#Displays a message to the user followed by a numerical value
#Input: $a0 points to the text string that will get displayed to the user
#Input: $a1 points to a word address in .data memory, where the input value is stored
#Input: $a2 points to a word address in .data memory, where the remainder value is stored
#VALUES: $t0 = result; $t1 = result_dollars; $t2 = result_dimes; $t3 = result_pennies; 
#VALUES: $t4 = remainder; $t5 = remainder_dollars; $t6 = remainder_dimes; $t7 = remainder_pennies
displayNumb:
	lw		$t0, ($a1)			#Load result
	lw		$t4, ($a2)			#Load remainder
	
	#PRINT STRING
	li		$v0, 4				#Load print string syscall
	syscall						#Execute
	
	#FIX DECIMAL FOR MULTIPLICATION
	bne		$s0, 42, skipToDiv		#Branch if $v1 is a '*' operator
	div		$t0, $t0, 100			#Adjust result for correct multiplication
	div		$t1, $t0, 100			#Divide result by 100 to get dollars
	rem		$t2, $t0, 100			#Modulo to get cents
	
	#FIX CENTS
	div		$t3, $t2, 10			#Get dimes by dividing cents by 10
	rem		$t4, $t2, 10			#Get pennies by dividing cents by 10
	j		printNumb			#Jump to printing
	
	#OR DIVISION
	skipToDiv:
	bne		$s0, 47, skipToAddSub		#Branch if $v1 is a '/' operator
	div		$t1, $t0, 100			#Divide result by 100 to get dollars
	rem		$t2, $t0, 100			#Modulo to get cents
	
	#FIX REMAINDER
	div		$t5, $t4, 100			#Fix remainder value get dollars
	rem		$t6, $t4, 100			#Modulo to get cents
	
	#FIX CENTS
	div		$t3, $t2, 10			#Get dimes by dividing cents by 10
	rem		$t4, $t2, 10			#Get pennies by dividing cents by 10
	rem		$t7, $t6, 10			#Get pennies by dividing cents by 10 for remainder
	div		$t6, $t6, 10			#Get dimes by dividing cents by 10 for remainder
	j		printNumb			#Jump to printing
	
	#GET DOLLARS AND CENTS
	skipToAddSub:					#Skip if not division
	div		$t1, $t0, 100			#Divide result by 100 to get dollars
	rem		$t2, $t0, 100			#Modulo to get cents
	div		$t3, $t2, 10			#Get dimes by dividing cents by 10
	rem		$t4, $t2, 10			#Get pennies by dividing cents by 10
	
	printNumb:
	#PRINT DOLLARS
	li		$v0, 1				#Load print integer syscall
	move		$a0, $t1			#Copy value of $t0 into $a0 for printing
	syscall						#Execute

	#PRINT DECIMAL
	li		$v0, 11				#Load print integer syscall
	addi		$a0, $0, 0x2E			#Copy ascii for decimal
	syscall						#Execute
	
	#FIX CENTS
	abs		$t3, $t3			#Make positive so negative sign isn't print
	abs		$t4, $t4			#Make positive so negative sign isn't print
	
	#PRINT DIMES
	li		$v0, 1				#Load print integer syscall
	move		$a0, $t3			#Copy value of $t3 into $a0 for printing
	syscall						#Execute
	
	#PRINT PENNIES
	li		$v0, 1				#Load print integer syscall
	move		$a0, $t4			#Copy value of $t4 into $a0 for printing
	syscall						#Execute
	
	#PRINT NEWLINE
	li		$v0, 11				#Load print character syscall
	addi		$a0, $0, 0xA			#Load ascii character for newline into $a0
	syscall						#Execute
	
	#PRINT REMAINDER
	#STRING
	bne 		$s0, 47, skipRemainder		#If not division skip remainder
	la		$a0, remainderString		#Load value of remainder into $a0
	li		$v0, 4				#Load print character syscall
	syscall						#Execute
	
	#PRINT DOLLARS
	li		$v0, 1				#Load print integer syscall
	move		$a0, $t5			#Copy value of $t0 into $a0 for printing
	syscall						#Execute
	
	#PRINT DECIMAL
	li		$v0, 11				#Load print integer syscall
	addi		$a0, $0, 0x2E			#Copy ascii for decimal
	syscall						#Execute
	
	#PRINT DIMES
	li		$v0, 1				#Load print integer syscall
	move		$a0, $t6			#Copy value of $t3 into $a0 for printing
	syscall						#Execute
	
	#PRINT PENNIES
	li		$v0, 1				#Load print integer syscall
	move		$a0, $t7			#Copy value of $t4 into $a0 for printing
	syscall						#Execute
	
	skipPrintRemainder:
	#PRINT NEWLINE
	li		$v0, 11				#Load print character syscall
	addi		$a0, $0, 0xA			#Load ascii character for newline into $a0
	syscall						#Execute
	
	jr		$ra				#Return to main

#Procedure: displayEquation
#Displays the equation of the user inputted values. ([input1] [operator] [input2] = [result]
#Input: $a0 points to a word address in .data memory, where the input1 value is store
#Input: $a1 points to a word address in .data memory, where the input2 value is store
#Input: $a2 points to a word address in .data memory, where the operator value is store
#Input: $a3 points to a word address in .data memory, where the result value is store
displayEquation:
	#LOAD WORDS
	lw		$t0, ($a0)			#Load input1 value into #t0
	lw		$t1, ($a1)			#Load input2 value into #t1
	lw		$t2, ($a2)			#Load operator asciiz value into #t2
	lw		$t3, ($a3)			#Load result value into #t3
	
	#PRINT INPUT1
	li		$v0, 1				#Load syscall for print integer
	move		$a0, $t0			#Copy input1 value into $a0 for printing
	syscall						#Print integer in $a0(input1)
	
	#PRINT SPACE
	li		$v0, 11				#Load syscall for print integer
	addi		$a0, $0, 0x20			#Load ascii for space into $a0
	syscall						#Execute
	
	#PRINT OPERATOR
	li		$v0, 11				#Load syscall for print integer
	add 		$a0, $0, $t2			#Load ascii for operator into $a0
	syscall						#Execute
	
	#PRINT SPACE
	li		$v0, 11				#Load syscall for print integer
	addi		$a0, $0, 0x20			#Load ascii for space into $a0
	syscall						#Execute
	
	#PRINT INPUT2
	li		$v0, 1				#Load syscall for print integer
	move		$a0, $t1			#Copy input2 value into $a0 for printing
	syscall						#Execute
	
	#PRINT SPACE
	li		$v0, 11				#Load syscall for print integer
	addi		$a0, $0, 0x20			#Load ascii for space into $a0
	syscall						#Execute
	
	#PRINT EQUAL SIGN
	li		$v0, 11				#Load syscall for print integer
	addi		$a0, $0, 0x3D			#Load ascii for space into $a0
	syscall						#Execute
	
	#PRINT SPACE
	li		$v0, 11				#Load syscall for print integer
	addi		$a0, $0, 0x20			#Load ascii for space into $a0
	syscall						#Execute
	
	#PRINT RESULT
	li		$v0, 1				#Load syscall for print integer
	move		$a0, $t3			#Copy input2 value into $a0 for printing
	syscall						#Execute
	
	#PRINT NEWLINE
	li		$v0, 11				#Load print character syscall
	addi		$a0, $0, 0xA			#Load ascii character for newline into $a0
	syscall						#Execute
	
	jr		$ra				#Return to main
	
#Procedure: parseString
#Parses the string passed in and converts/returns an integer.
#Input: $a0 points to a word address in .data memory, where the input1 value is stored
#Input: $a1 points to a word address in .data memory, where the input1 value is stored
parseString:
	addi		$t0, $0, 0			#Reset register
	addi		$t1, $0, 0			#Reset register
	addi		$t2, $0, 0			#Reset register
	addi		$t3, $0, 0			#Reset register
	
	#Parse each byte in the input
	parseLoop:
	lb		$t1, 0($a0)			#Load byte into $t1
	#CHECKS
	beqz		$t1, parseLoopBreak		#If byte is null, break
	beq		$t1, 0xA, parseLoopBreak	#If byte is equalt to cr, break
	beq		$t1, 0x2E, parseLoopBreak	#If byte is decimal break
	
	#[GOING TO NEED TO CHECK FOR ERROR HERE] TODO
	
	#CONVERT
	sub		$t3, $t1, 48			#Convert to binary 0-9
	mul		$t0, $t0, 10			#Multiply $t0 by 10
	add		$t0, $t0, $t3			#Add to dollars amount
	
	#INCREMENT
	lb		$t1, 0($a0)			#Load byte of input
	addiu		$a0, $a0, 1			#Next byte
	j		parseLoop			#Loop
	
	#DOLLARS HAVE BEEN PARSED
	parseLoopBreak:
	mul		$t0, $t0, 100			#Convert num to dollars
	
	#PARSE DECIMAL
	bne 		$t1, 0x2E, parseDone		#If last char not decimal... Done
	addiu		$a0, $a0, 1			#Next byte
	lb		$t1, 0($a0)			#Load byte of input
	sub		$t3, $t1, 48			#Convert to binary 0-9
	mul		$t3, $t3, 10			#Multiply $t0 by 10
	add		$t0, $t0, $t3			#Add to dollars amount
	
	#PENNIES
	addiu		$a0, $a0, 1			#Next byte
	lb		$t1, 0($a0)			#Load byte of input
	sub		$t3, $t1, 48			#Convert to binary 0-9
	bltz		$t3, parseDone			#If $t3 is less than 0 skip add
	add		$t0, $t0, $t3			#Add to dollars amount

	parseDone:
	sw		$t0, ($a1)			#Store word
	jr		$ra				#Return
	
	
