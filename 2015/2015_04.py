import hashlib

#input string to which we add smallest integer so that the md5 hash has at least 5 leading zeros
input = "iwrupvqb"

#starting integer
integer = 1

found5 = False
found6 = False

while (not found5 or not found6):
	hash_input_string = input + str(integer)
	hash = hashlib.md5(hash_input_string.encode('utf-8')).hexdigest()

	if (not found5 and hash[0:5] == '00000'):
		print("1. input string for md5 hash with 5 leading zeros: ", hash_input_string, " -> output: ", str(integer))
		found5 = True

	if (not found6 and hash[0:6] == '000000'):
		print("2. input string for md5 hash with 6 leading zeros: ", hash_input_string, " -> output: ", str(integer))
		found6 = True

	integer += 1