
#How this program works:
#we input 2 integers from user, n1 and n2,  in the "Run I/O"  window.
#then we print the result n1+n2 

#You can tinker with this script to better understand the ins and outs of RISCV assembly
#But do so ONLY after having fully understood how this code works!!!

.data 				
#we are now in the data section of memory.

	prompt1: .asciz  "Enter first number n1 :"
	prompt2: .asciz  "Enter second number n2 :"
	outputMsg: .asciz  " (n1) added to "
	outputMsg2: .asciz  " (n2) gives the result "
	newline: .asciz  "\n"  #this prints a newline
	#In case you might want to print one
	#we dont use it in this program

#-------End of .data section!---------

.text 				
#we are now in the section devoted to storing the actual lines of code in our program.


main: 				# Label to define the main program.

	#print prompt1 string on console
	li a7,4 
	la a0, prompt1
	ecall
	
#To learn the full scope of ecalls, visit
#https://github.com/TheThirdOne/rars/wiki/Environment-Calls

#as per the above site, to read an integer , we need to set a7=5
	li a7, 5
	ecall 		
	#a0 now contains user input n1
	
#before we might overwrite a0 , lets preserve n1 value in another register

	addi t0, a0, 0
	#t0 = a0 + 0
	#a0 copied to t0

	#print prompt2 string on console
	li a7,4 
	la a0, prompt2
	ecall
	
#reading integer n2
	li a7, 5
	ecall 		
	#a0 now contains user input n2
	
#put n2 value in t1 register
	addi t1, a0, 0

#add n1 and n2 and put result in t2
	add t2, t0, t1
	
#now we need to display the sentence:
#" n1 added to n2  gives the result (n1+n2)"
#so let's get to it!
	
#output n1 value
#https://github.com/TheThirdOne/rars/wiki/Environment-Calls	
#as per the above site, to out an integer , we need to set a7=1
	li a7, 1
	addi a0, t0,0
	ecall
	
# output outputMsg string
	li a7, 4 
	la a0, outputMsg
	ecall
	
#output n2 value
	li a7, 1
	addi a0, t1,0
	ecall
	
# output outputMsg2 string
	li a7, 4 
	la a0, outputMsg2
	ecall
	
#output n1+n2 value
	li a7, 1
	addi a0, t2,0
	ecall

Exit:	li a7, 10 	
	ecall 		

#-------End of .text section!---------

#For the list of available instructions, go to: 
#Help -> Help -> RISCV -> Basic Instructions
#Help -> Help -> RISCV -> Extended (pseudo) Instructions

#Now that you have read the code, assemble the code!
#Click Assemble (Wrench and screwdiver icon)
#If teh Run Buttom becomes green , assembly is successful
#Click on the Run button
#Voila, you have added 2 input integers!



