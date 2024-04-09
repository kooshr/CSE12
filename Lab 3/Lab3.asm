##########################################################################
# Created by: Ramesh, Kaushal
#	      ID# 193976
#             May 15th, 2023
#
# Assignment: Lab 3: RARS Introduction
#	      CSE 12, Computer Systems and Assembly Language
#             UC Santa Cruz, Fall 2022
# 
# Description: This program prints A "Right Triangle" in a pyramid shape using the ascii characters '*' '$' and '0'. 
#
# Notes: This program is intended to be run from the MARS IDE.
##########################################################################
#
#
# Python Code:
#
# user_in = int(input("Enter the height of the pattern (must be greater than 0):"))
# while(user_in <1):
#     print("Invalid Entry")
#     user_in = int(input("Enter the height of the pattern (must be greater than 0):"))
# for i in range(user_in):
#     for j in range(i):
#         print("$*",end='')
#     print("$0")
#
# Pseudocode:
#
# Print Statement
# Get User Input
# Validate User Input
# If Invalid loop back to top
# If Valid, continue
# Loop once through the user number
#   loop once more through the number we are at in the loop
#       print "$*"
#   print "$0"
#   print "new line" 
#
##########################################################################

.macro exit #macro to exit program
	li a7, 10
	ecall
	.end_macro	

.macro print_str(%string1) #macro to print any string
	li a7,4 
	la a0, %string1
	ecall
	.end_macro
	
	
.macro read_n(%x)#macro to input integer n into register x
	li a7, 5
	ecall 		
	#a0 now contains user input
	addi %x, a0, 0
	.end_macro
	
.macro print_n(%x)#macro to input integer n into register x
	addi a0,%x, 0
	li a7, 1
	ecall
.end_macro

.macro 	file_open_for_write_append(%str)
	la a0, %str
	li a1, 1
	li a7, 1024
	ecall
.end_macro
	
.macro  initialise_buffer_counter
	#buffer begins at location 0x10040000
	#location 0x10040000 to keep track of which address we store each character byte to 
	#actual buffer to store the characters begins at 0x10040008
	
	#initialize mem[0x10040000] to 0x10040008
	addi sp, sp, -16
	sd t0, 0(sp)
	sd t1, 8(sp)
	
	li t0, 0x10040000
	li t1, 0x10040008
	sd t1, 0(t0)
	
	ld t0, 0(sp)
	ld t1, 8(sp)
	addi sp, sp, 16
	.end_macro
	

.macro write_to_buffer(%char)
	#NOTE:this macro can add ONLY 1 character byte at a time to the file buffer!
	
	addi sp, sp, -16
	sd t0, 0(sp)
	sd t4, 8(sp)
	
	
	li t0, 0x10040000
	ld t4, 0(t0)#t4 is starting address
	#t4 now points to location where we store the current %char byte
	
	#store character to file buffer
	li t0, %char
	sb t0, 0(t4)
	
	#update address location for next character to be stored in file buffer
	li t0, 0x10040000
	addi t4, t4, 1
	sd t4, 0(t0)
	
	ld t0, 0(sp)
	ld t4, 8(sp)
	addi sp, sp, 16
	.end_macro

.macro fileRead(%file_descriptor_register, %file_buffer_address)
#macro reads upto first 10,000 characters from file
	addi a0, %file_descriptor_register, 0
	li a1, %file_buffer_address
	li a2, 10000
	li a7, 63
	ecall
.end_macro 

.macro fileWrite(%file_descriptor_register, %file_buffer_address,%file_buffer_address_pointer)
#macro writes contents of file buffer to file
	addi a0, %file_descriptor_register, 0
	li a1, %file_buffer_address
	li a7, 64
	
	#a2 needs to contains number of bytes sent to file
	li a2, %file_buffer_address_pointer
	ld a2, 0(a2)
	sub a2, a2, a1
	
	ecall
.end_macro 

.macro print_file_contents(%ptr_register)
	li a7, 4
	addi a0, %ptr_register, 0
	ecall
	#entire file content is essentially stored as a string
.end_macro
	


.macro close_file(%file_descriptor_register)
	li a7, 57
	addi a0, %file_descriptor_register, 0
	ecall
.end_macro

.data
	prompt: .asciz  "Enter the height of the pattern (must be greater than 0):"
	invalidMsg: .asciz  "Invalid Entry!"
	newLine: .asciz  "\n"
	star_dollar: .asciz  "*$"
	dollar: .asciz  "$"
	star: .asciz "*"
	blankspace: .asciz " "
	outputMsg: .asciz  " display pattern saved to lab3_output.txt "
	filename: .asciz "lab3_output.txt"
	Zero:.asciz"0"
	
