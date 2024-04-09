# Assignment: Lab 3: RARS Introduction 
## About
CSE 12, Computer Systems and Assembly Language
UC Santa Cruz, Fall 2022
Created by: Ramesh, Kaushal
ID# 193976
May 15th, 2023
## Description: 
This program prints A "Right Triangle" in a pyramid shape using the ascii characters '*' '$' and '0'.
## Notes: 
This program is intended to be run from the MARS IDE.
## Pseudocode:
- Print Statement
- Get User Input
- Validate User Input
- If Invalid loop back to top
- If Valid, continue
- Loop once through the user number
- loop once more through the number we are at in the loop
- print "$*"
- print "$0"
- print "new line"
## Python Code:
```
user_in = int(input("Enter the height of the pattern (must be greater than 0):"))
while(user_in <1):
	print("Invalid Entry")
	user_in = int(input("Enter the height of the pattern (must be greater than 0):"))
for i in range(user_in):
	for j in range(i):
		print("$*",end='')
	print("$0")
```