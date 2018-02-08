import re

#previous password
input = "hepxcrrq"

"""
for i in range(len(s)-1, -1, -1): #s[::-1]
		print(s[i])
"""

def increment(s, pos): #icnreases the string
	if (pos == -1):
		return (s)

	c = ord(s[pos]) + 1 #gets the ascii value of the char at pos and increases it by 1

	if (c > 122): # if value over z, sets it to a (wrap around)
		c = 97
		s = increment(s, pos-1) #and increases the value of the pos infront

	s = s[:pos] + chr(c) + s[pos+1:] #makes a new string with new value

	return (s)


	
for i in range(10):
	input = increment(input, len(input)-1)
	print(input)