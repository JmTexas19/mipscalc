#Julian Marin
#September 23, 2018
#MIPS CALCULATOR

.data
	#Variables
	input1:			.word 0
	input2:			.word 0
	output:			.word 0
	
	#Strings
	inputString1:		.asciiz 		"Enter first value:"
	inputString2:		.asciiz 		"Enter second value"
	inputOperator:		.asciiz 		"Enter operator"
.text
	#MAIN
	
	#Print String 1
	la		$a0, inputString1		#Load pointer inputString1 into $a0
	jal 		printInputStr1			#Jump to procedure printInputStr1
	
	#Exit
	li		$v0, 17				#Load print string syscall
	syscall						#Execute
	
printInputStr1:
	li		$v0, 4				#Load print string syscall
	syscall						#Execute
	jr		$ra				#Return to main

	
