
#How this program works:
#we input 2 integers from user, n1 and n2,  in the "Run I/O"  window.
#then we print the result n1*n2 

#NOTE: This code ONLY works if n2>=0!
#If you input n2<0, you will always get 0 output!

#You can tinker with this script to better understand the ins and outs of RISCV assembly
#But do so ONLY after having fully understood how this code works!!!

#we are going to use macros to tidy up our code
#For full reference on using macros go to:
##Help -> Help -> RISCV -> Macros
#Ignore any references to the term "SPIM"
#Do not need to read from the section "Macro source line numbers" onwards

.macro exit #macro to exit program
		li a7, 10
		ecall
		.end_macro	

.macro print_str(%string1) #macro to print any string
	li a7,4 
	la a0, %string1
	ecall
	.end_macro
	
.macro print_int (%x)  #macro to print any integer or register
	li a7, 1
	add a0, zero, %x
	#zero here refers to register #0
	#the zero register always has constant value of 0
	ecall
	.end_macro
	

#later on, when we use functions in code, be VERY careful when creating macros!
#Macros might unintentionally change register values that can cause runtime errors
#as your code becomes dense, it becomes difficult to track the changing register values

.data 				
#we are now in the data section of memory.

	prompt1: .asciz  "Enter first number n1 :"
	prompt2: .asciz  "Enter second number n2 :"
	outputMsg: .asciz  " (n1) multiplied with "
	outputMsg2: .asciz  " (n2) gives the result "
	newline: .asciz  "\n"  #this prints a newline
	#In case you might want to print one
	#we dont use it in this program

#-------End of .data section!---------

.text 				
#we are now in the section devoted to storing the actual lines of code in our program.


main: # Label to define the main program.

	#print prompt1 string on console
	print_str(prompt1)

#reading integer n1
	li a7, 5
	ecall 		
	#a0 now contains user input n1
	
#set t0->n1
	addi t0, a0, 0

	#print prompt2 string on console
	print_str(prompt2)
	
#reading integer n2
	li a7, 5
	ecall 		
	#a0 now contains user input n2
	
#set t1->n2
	addi t1, a0, 0

#set up initial loop values

	li t2, 0
	#t2 will be loop counter i
	#will iterate from i=0 to n2-1
	
	li t3, 0
	#for each ith iteration, t3=t3+n1
	
loop_body:
	bge t2, t1, loop_exit
	#execute loop body only if i<n2
	#else exit loop
	
#begin loop body
	add t3, t3, t0
	#t3=t3+n1
loop_update:
	addi t2, t2, 1
	#i=i+1
	b loop_body
	
loop_exit:
	#done with loop. Phew!
	
#n1*n2 is now in t3 register

#let's print the resut
print_int(t0)#n1
print_str(outputMsg)
print_int(t1)#n2
print_str(outputMsg2)
print_int(t3)#n1*n2

exit

#-------End of .text section!---------

#Now that you have read the code, assemble the code!
#Click Assemble (Wrench and screwdiver icon)
#If teh Run Buttom becomes green , assembly is successful
#Click on the Run button
#Voila, you have multiplied 2 input integers!