.text
	file_open_for_write_append(filename)
	#a0 now contaimns the file descriptor (i.e. ID no.)
	#save to t6 register
	addi t6, a0, 0
	
	initialise_buffer_counter
	
	#for utilsing macro write_to_buffer, here are tips:
	#0x2a is the ASCI code input for star(*)
	#0x24 is the ASCI code input for dollar($)
	#0x30  is the ASCI code input for  the character '0'
	#0x0a  is the ASCI code input for  newLine (/n)

	
	#START WRITING YOUR CODE FROM THIS LINE ONWARDS
	#DO NOT  use the registers a0, a1, a7, t6, sp anywhere in your code.
	
	#................ your code starts here..........................................................#

# Register Usage:
# t0 used to read user input
# t1 used to keep track of incrementation in the first loop
# t2 is used to keep track of the buffer index of writing to a file
# t3 is used to keep track of the incrementation of the second loop


#Starting Loop for program. Used to validate user input
loop:

	print_str(prompt)	# Prompts user for input
	read_n(t0)		# Reads user input into register t0
	
	bltz t0 invalid		# If User input is invalid (t0 < 0) it jumpts to invalid
	beqz t0 invalid		# If User input is invalid (t0 = 0) it jumpts to invalid
	
	#Initializes Registers
	li t1, 0		# t1 is used as a counter for the first (outer) loop
	li t2, 0		# t2 is used to keep track of the buffer length to write to file
	li t3, 0		# t3 is used as a counter for the second (inner) loop
	
	j outerLoop		# jumps to the first (outer) loop to start the main body of the program


#Restarts loop if invalid input
invalid:

	print_str(invalidMsg)	# Prints the invalid Message prompt
	print_str(newLine)	# Prints a new Line
	j loop			# Jumps back to the top (loop) to reask the user for input


#Start of the outerloop of program
outerLoop:
	
	j checkinnerLoop	# Jumps to inner loop
	
#Checks to see if outer loop condiiton has been met
checkouterLoop:

	print_str(dollar)	# Prints '$' to Run I/O
	print_str(Zero)		# Prints '0' to Run I/O
	print_str(newLine)	# Prints new lines to Run I/O
	
	
	write_to_buffer(0x24)	# Adds the 0x24 ('$') character to the buffer
	addi t2, t2, 1		# Increments t2 to keep track of buffer length
	write_to_buffer(0x30)	# Adds the 0x30 ('0') character to the buffer
	addi t2, t2, 1		# Increments t2 to keep track of buffer length
	write_to_buffer(0x0a)	# Adds the 0x0a (new line) character to the buffer
	addi t2, t2, 1		# Increments t2 to keep track of buffer length
	
	
	addi t1, t1, 1		# Increments t1 to keep track of how many times looped for the first (outer) loop
	
	
	li t3, 0		# Reset t3, which keeps track of the inner loop
	
	
	blt t1, t0, outerLoop	#Checks to see if outer loop condition has been met, otherwise restarts loop (jumps to outerLoop)
	
	
	j Exit			#Finally, jump to Exit to exit program


#Inner loop of program
innerLoop:

	print_str(dollar)	# Prints '$' to Run I/O
	print_str(star)		# Prints '*' to Run I/O
	
	
	write_to_buffer(0x24)	# Adds the 0x24 ('$') character to the buffer
	addi t2, t2, 1		# Increments t2 to keep track of buffer length
	write_to_buffer(0x2a)	# Adds the 0x2a ('*') character to the buffer
	addi t2, t2, 1		# Increments t2 to keep track of buffer length
	
	
	addi t3, t3, 1		# Increments inner loop pointer by one to signify that it has been looped over
	
	blt t3, t1, innerLoop	# Jumps to checkinnerLoop to see if loop conditions have been satisfied
	
	
#Check to see if inner loop conditions have been meet
checkinnerLoop:

	blt t3, t1, innerLoop	# Checks to see if the first (outer) loop condition has been met, otherwise restarts loop (jumps to outerLoop)
	
	
	j checkouterLoop	# Jumps to checkouterloop once second (inner) loop has been satisfied
	
	

	#................ your code ends here..........................................................#
	
	#END YOUR CODE ABOVE THIS COMMENT
	#Don't change anything below this comment!
Exit:	
	#write null character to end of file
	write_to_buffer(0x00)
	
	#write file buffer to file
	fileWrite(t6, 0x10040008,0x10040000)
	addi t5, a0, 0
	
	print_str(newLine)
	print_str(outputMsg)
	
	exit
	
	
