

input = "3113322113"

"""
idea:
mamo neko spremenljivko current letter, ki če je nova števka ista kot prejšna samo poveča counter, če pa je različna pa se zgodi zapis counterja pa števke
torej rabmo met tud counter

pol mamo pa neko spremenljivko new input, kamor dajemo te zapise in ob koncu iteracije čež input prepišemo new input na input

to naredimo 40-krat

TO JE FUL POCAS, OZ JE ZLO CASOVNO ZAHTEVNO, SPLOH DODATNIH 10
"""

for k in range(40):
	#helping vars
	current = ""
	counter = 0

	new_input = ""

	for i in range(len(input)-1):
		if (current == ""):
			current = input[i]
			counter = 1
		
		if (input[i+1] == input[i]):
			counter += 1
		else:
			new_input = new_input + str(counter) + current
			current = input[i+1]
			counter = 1

	new_input = new_input + str(counter) + current

	input = new_input
	print(k)

print("1. the lenght of the result after 40 iterations: ", len(input))


#second part
for k in range(10): #10 additional times (total of 50)
	current = ""
	counter = 0

	new_input = ""

	for i in range(len(input)-1):
		if (current == ""):
			current = input[i]
			counter = 1
		
		if (input[i+1] == input[i]):
			counter += 1
		else:
			new_input = new_input + str(counter) + current
			current = input[i+1]
			counter = 1

	new_input = new_input + str(counter) + current

	input = new_input
	print(k)


print("23. the lenght of the result after 50 iterations: ", len(input))