#starting paper area = 0
area = 0

#starting ribbon length = 0
length = 0

with open('input2015_02.txt', 'r') as myfile:
	input = myfile.read().split('\n') #lxwxh

for i in input:
	sides = i.split('x')
	sides.sort()
	l = int(sides[0])
	w = int(sides[1])
	h = int(sides[2])

	temp_area = 2 * l*w + 2 * w*h + 2 * h*l #area of all sides
	temp_area += min(l*w, w*h, h*l) #plus smallest side of redundency

	area += temp_area

	num_sides = [l, w, h]
	num_sides.sort()

	temp_length = 2*num_sides[0] + 2*num_sides[1] #smallest perimeter
	temp_length += l*w*h #the volume for the bow 

	length += temp_length

print("1. Elves need additional ", area, " square foot of wrapping paper")
print("1. Elves need additional ", length, " feet of ribbon")