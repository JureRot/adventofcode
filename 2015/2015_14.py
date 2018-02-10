import collections


#starting vars
deer = collections.defaulfdict(dict())


with open('input2015_14.txt', 'r') as myfile:
	input = myfile.read().split('\n')


for i in input:
	i_list = i.split(' ')
	print(i_list)