#Julian Marin
#September 23, 2018
#MIPS CALCULATOR

.data
	#Variables
	input1:			.word 0
	input2:			.word 0
	output:			.word 0
	
	#Strings
	inputString1:		.asciiz 		"Enter first value:\n"
	inputString2:		.asciiz 		"Enter second value:\n"
	inputOperator:		.asciiz 		"Enter operator:\n"
.text
#MAIN
main:
	#GETINPUT
	la		$a0, inputString1		#Load pointer inputString1 into $a0
	la		$a1, input1			#Load pointer input1 into $a1
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
	li		$v0, 5				#Load get integer syscall
	syscall						#Execute
	sw		$v0, 0($a1)			#Store input in label input1
	
	jr		$ra				#Return to main

	
