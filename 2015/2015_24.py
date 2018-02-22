


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

packages = [1, 2, 4, 5, 9]

t = 15

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


def get_subsets(set, sspm, t, subsets): #gets all subsets from subset sum problem matrix for sum t

	if (not sspm[-1][-1]): #do we have a subset (is the last last cell True)
		return (None) #no subset
	else: #there is a subset
		j = t

		for i in range(1, len(sspm)):
			if (set[i-1] <= t): #if element on left side can fit into remaining sum (isnt too big)
				if (sspm[i][j]): #if cell is true (can be part of the partition to make sum)

					new_t = t - set[i-1]

					subsets.append(set[i-1])

					if (new_t > 0): #if the remaining sum more than 0 we go deeper
						get_subsets(set, sspm, t-set[i-1], subsets)

		return (subsets) #how to make the sets in recursion ??? can just go over for loop and after we find all possiblities we go deeper (parallel)


out = make_sspm(packages, t)

ss = get_subsets(packages, out, t, [])

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