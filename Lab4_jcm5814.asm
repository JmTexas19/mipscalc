#Julian Marin
#September 23, 2018
#MIPS CALCULATOR

.data
	#Variables
	input1:			.word 0
	input2:			.word 0
	result:			.word 0
	operator:		.word 0
	remainder:		.word 0
	
	#Strings
	inputString1:		.asciiz "omae wa mou shinderu:\n"
	inputString2:		.asciiz "Enter second value:\n"
	inputOperatorStr:	.asciiz "Enter operator:\n"
	invalidOperatorStr:	.asciiz	"Invalid operator entered, please try again...\n"
	divisionByZeroStr:	.asciiz "Can't divide by 0, please try again...\n"
	divisionByNegStr:	.asciiz "Negaive #'s not supported, please try again...\n"
	remainderString:	.asciiz "Remainder: "
.text
#MAIN
main:
	#GETINPUT1
	la		$a0, inputString1		#Load pointer inputString1 into $a0
	la		$a1, input1			#Load pointer input1 into $a1
	jal 		getInput			#Jump to procedure printInputStr1
	
	#GET OPERATOR
	la		$a0, inputOperatorStr		#Load pointer inputOperatorStr into $a
	la		$a1, operator			#Load pointer operator into $a1
	jal		getOperator
	
	#PRINT NEWLINE
	li		$v0, 11				#Load print character syscall
	addi		$a0, $0, 0xA			#Load ascii character for newline into $a0
	syscall						#Execute
	
	#GETINPUT2
	la		$a0, inputString2		#Load pointer inputString2 into $a0
	la		$a1, input2			#Load pointer input2 into $a1
	jal 		getInput			#Jump to procedure printInputStr1

	#OPERATOR BRANCH
	beq		$v1, 43, addNumbJump		#Branch if $v1 is a '+' operator
	beq		$v1, 45, subNumbJump		#Branch if $v1 is a '-' operator
	beq		$v1, 42, multNumbJump		#Branch if $v1 is a '*' operator
	beq		$v1, 47, divNumbJump		#Branch if $v1 is a '/' operator

	#INVALID OPERATOR 
	li		$v0, 4				#Load print string syscall
	la		$a0, invalidOperatorStr		#Load address for invalid operator string
	syscall						#Execute
	j		main				#Loop to start of program
	
	#Jump and link to addNumb (This is done so that we can return and continue from the procedures since branch doesn't link.)
	addNumbJump:
	la		$a0, input1			#Load address of input1 into $a0
	la		$a1, input2			#Load address of input2 into $a1
	la		$a2, result			#Load address of result into $a2
	jal		addNumb				#Jump and link to addNumb
	j 		continue			#Jump to continue program
	
	#Jump and link to subNumb
	subNumbJump:
	la		$a0, input1			#Load address of input1 into $a0
	la		$a1, input2			#Load address of input2 into $a1
	la		$a2, result			#Load address of result into $a2
	jal		subNumb				#Jump and link to subNumb
	j 		continue			#Jump to continue program
	
	#Jump and link to multNumb
	multNumbJump:
	la		$a0, input1			#Load address of input1 into $a0
	la		$a1, input2			#Load address of input2 into $a1
	la		$a2, result			#Load address of result into $a2
	jal		multNumb			#Jump and link to multNumb
	j 		continue			#Jump to continue program
	
	#Jump and link to divNumb
	divNumbJump:
	la		$a0, input1			#Load address of input1 into $a0
	la		$a1, input2			#Load address of input2 into $a1
	la		$a2, result			#Load address of result into $a2
	la		$a3, remainder 			#Load address of result into $a3
	jal		divNumb				#Jump and link to divNumb
	j 		continue			#Jump to continue program
	
	#Continue after operation is done
	continue:
	
	#DISPLAY RESULT
	la		$a0, input1			#Load address of input1 into $a0
	la		$a1, input2			#Load address of input2 into $a1
	la		$a2, operator			#Load address of operator into $a2
	la		$a3, result			#Load address of result into $a3

	jal		displayNumb			#Jump and link to displayNumb
	
	#DISPLAY REMAINDER IF NECESSARY
	lw		$t0, operator			#Load operator value into $t0
	bne   		$t0, 47, skipRemainder		#Branch if division operator was used
	
	#PRINT REMAINDER
	la		$a0, remainderString		#Load value of remainder into $a0
	li		$v0, 4				#Load print character syscall
	syscall		
	
	lw		$a0, remainder			#Load value of remainder into $a0
	li		$v0, 1				#Load print character syscall
	syscall						#Execute
	
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
	sw		$0, operator			#Clear operator
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
#The user�fs input will get stored to the (word) address pointed by $a1
#Input: $a0 points to the text string that will get displayed to the user
#Input: $a1 points to a word address in .data memory, where to store the input number
getInput:
	#PRINT STRING
	li		$v0, 4				#Load print string syscall
	syscall						#Execute
	
	#READ INPUT
	li		$v0, 5				#Load read integer syscall
	syscall						#Execute
	sw		$v0, ($a1)			#Store value at address $a1 into label
	
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
	sw		$v1, ($a1)			#Store asciiz number into label
	
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
	lw		$t1, ($a0)			#Load word of address $a0 into $t0
	lw		$t0, ($a1)			#Load word of address $a1 into $t1
	li		$t2, 0				#Running quotient
	
	#CHECK IF DIVISION BY 0
	beqz 		$t1, divisionByZero 		#Jump if 0
	
	#CHECK IF DIVISION BY NEGATIVE
	bltz   		$t0, divisionByNeg 		#Jump if negative
	bltz   		$t1, divisionByNeg 		#Jump if negative

	#CHECK IF DIVIDEND IS GREATER THAN DIVISOR
	loopDiv:
		bgt     $t0, $t1, beginDivision		#Branch if dividend is greater than divisor
		bne  	$t0, $t1, Finish		#Branch if dividend is equal to divisor
		sub	$t0, $t1, $t0			#Subtract Dividend and Divisor = 0
		addi	$t2, $t2, 1			#Add 1 due to dividend and divisors being equal
		
	Finish:			
		sw	$t0, ($a3)			#Store remainder into label	
		sw	$t2, ($a2)			#Store result into label
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
#Input: $a0 points to a word address in .data memory, where the input value is stored
#Input: $a1 points to a word address in .data memory, where the input value is stored
#Input: $a2 points to the text string that will get displayed to the user
displayNumb:
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
	
	
	
	
	
