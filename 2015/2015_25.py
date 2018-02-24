


#starting vars 
row = 0
column = 0

codes = [[20151125,]] #we create the 2d array with the starting code



with open('input2015_25.txt', 'r') as myfile:
	input = myfile.read()

i_list = input.split() #we read the input for the 2 valuable inputs

row = int(i_list[-3][:-1]) - 1 #-1 because we start counting with 0
column = int(i_list[-1][:-1]) - 1


def new_number(n): #makes a new code from the previous one
	return (n * 252533 % 33554393)


def new_diagonal(c): #adds a new diagonal in the 2d array
	old_n = c[0][-1] #we first find the last number
	
	c.append([]) #create a new dimension

	for i in range(len(c)-1, -1, -1): #and from back to front append a new value
		new_n = new_number(old_n)
		c[i].append(new_n)
		old_n = new_n #and make sure we replace old with new


for i in range(row + column): #we create enough diagonals our cooridnates fit (without -1 because we start counting with 0)
	new_diagonal(codes)

print("1. the code to the weathe machine: ", codes[row][column])

#new diagonal idea: new row, and than from the back we append in every

"""
That was extremly fun. TY Eric Wastl!
"""