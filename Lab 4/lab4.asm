#
# Bitmap Display Configuration:
# - Unit width in pixels: 8					     
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display on Bitmap: 0x10008000 (gp)
#- Base Address for retrieving word from keyboard: 0xffff0004
#
.data
#DO NOT CHANGE ANY LINE OF CODE WITHIN THIS .data SECTION!
	redColor: .word 0x00ff0000
	displayBaseAddress:	.word	0x10008000
	#note these are all ascii values below(in decimal)
	keyboard_w: .word 119
	keyboard_a: .word 97
	keyboard_s: .word 115
	keyboard_d: .word 100
	keyboard_x: .word 120
	keyboard_z: .word 122
	keyboard_q: .word 113
	keyboard_e: .word 101	
	keyboard_c: .word 99
	
	keyboardBaseAddress:	.word	0xffff0004
	readX:	.asciz "Enter starting X coordinate in the range 0 - 31: "
	readY:	.asciz "Enter starting Y coordinate in the range 0 - 31: "
	useKeyboard: .asciz "Now go to the Keyboard and Display MMIO simulator. Use the wasd (lower case) keys on your keyboard to naviagte your pixel on BITMAP display, Press x(lower case) to exit program"

.macro getCoordinates(%readXY)
#DO NOT CHANGE ANY LINE OF CODE WITHIN THIS MACRO!
	#ask user to read X/Y and read it
	li a7, 4
	la a0, %readXY
	ecall
	li a7, 5
	ecall
	#a0 now has x/y
.end_macro


.macro print_str(%str)
#DO NOT CHANGE ANY LINE OF CODE WITHIN THIS MACRO!
	#ask user to read X/Y and read it
	li a7, 4
	la a0, %str
	ecall
.end_macro

.text
#DO NOT CHANGE ANY LINE OF CODE WITHIN THIS .data SECTION!
.globl moveleft movedown moveright moveup moveDiagonalLeftUp moveDiagonalLeftDown  moveDiagonalRightUp moveDiagonalRightDown
j main
#main is the first to be called

.include "lab4_part1.asm"
#This is where we stitch in your lab4_part1.asm document!

polling:#doesn't accept arguments. only returns keystroke character data in a0
		addi sp, sp, -8
		sw s0, 4(sp)
		sw s1, 0(sp)
		
		li	s0,0xffff0000
waitloop:
		lw	s1,0(s0)	#control
		andi	s1,s1,0x0001
		beq	s1,zero,waitloop
		lw	a0,4(t0)	#data
		#put back 0 in 0xffff0000
		#addi s1, zero, 0
		#sw	s1,0(s0)
	
		lw s0, 4(sp)
		lw s1, 0(sp)
		addi sp, sp, 8
		ret
		
main:
	
	#ask user to read X and read it
	getCoordinates(readX)
	addi t1, a0, 0
	
	#ask user to read Y and read it
	getCoordinates(readY)
	
	# make a0=x and a1=y
	addi a1, a0, 0 #a1=y
	addi a0, t1, 0 #a0=x
	lw a2, displayBaseAddress 
	#are you surprised by this new syntax surrounding lw?
	#Don't be! Here lw is being used as a pseudo instruction.
	#It is directly loading the word with the given label in statid data into a2 register
	
	#store initial x y displayBaseAddress(a2) to stack
	addi sp, sp, -12
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	
	#call xyCoordinatesToAddress
	jal xyCoordinatesToAddress
	#return with pixel address in a0
	
	lw t1, redColor	# t1 stores the red colour code
	sw t1, 0(a0)
	#bitmap now shows the red color at(x,y)
	
	#display prompt on console:
	print_str(useKeyboard)
	
	#retrieve x y base address from stack
	#this is because in print_str we overwrote a0!
	#in general, after returning from a function call and..
	#..before again using the a registers, we should always retreieve the older values we stored
	lw a0, 0(sp)
	lw a1, 4(sp)
	lw a2, 8(sp)
	addi sp, sp, 12
	
	lw t3, keyboard_w
	lw t4, keyboard_a
	lw t5, keyboard_s
	lw t6, keyboard_d
	
	#none of wasd were hit? :( How about the diagonal keys?
	lw a3, keyboard_q
	lw a4, keyboard_z
	lw a5, keyboard_e
	lw a6, keyboard_c
	
	
movePixelThroughKeyboard:

	#get ready to do polling to accept input from Keyboard MMIO simulator
	
	#set oxffff0000 location to 0
	li t0, 0xffff0000
	sw zero, 0(t0)
	
	#store initial x y displayBaseAddress(a2) to stack
	addi sp, sp, -12
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	
	jal polling

	#return from polling with keystroke data in a0
	addi t2, a0,0
	
	#retrieve x y base address from stack
	lw a0, 0(sp)
	lw a1, 4(sp)
	lw a2, 8(sp)
	addi sp, sp, 12
	
	#compare t2 with t3-t6 and respectvely do the right thing
	beq t2,t3, moveup
	beq t2,t4, moveleft
	beq t2,t5, movedown
	beq t2,t6, moveright
	

	
	beq t2,a3, moveDiagonalLeftUp
	beq t2,a4, moveDiagonalLeftDown
	beq t2,a5, moveDiagonalRightUp
	beq t2,a6, moveDiagonalRightDown
	
	#oops!user did not enter either of w,a,s,d,q,z,e,c inputs
	#was x then entered? Let's find out!
	lw t6, keyboard_x
	#if so, then bye bye!
	beq t2,t6, Exit
	
	.include "lab4_part2.asm"
	#This is where we stitch in your lab4_part2.asm document!
	
	
	j movePixelThroughKeyboard
	#if neither of w,a,s,d,x entered, we keep on waiting for a valid keystroke
	
	
newPosition:
	#change bitmap display with updated (x,y) values
	
	#store initial x y displayBaseAddress(a2) to stack
	addi sp, sp, -12
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	
	#call xyCoordinatesToAddress
	jal xyCoordinatesToAddress
	#return with pixel address in a0 and display pixel there
	sw t1, 0(a0)
	#pixel at address stored in a0 now holds color red
	
	#retrieve x y base address from stack
	lw a0, 0(sp)
	lw a1, 4(sp)
	lw a2, 8(sp)
	addi sp, sp, 12
	
#now let's repeat the loop	
j movePixelThroughKeyboard

Exit:
	li a7, 10 # terminate the program gracefully
	ecall
        
