#Note that this file only contains a function xyCoordinatesToAddress
#As such, this function should work independent of any caller funmction which calls it
#When using regisetrs, you HAVE to make sure they follow the register usage convention in RISC-V as discussed in lectures.
#Else, your function can potentially fail when used by the autograder and in such a context, you will receive a 0 score for this part

xyCoordinatesToAddress:
	#(x,y) in (a0,a1) arguments
	#a2 argument contains base address
	#returns pixel address in a0
	
	#since this is leaf function, no need to preserve ra 
	
	#Enter code below!
	#make sure to return to calling function after putting correct value in a0!
	
	li t0, 0	# Iniializes Register t0 for looping 
	li t2, 0	# Iniializes Register t2 for looping
	
	j checkxLoop	# Starts the Loop

xLoop:
	
	addi a2, a2, 4		# Adds 4 to a2 (memory adress) each time in order to move right by 1
	addi t0,t0,1		# Increments 1 to the X loop counter
	j checkxLoop		# Jumps to check the X loop
	
checkxLoop:
	blt t0, a0, xLoop	# If t0 is less than a0, it will jump back to xLoop
	j checkyLoop		# Jumps to Check Y Loop
	
	
yLoop:
	#sw a2, 128(a2)
	addi a2, a2, 128	# Adds 128 to a2 (memory adress) each time in order to move down by 1
	addi t2,t2,1		# Increments 1 to the Y loop counter
	j checkyLoop		# Jumps to check the Y loop
	
checkyLoop:
	blt t2, a1, yLoop	# Jumps to yLoop if t2 is less than a1
	mv a0, a2		# Moves a2 temp adress into a0
	ret			# Returns (jal)
