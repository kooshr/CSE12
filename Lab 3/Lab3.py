user_in = int(input("Enter the height of the pattern (must be greater than 0):"))
while(user_in <1):
    print("Invalid Entry")
    user_in = int(input("Enter the height of the pattern (must be greater than 0):"))
for i in range(user_in):
    for j in range(i):
        print("$*",end='')
    print("$0")

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