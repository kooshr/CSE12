.macro exit #macro to exit program
	li a7, 10
	ecall
	.end_macro	

.macro print_str(%string1) #macro to print any string
	li a7,4 
	la a0, %string1
	ecall
	.end_macro
	
.macro 	file_open_for_write(%str)
	la a0, %str
	li a1, 1
	li a7, 1024
	ecall
.end_macro

.macro 	file_open_for_read(%str)
	la a0, %str
	li a1, 0
	li a7, 1024
	ecall
.end_macro
	


.macro fileRead(%file_descriptor_register, %file_buffer_address_register)
#macro reads upto first 10,000 characters from file
	addi a0, %file_descriptor_register, 0
	addi a1, %file_buffer_address_register, 0
	li a2, 10000
	li a7, 63
	ecall
.end_macro 

.macro fileWrite(%file_descriptor_register, %file_buffer_address_register,%fileDataLength_register)
#macro writes contents of file buffer to file
	addi a0, %file_descriptor_register, 0
	addi a1, %file_buffer_address_register, 0
	li a7, 64
	addi a2, %fileDataLength_register, 0
	#a2 now contains total number of bytes writtent to buffer
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

.macro read_n(%x)#macro to input integer n into register x
	li a7, 5
	ecall 		
	#a0 now contains user input
	addi %x, a0, 0
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

.data 
	prompt: .asciz "Enter a number n > 0 (Make sure to do this correctly since >0 is not being checked in source code!"
	newline: .asciz "\n"
	filename: .asciz "patternDisplay.txt"
	star: .asciz "*"
	blackspace: .asciz " "
	outputMsg: .asciz  " display pattern saved to patternDisplay.txt "
	
.text
	
	file_open_for_write(filename)
	#a0 now contaimns the file descriptor (i.e. ID no.)
	#save to t6 register
	addi t6, a0, 0
	#it is recommended you do not use t6 anywhere else in your source code
	
	initialise_buffer_counter
	
	print_str(prompt)
	print_str(newline)
	read_n(t0)
	
	#t0 now contains the value n 
	
	li t1, 0
	li t2, 0
	j checkLoop
	
LoopBody:
	print_str(star)
	#display '*' on screen
	print_str(blackspace)
	#display ' ' on screen
	
	#now print these above characters to file bu
	write_to_buffer(0x2a)
	#0x2a is hex asci code for '*'
	addi t2, t2, 1
	write_to_buffer(0x20)
	#0x2a is hex asci code for ' '
	addi t2, t2, 1
	
	#FYI, the hex aci code for newline is 0x0a
	
	#update t1
	addi t1, t1, 1
	
checkLoop:
	blt t1, t0, LoopBody
	
	#exit loop
	
	#write null character to end of file
	write_to_buffer(0x00)
	
	#write file buffer to file
	li t0, 0x10040008
	fileWrite(t6, t0,t2)
	#t2 currently contains the length of the file data 
	
	print_str(outputMsg)
	
	exit
	
	
	
