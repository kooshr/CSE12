#You MUST open this file in RARS text editor window. Dont use Word or Notepad, etc.
#Else the different file sections wont be correctly color coded.

# Please study this code BEFORE assembling and running the code.

#as you might have guessed, we precede a line of text with a # for commenting.
#see how GREEN the lines now become!!
#Just like The Matrix(1999)

#How this program works:
#we just print "Hello World" in the "Run I/O" screen at the bottom.
#" Humble beginnings lead to great endeavors" - Unknown

#You can tinker with this script to better understand the ins and outs of RISCV assembly
#But do so ONLY after having fully understood how this code works!!!

# a typical RARS assembly code consists of .data and .text sections.
#in the RISC-V memory, we have two separtate memory areas devoted to static data and the actual program text 

#anything you type within .data section is "static" global data. 

# Any line within your code can access this global data defined under .data section.
# .data data remains unchanged during entire program run.

.data 				
#we are now in the data section of memory.

	greeting:  .asciz "Hello World" #strings appear in GREEN
	#also note how we tab out the text within the .data section.
	#this makes better readability and is encouraged.

#In python, we would have defined a string as:
# greeting =  "Hello World" 
#Here, we do the exact equivalent thing

#greeting in our code is what we call a LABEL. 
#See, in the RISC-V memory, this "Hello World" data item is placed in the section reserved for static data.
#as the RISCV coder, you dont have explicit access to this memory address so that you can use the string.
#Instead, you use a user given label which points to address of this string.
#So in your program, when you want to access the string "Hello World", you refer to label greeting

# the .asciz is what we call a DIRECTIVE.
#anything that you see becomes PURPLE color is a directive.
#so .data is also a directive. 
#The directive .asciz informs the RARS assembler that this given data ...
#... is meant to be a string in the computer memory.
#The z at the end of asciz implies that the assembler adds a null character to the end of the given string.
#True, we entered it as a string but how can the actual RISCV memory know? It just sees the data in 1s and 0s :( 

#for the full list of directives, go to:
#Help -> Help -> RISCV -> Directives

#-------End of .data section!---------

.text 				
#we are now in the section devoted to storing the actual lines of code in our program.

#in python or C, we used variables to put in data and do some computation with them
#e.g. a=1 ; b=2; c=a+b;
#here, we use the Registers as the placeholders for data.

#look at the list of available registers to the right. 
#Actually, RISCV allows separate registers for integers/characters/strings/addresses and floating points
#For the former group, the avaialble registers are 32 in Number, numbered 0 - 31
#e.g. observe that register a2 is register #12
#for cse12, we are only working with these 32 integer Registers

#now let's play with these registers!

main: 				# Label to define the main program.
#we use labels in the .text section too!
#This is so that it becomes useful for branching/jumping in out code
#without labels in .text section, loops and functions would be impossible!

#Note:Just because we snuck in a label at a particular place in our code does NOT...
#..mean that we HAVE to use it for branching/jumping.

#We look at labels more closely in multiply.asm

	li a7,4 
	#this means a7=4
	#li means "load immediate"
	# here, we are loading a7 with the immediate(constant) value 4
#YOU MUST NEVER INITIALISE THE REGISTERS sp AND PROGRAM COUNTER pc EVER IN YOUR PROGRAM!
	
	la a0, greeting
	#a0 contains the address where "Hello World" is stored
	#la means "load address"
	#here, we are loading a0 with the address of the data item...
	#... with label greeting
	#e.g. if address 8000 in meory conatins "Hello World"...
	#.. then a0=8000 in this example
	
	#NOTE: DO NOT confuse between li and la instructions!
	
	#So how do we print to terminal in RISC assembly?
	# we use this thing called an ecall (exception/system call)
	#it is actually a function that cals the OS
	
#To learn the full scope of ecalls, visit
#https://github.com/TheThirdOne/rars/wiki/Environment-Calls

#as per the above site, to print a string, we need to set a7=4 and a0= string address label
#We already just did this!

	ecall 		
	#now we issue the ecall. This outputs the greeting string on Run I/O window.
	
	#now we need to exit our program
	
#as per the above site, to exit, we need to set a7=10 
Exit:	li a7, 10 	# Load a 10 (exit) into a0.
	ecall 		# The program exits and ends.

#-------End of .text section!---------

#Now that you have read the code, assemble the code!
#Click Assemble (Wrench and screwdriver icon)
#If the Run Buttom becomes green , assembly is successful
#Click on the Run button
#Voila, Hello world!



