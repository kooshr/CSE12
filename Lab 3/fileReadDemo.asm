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

.data
	fileText: .asciz  "Theze pretzels are making me thirsty!"
	insterNull: .asciz ""
	#The reasn for having insertNull is so that 
	filename: .asciz "fileDemo.txt"


.text

	file_open_for_read(filename)
	#a0 now contaimns the file descriptor (i.e. ID no.)
	#save to t6 register
	addi t6, a0, 0
	#it is recommended you do not use t6 anywhere else in your source code
	
	li t0, 0x10040000
	#let's store the file buffer content here
	
	#read file buffer from file
	fileRead(t6, t0)
	
	print_file_contents(t0)
	
	exit
	