

#placehodler for values
values = {}

with open('input2015_07.txt', 'r') as myfile:
	input = myfile.read().split('\n')


for i in input:
	i_list = i.split(' ')

	if (i_list[1] == '->'):
		if (i_list[0].isdigit()):
			values[i_list[2]] = int(i_list[0])
		else:
			values[i_list[2]] = i_list[0]

	elif (i_list[0] == 'NOT'):
		values[i_list[3]] = "NOT " + i_list[1]
	elif (i_list[1] == 'AND'):
		values[i_list[4]] = i_list[0] + " AND " + i_list[2]
	elif (i_list[1] == 'OR'):
		values[i_list[4]] = i_list[0] + " OR " + i_list[2]
	elif (i_list[1] == 'LSHIFT'):
		values[i_list[4]] = i_list[0] + " LSHIFT " +  i_list[2]
	elif (i_list[1] == 'RSHIFT'):
		values[i_list[4]] = i_list[0] + " RSHIFT " +  i_list[2]


#for the second part
values2 = values.copy()


def get_value(pos, dic):
	if (pos.isdigit()): #fixed value for operators (x AND 1, x LSHIFT 2)
		return (int(pos))
	elif (type(dic[pos]) == int): #value
		return (dic[pos])
	else:
		command = dic[pos].split(' ')

		if (len(command) == 1): #variable
			val = get_value(command[0], dic)
			dic[pos] = val
		elif (len(command) == 2): #not
			val = get_value(command[1], dic)
			dic[pos] = ~ val
		elif (len(command) == 3):
			if (command[1] == 'AND'): #and
				val1 = get_value(command[0], dic)
				val2 = get_value(command[2], dic)
				dic[pos] = val1 & val2
			elif (command[1] == 'OR'): #or
				val1 = get_value(command[0], dic)
				val2 = get_value(command[2], dic)
				dic[pos] = val1 | val2
			elif (command[1] == 'LSHIFT'): #lshift
				val1 = get_value(command[0], dic)
				val2 = get_value(command[2], dic)
				dic[pos] = val1 << val2
			elif (command[1] == 'RSHIFT'): #rshift
				val1 = get_value(command[0], dic)
				val2 = get_value(command[2], dic)
				dic[pos] = val1 >> val2

		return (dic[pos])



print("1. the value of a in the circuit: ", get_value("a", values))

#second part
values2["b"] = get_value("a", values)

print("2. the value of a after the change of b: ", get_value("a", values2))
