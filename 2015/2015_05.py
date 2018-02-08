import re

#1) at least 3 vowels (a, e, i, o, u)
#2) at least one appearance of double letter
#3) not containint 'ab', 'cd', 'pq' or 'xy'

#starting number of nice words for old rules
number1 = 0

#starting number of nice words for new rules
number2 = 0


with open('input2015_05.txt', 'r') as myfile:
	input = myfile.read().split('\n')


def num_vowels(s): #mumber of vowels in string
	return (len(re.findall(r'[aeiou]', s))) #list of all the vowels

def repeating_chars(s): #are there repeating characters in string (at least two in a row)
	return (not (re.search(r'([a-z])\1{1}', s) is None)) #object (MatchObject) where same character repeast itself

def forbidden_strings(s): #are there forbidden substrings in string
	return (len(re.findall(r'(ab)|(cd)|(pq)|(xy)', s)) >= 1) #list of substrings matching the given ones


def nonoverlapping_pairpairs(s): #contains a nonoverlapping pair of two letters
	return (not (re.search(r'([a-z]{2}).*\1', s) is None)) #object (MatchObject) which begins and ends with the same two characters with any number of characters in between
	
def symmetry(s): #contains two of the same letter with one letter in between (can be the same letter)
	return (not (re.search(r'([a-z]).\1', s) is None)) #object (MatchObject) which begins and ends with the same characther and has one (any) charachter in between the two


for i in input:
	vow = num_vowels(i)
	rep = repeating_chars(i)
	frb = forbidden_strings(i)
	
	if (vow>=3 and rep==True and frb==False): #(vow>=3 and rep and not frb)
		number1 += 1


	npp = nonoverlapping_pairpairs(i)
	sym = symmetry(i)

	if (npp==True and sym==True):
		number2 += 1

print("1. number of nice words for old rules: ", number1)
print("2. number of nice words for new rules: ", number2)