#Julian Marin
#September 23, 2018
#MIPS CALCULATOR

.data
	#Variables
	input1:			.word 0
	input2:			.word 0
	result:			.word 0
	operator:		.word 0
	
	#Strings
	inputString1:		.asciiz "Enter first value:\n"
	inputString2:		.asciiz "Enter second value:\n"
	inputOperatorStr:	.asciiz "Enter operator:\n"
	invalidOperatorStr:	.asciiz	"Invalid operator entered, please try again...\n"
.text
#MAIN
main:
	#GETINPUT1
	la		$a0, inputString1		#Load pointer inputString1 into $a0
	la		$a1, input1			#Load pointer input1 into $a1
	jal 		getInput			#Jump to procedure printInputStr1
	
	#GET OPERATOR
	la		$a0, inputOperatorStr		#Load pointer inputOperatorStr into $a0
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
	li		$v0, 4				#Load exit syscall
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
	
	#EXIT
	li		$v0, 17
	syscall
	
#Prints inputString1 and reads input from user
getInput:
	#PRINT STRING
	li		$v0, 4				#Load print string syscall
	syscall						#Execute
	
	#READ INPUT
	li		$v0, 5				#Load read integer syscall
	syscall						#Execute
	sw		$v0, ($a1)			#Store value at address $a1 into label
	
	jr		$ra				#Return to main

#Prints inputOperatorStr and reads character for operations
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
	
#Adds 2 inputs
addNumb:
	#LOAD WORDS
	lw		$t0, ($a0)			#Load word of address $a0 into $t0
	lw		$t1, ($a1)			#Load word of address $a1 into $t1
		
	#ADD INPUTS
	add		$t2, $t0, $t1			#Add two inputs together
	sw		$t2, ($a2)			#Store in pointer of $a2
	
	jr		$ra				#Return to main
	
#Subtracts 2 inputs
subNumb:
	#LOAD WORDS
	lw		$t0, ($a0)			#Load word of address $a0 into $t0
	lw		$t1, ($a1)			#Load word of address $a1 into $t1
		
	#SUBTRACT INPUTS
	sub		$t2, $t0, $t1			#Add two inputs together
	sw		$t2, ($a2)			#Store in pointer of $a2

	jr		$ra				#Return to main
	
#Multiplies 2 inputs
multNumb:

	jr		$ra				#Return to main
	
#Divides 2 inputs
divNumb:

	jr		$ra				#Return to main
	
#Displays result of operation
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
	syscall	
	
	jr		$ra				#Return to main
	
	
	
	
	
	
