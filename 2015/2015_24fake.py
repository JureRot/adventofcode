import itertools
import operator
import functools

nums = list(map(int, [line.strip("\n") for line in open('input2015_24.txt')]))
parts = 3
tot = sum(nums)/parts

def hasSum(lst, sub):
    for y in range(1,len(lst)): 
        for x in (z for z in itertools.combinations(lst, y) if sum(z) == tot):
            if sub == 2:
                return True
            elif sub < parts:
                return hasSum(list(set(lst) - set(x)), sub - 1)
            elif hasSum(list(set(lst) - set(x)), sub - 1):
                return functools.reduce(operator.mul, x, 1)
print (hasSum(nums, parts))