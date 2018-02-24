"""
In this case the first take DID work, but it did so in a very slow way.
That was the result of the algorithm and the way that algorithm was implemented.
In thake 1 we actually find all partitions (subsets) that equal to the appopriate sum (susbet sum problem -> NP-hard)
That takesome time (plus the way I make that algorithm work (recursion) made it first output string (6MB) that needed to be further decoded)
This resulted in a very slow program (but a fun and complex one, that was a joy to tinker with)

This is just a solution for the same problem with a brute force aporoach
we find all all the smallest combinations of packages that sum to /3 or /4 (agains we presume that we can always cleanly divide the reaming)
and from those we find the one with the smalles quantum entangelement
"""
import itertools
import functools
import operator
import sys



#starting vars
packages = []
t = 0

sets = []


with open('input2015_24.txt', 'r') as myfile:
	input = myfile.read().split('\n')

s = 0
for i in input:
	packages.append(int(i))

t = sum(packages) // 3


"""
we will create all possible combinations of packages of len starting at 1 and onward.
when we get a combination that sums to t we will accept only combinations of the same len, and none that are longer
(so it is a brute force, but it stops soon, because we need to find the shortes, thus the first that we find will trigger the end (in some sense))
after that we just need to find the one with the smalles qe
"""
for i in range(1, len(packages)+1): #from 1 to number of packages
	cp = itertools.combinations(packages, i) #we create combinations (without repetitions) of that length

	found = False

	for j in cp:
		if (sum(j) == t): #the first combination with sum of t will trigger this. all combinations of the same len as the this one will string go through
			found = True
			sets.append(j)
	
	if (found): #all longer combinations will be rejected
		break
	

#we dont need to sort those combinations because we already have just the smallest one, all that reamins is to get the one withe the smalles qe, which is done same as in take 1


smallest_qe = sys.maxsize
partition = []

for i in sets:
	if (functools.reduce(operator.mul, i) < smallest_qe):
		smallest_qe = functools.reduce(operator.mul, i)
		partition = i

print("1. the quantum entanglement of the bag with the smallest ammount of packages equating to the third and the smallest entanglement: ", smallest_qe)


#second part (just different t, all done again)
t = sum(packages) // 4


for i in range(1, len(packages)+1):
	cp = itertools.combinations(packages, i)

	found = False

	for j in cp:
		if (sum(j) == t):
			found = True
			sets.append(j)
	
	if (found):
		break


smallest_qe = sys.maxsize
partition = []

for i in sets:
	if (functools.reduce(operator.mul, i) < smallest_qe):
		smallest_qe = functools.reduce(operator.mul, i)
		partition = i

print("1. the quantum entanglement of the bag with the smallest ammount of packages equating to the third and the smallest entanglement: ", smallest_qe)