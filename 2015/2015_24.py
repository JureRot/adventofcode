





with open('input2015_24.txt', 'r') as myfile:
	input = myfile.read().split('\n')

s = 0
for i in input:
	print(i)
	s += int(i)

print(s)

"""
this is interesting
for now the ideas:
	 Knapsack problem
	 partition problem
	 3-partition problem
	 subset sum problem (dynamic programing) (sum//3)

	 (now you see why you need the knowledge of algorithems and data structures)
"""