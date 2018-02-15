


with open('input2015_22.txt', 'r') as myfile:
	input = myfile.read().split('\n')

for i in input:
	print(i)


"""
idea: Classes again. Player (subclass of Entity) has methods for all the spells (and timers for them)
the combinations are the sequences of attacs (there are quite a few possible) (HOW WILL THEY BE PASSED TO THE CLASS, OR ARE THERE MORE INSTANCES OF SAME CLASS???)
(calling a objects method by its name???)
the best combination is the one which spends the least ammount of mana (rechargins is not counted as negative spending)

probably depth-first-search (at each branching we go till we win or lose, than we backtract till the point which still has an unvisitited branching)
We will still have to go over all of the branching to be sure we found the one with the smallest spending
"""