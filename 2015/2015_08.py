import re
import binascii


#staring lenghts
code_len = 0
string_len = 0

#part two length
encoded_len = 0


with open('input2015_08.txt', 'r') as myfile:
	input = myfile.read().split('\n')


def code_to_string(s):
	#removes " quotes at the beginning and at the end
	s = re.sub(r'^\"(.*)\"$', r'\1', s)

	#replaces the '\x__' in code with appropriate characters
	h = re.finditer(r'\\x([0-9a-f]{2})', s) #makes iterator with all matches
	if h: #if anything was found
		k = re.findall(r'\\x([0-9a-f]{2})', s) #makes list of all hex codes found
		n = 0 # needed for k (because h is iteratro, cant be indexed)
		for i in h: #for every object in iterator
			s = s[:i.start()-3*n] + chr(int(k[n], 16)) + s[i.end()-3*n:] #makes new string from begining till the start of found substring + char of the appropriate hex code + string from the end of found substirng till the end
			n += 1 


	#replaces all \\ and \" with \ and "
	s = re.sub(r'\\([\\\"])', r'\1', s)

	return(s)



def string_to_code(s):
	#replaces all \ and " with \\ and \"
	s = re.sub(r'([\\\"])', r'\\\1', s)

	# encapsulates the entire string in ""
	s = re.sub(r'^(.*)$', r'"\1"', s) #i'm not sure why here the " is not given as escape character

	return (s)


for i in input:
	code_len += len(i)
	string_len += len(code_to_string(i))
	encoded_len += len(string_to_code(i))


print("1. the difference of code lenght and string lenght: ", code_len-string_len)
print("2. the difference of further encoded code lenght and code lenght: ", encoded_len-code_len)