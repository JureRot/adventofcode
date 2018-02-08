import re

#previous password
input = "hepxcrrq"


def increment(s, pos): #icnreases the string
	if (pos == -1):
		return (s)

	c = ord(s[pos]) + 1 #gets the ascii value of the char at pos and increases it by 1

	if (c > 122): # if value over z, sets it to a (wrap around)
		c = 97
		s = increment(s, pos-1) #and increases the value of the pos infront

	s = s[:pos] + chr(c) + s[pos+1:] #makes a new string with new value

	return (s)


def has_incr_straight(s):
	for i in range(len(s)-2):
		if (ord(s[i])+1 == ord(s[i+1]) and ord(s[i+1])+1 == ord(s[i+2])):
			return (True)

	return (False)


def has_iol(s): #does string have i, o or l letters (true if yes)
	if (re.findall(r'[iol]', s)):
		return (True)

	return (False)



def has_pairpair(s): #does string have a non-overlapping pair of pairs of different letters (aa_bb) (true if yes)
	if (re.findall(r'(\w)\1.*((?!\1)\w)\2', s)): #mathces every substring that starts with two of the same character and ends with two of the same characters that arent the same as the first. In between there can be 0 or more characters
		return (True)

	return (False)


while (True):
	input = increment(input, len(input)-1)

	if (has_incr_straight(input) and not has_iol(input) and has_pairpair(input)): #until the psswd with increasin straight, without i/o/l and with different pair of pairs of letters is found
		break

print("1. next password suitable: ", input)

while (True):
	input = increment(input, len(input)-1)

	if (has_incr_straight(input) and not has_iol(input) and has_pairpair(input)):
		break

print("2. next next password suitable: ", input)