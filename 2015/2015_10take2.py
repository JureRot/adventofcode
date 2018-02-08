import re


input = "3113322113"


"""
ideja:
najdemo vsa ponavaljanja stevilk v nizu in jih dodamo z njihovo dolzino, ostale pustimo kot 1x
"""


def look_and_say(match_object):
	s = match_object.group(1) #gets the matched string in MathcObject
	return (str(len(s)) + s[0])


for i in range(40):
	input = re.sub(r'((\d)\2*)', look_and_say, input) #calls the look_and_say function for every match and provides the function parameter as MatchObject automatically

print("1. the lenght of the result after 40 iterations: ", len(input))


#second part
for i in range(10):
	input = re.sub(r'((\d)\2*)', look_and_say, input)

print("2. the lenght of the result after 50 iterations: ", len(input))