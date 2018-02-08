import re


#staring sum
sum_all = 0


with open('input2015_12.txt', 'r') as myfile:
	input = myfile.read()


#input for second part
input2 = re.sub(r'{[^{\[]*?"red"[^}\[]*?}', r'', input) #??? removes the {_"red"_} things ???

print(re.findall(r'{[^{\[]*?"red"[^}\[]*?}', input))


f = re.findall(r'[-]*\d+', input) #makes a list of all strings with optional netation

for i in range(len(f)): #changes all strings into itegers (could be done with map() -> sum(map(int, re.findall(r'[-]*\d+', input))) )
	f[i] = int(f[i])

print("1. sum of all the numbers:", sum(f))


#second part

f2 = re.findall(r'[-]*\d+', input2)

for i in range(len(f2)): #changes all strings into itegers
	f2[i] = int(f2[i])

print("2. sum of all the numbers ignoring red:", sum(f2))

#OČITNO TO NE DELUJE IN JE TREBA NA NEK DRUGAČN NAČIN TO REŠT