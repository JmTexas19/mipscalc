#Julian Marin
#September 23, 2018
#MIPS CALCULATOR

.data
	#Variables
	input1:			.word 
	input2:			.word 
	output:			.word 
	
	#Strings
	inputString1:		.asciiz 		"Enter first value:\n"
	inputString2:		.asciiz 		"Enter second value:\n"
	inputOperatorStr:	.asciiz 		"Enter operator:\n"
.text
#MAIN
main:
	#GETINPUT1
	la		$a0, inputString1		#Load pointer inputString1 into $a0
	la		$a1, input1			#Load pointer input1 into $a1
	jal 		getInput			#Jump to procedure printInputStr1
	
	#GET OPERATOR
	la		$a0, inputOperatorStr		#Load pointer inputOperatorStr into $a0
	la		$a1, inputOperatorStr		#Load pointer operator into $a1
	jal		getOperator
	
	#FORMATTING NEWLINE
	li		$v0, 11				#Load print character syscall
	addi		$a0, $0, 0xA			#Load ascii character for newline into $a0
	syscall						#Execute
	
	#GETINPUT2
	la		$a0, inputString2		#Load pointer inputString1 into $a0
	la		$a1, input2			#Load pointer input1 into $a1
	jal 		getInput			#Jump to procedure printInputStr1
	
	#EXIT
	li		$v0, 17				#Load exit syscall
	syscall						#Execute
	
#Prints inputString1 and reads input from user
getInput:
	#PRINT STRING
	li		$v0, 4				#Load print string syscall
	syscall						#Execute
	
	#READ INPUT
	li		$v0, 5				#Load read integer syscall
	syscall						#Execute
	sw		$v0, 0($a1)			#Store input in label input1
	
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
	
	jr		$ra				#Return to main

	
