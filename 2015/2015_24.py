


#starting vars
packages = []
t = 0




with open('input2015_24.txt', 'r') as myfile:
	input = myfile.read().split('\n')

s = 0
for i in input:
	packages.append(int(i))

t = sum(packages) // 3



#test

packages = [1, 1, 1, 2, 2, 5, 10]

t = 10

nums = [[False  if i!=0 else True for i in range(t+1)] for i in range(len(packages))] #makes 2d array used for solving subset sum problem with dynamic programing


def make_sspm(set, t): #makes a matrix. if last last cells is True we have at least one subset that sums to t

	arr = [[False  if i!=0 else True for i in range(t+1)] for i in range(len(set))] #makes 2d array of t+1 columns, and len(set) rows
	arr.insert(0, [False if i!=0 else True for i in range(t+1)])

	#this is suset sum problem solving algorithm
	for i in range(1, len(arr)): #for each row starting at 1 (we have header row)
		for j in range(1, len(arr[i])): #for each column starting at 1 (we have 0-th sum column)
			if (j-set[i-1] >= 0): #if not outside borders (number in set not bigger than the currently wanted sum)
				arr[i][j] = arr[i-1][j] or arr[i-1][j - set[i-1]]
			else: #incudes those who would be outside borders and sets them correctly (only regarding the cell above)
				arr[i][j] = arr[i-1][j] 

	return (arr) #returns the made matrix


def get_subsets(in_set, sspm, t, max_i, subsets): #gets all subsets from subset sum problem matrix for sum t, recursivly

	r_set = set()

	if (sspm[len(sspm)-1][len(sspm[0])-1]): #we have subset

		j = t

		for i in range(1, max_i):
			if (in_set[i-1] <= t):
				if (sspm[i][j]):
					r_set.add(i)

		for i in r_set:
			#print(r_set, str(in_set[i-1])+","+"("+str(t)+")")
			subsets += str(in_set[i-1])+"("+str(t)+")"+","
			if (t-in_set[i-1] == 0):
				#print(";")
				subsets += ";"
			subsets = get_subsets(in_set, sspm, t-in_set[i-1], i, subsets)
		
		
		return (subsets)
	else:
		return (None)


out = make_sspm(packages, t)

for i in out:
	print(i)

ss = get_subsets(packages, out, t, len(out), "")

print(ss)


"""
this is interesting
for now the ideas:
	 Knapsack problem
	 partition problem
	 3-partition problem
	 subset sum problem (dynamic programing) (sum//3)

	 (now you see why you need the knowledge of algorithems and data structures)
"""

"""
i've noticed that the more comlex the problem is, the uglier and unorganized my code is.
this can probably be solved with rewriting the code and thus through iterations improve it, but is somewhat stupid to do if not necessary
(of course it is fine if something is overengeneered and it isn't working).
other option is to plan the program. to first analize the problem, create a strategy for solving it and do it.
thus the code is way more organized, and straight-forward without weird turns that were repurposed after seeint they lead nowhere

I NDEED TO FIND A WAY OF PLAING THAT WORKS FOR ME (actual physical proces to become a habbit)
"""